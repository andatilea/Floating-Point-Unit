
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity FPDivider is
    Port ( x : in STD_LOGIC_VECTOR (31 downto 0);
           y : in STD_LOGIC_VECTOR (31 downto 0);
           underflow : out std_logic;
           d : out STD_LOGIC_VECTOR (31 downto 0));
end FPDivider;

architecture Behavioral of FPDivider is

-- input components
signal sign_x, sign_y : std_logic := '0';
signal exponent_x, exponent_y : std_logic_vector( 7 downto 0) := (others => '0');
signal mantissa_x, mantissa_y : std_logic_vector(23 downto 0);

signal sub_bias : std_logic_vector(7 downto 0) := "10000001" ;
signal bias : std_logic_vector(7 downto 0) := "01111111" ;

-- exponent not normalized
signal unbiasedExponent_x, unbiasedExponent_y, unbiasedExponent : std_logic_vector(7 downto 0) := (others => '0');

signal exponent_temp : std_logic_vector(7 downto 0) := (others => '0');
signal normalized : std_logic_vector(7 downto 0) := (others => '0');
-- value from the division component;
signal div_normalization : std_logic_vector(5 downto 0) := (others => '0');

-- transform the unibased exponent of y in it's 2's complement to obtain the "subtraction" of exponents;
signal neg_exponentY: std_logic_vector(7 downto 0) := (others => '0');

-- output components
signal sign_d : std_logic:= '0';
signal exponent_d : std_logic_vector(7 downto 0) := (others => '0');
signal mantissa_d : std_logic_vector( 22 downto 0) := (others => '0');

--componnent for mantissa division
component divisionComponent is
    Port ( X : in STD_LOGIC_VECTOR (23 downto 0);
           Y : in STD_LOGIC_VECTOR (23 downto 0);
           normalize : out std_logic_vector(5 downto 0);
           d : out STD_LOGIC_VECTOR (22 downto 0));
end component divisionComponent;

---component for exponent subtraction
component adderComponent is
    Port ( x : in STD_LOGIC_VECTOR (7 downto 0);
           y : in STD_LOGIC_VECTOR (7 downto 0);
           Cout : out std_logic;
           s : out STD_LOGIC_VECTOR (7 downto 0));
end component adderComponent;

signal Cout_1, Cout_2 : std_logic := '0';

begin

--extract number components
sign_x <= x(31);
sign_y <= y(31);

exponent_x <= x(30 downto 23);
exponent_y <= y(30 downto 23);

mantissa_x <= '1' & x(22 downto 0);
mantissa_y <= '1' & y(22 downto 0);

--compute the division of the mantissas
div_component: divisionComponent PORT MAP ( x => mantissa_x, y => mantissa_y, normalize => div_normalization,   d => mantissa_d);

normalization_check: process(div_normalization)
begin
    if div_normalization = 0 then
    normalized <= "00" & div_normalization;
    else
    normalized <= "11" & div_normalization; -- negative number;
    end if;
end process;

-- transform the exponent for perfoming the exponent subtraction;
neg_exponentY <= (not unbiasedExponent_y) + 1;

-- subtract the bias from the first exponent
reduce_bias1: adderComponent PORT MAP( x => exponent_x, y => sub_bias, s => unbiasedExponent_x);      -- we need to to them in this order in order to not get an overflow
-- subtract the bias from the second exponent
reduce_bias2: adderComponent PORT MAP( x => exponent_y, y => sub_bias, s => unbiasedExponent_y);      -- we need to to them in this order in order to not get an overflow
-- subtract the two exponents;
add_exp: adderComponent PORT MAP( x => unbiasedExponent_x, y => neg_exponentY, s => unbiasedExponent); 
-- add the bias to the obtained sum
add_bias: adderComponent PORT MAP(x => unbiasedExponent, y => bias, Cout => Cout_1, s => exponent_temp);
-- normalize final exponent
add_normalization: adderComponent PORT MAP (x => exponent_temp, y => normalized, Cout => Cout_2, s => exponent_d);

--compute the sign of the result
sign_d <= sign_x xor sign_y;

specialCases: process(sign_d,exponent_d,mantissa_d)
begin

-- if the first element is +0 and the other one is normal
if x = "00000000000000000000000000000000" then
-- then the result will always be +0
d <= "00000000000000000000000000000000";

-- if the first element is -0 and the other one is normal
elsif x = "10000000000000000000000000000000" then
-- then the result will always be -0
d <= "10000000000000000000000000000000";

-- if the first element is + infinity 
elsif x = "01111111100000000000000000000000" then
    -- if both elements are + infinity
    if x = "01111111100000000000000000000000" and y = "01111111100000000000000000000000" then
    -- then the result will always be NaN
    d <= "01111111110000000000000000000000";
    -- if the first element is + infinity and the other is NaN
    elsif x = "01111111100000000000000000000000" and y = "01111111110000000000000000000000" then
    -- then the result will always be NaN
    d <= "01111111110000000000000000000000";
    else
    -- if the second element is normal -> the result will always be + infinity
    d <= "01111111100000000000000000000000";
    end if;
    
-- if the first element is - infinity and the other one is normal
elsif x = "11111111100000000000000000000000" then
    -- if both elements are - infinity
    if x = "11111111100000000000000000000000" and y = "11111111100000000000000000000000" then
    -- then the result will always be NaN
    d <= "01111111110000000000000000000000";
    -- if one element is - infinity and the other is NaN
    elsif x = "11111111100000000000000000000000" and y = "01111111110000000000000000000000" then
    -- then the result will always be NaN
    d <= "01111111110000000000000000000000";
    else
    -- if the second element is normal -> the result will always be - infinity
    d <= "11111111100000000000000000000000";
    end if;


-- if one element is normal and one is NaN
elsif x = "01111111110000000000000000000000" or y = "01111111110000000000000000000000" then
-- then the result will always be NaN
d <= "01111111110000000000000000000000";

-- if one element is normal and the other one is +0
elsif y = "00000000000000000000000000000000" then
-- the result will always be + infinity
d <= "01111111100000000000000000000000";

-- if one element is normal and the other one is -0
elsif y = "10000000000000000000000000000000" then
-- the result will always be - infinity
d <= "11111111100000000000000000000000";

-- if one element is normal and the other one is + infinity
elsif y = "01111111100000000000000000000000" then
-- the result will always be +0
d <= "00000000000000000000000000000000";

-- if one element is normal and the other one is - infinity
elsif y = "11111111100000000000000000000000" then
-- the result will always be -0
d <= "10000000000000000000000000000000";

else
d <= sign_d & exponent_d & mantissa_d;
end if;
end process;

-- handle the underflow problem
handle_case: process(Cout_1, Cout_2)
begin
    if (x /= "01111111110000000000000000000000" and y /= "01111111110000000000000000000000") and (x /= "01111111100000000000000000000000" and y /= "01111111100000000000000000000000") and (x /= "11111111100000000000000000000000" and y /= "11111111100000000000000000000000") and ( x /= "00000000000000000000000000000000" and y /= "00000000000000000000000000000000") and ( x /= "10000000000000000000000000000000" and y /= "10000000000000000000000000000000") and (Cout_1 = '1' or Cout_2 = '1') then
    underflow <= '1';   -- to small to represent;
    else 
    underflow <= '0';
    end if;
end process;

end Behavioral;
