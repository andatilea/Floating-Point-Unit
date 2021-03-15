
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FPMultiplicator is
    Port ( x : in STD_LOGIC_VECTOR (31 downto 0);
           y : in STD_LOGIC_VECTOR (31 downto 0);
           underflow,overflow: out std_logic;
           p : out STD_LOGIC_VECTOR (31 downto 0));
end FPMultiplicator;

architecture Behavioral of FPMultiplicator is

--input components
signal sign_x, sign_y : std_logic;
signal exponent_x, exponent_y : std_logic_vector( 7 downto 0);
signal mantissa_x, mantissa_y : std_logic_vector(24 downto 0);

signal sub_bias : std_logic_vector(7 downto 0) := "10000001";   -- (-127)
signal bias : std_logic_vector(7 downto 0) := "01111111";       -- (127)

signal mantissaProduct : std_logic_vector(47 downto 0);

signal unbiasedExponent_x, unbiasedExponent_y, unbiasedExponent : std_logic_vector(7 downto 0);
-- exponent not normalized
signal exponent_temp : std_logic_vector(7 downto 0);
signal normalized : std_logic_vector(7 downto 0);

-- output components which compose the output
signal sign_p: std_logic;
signal exponent_p : std_logic_vector(7 downto 0);
signal mantissa_p : std_logic_vector( 22 downto 0);

--componnent for mantissa multiplication
component multiplierComponent is
    Port ( x : in STD_LOGIC_VECTOR (24 downto 0);
           y : in STD_LOGIC_VECTOR (24 downto 0);
           p : out STD_LOGIC_VECTOR (47 downto 0));
end component;

---component for exponent addition
component adderComponent is
    Port ( x : in STD_LOGIC_VECTOR (7 downto 0);
           y : in STD_LOGIC_VECTOR (7 downto 0);
           Cout : out std_logic;
           s : out STD_LOGIC_VECTOR (7 downto 0));
end component;

signal Cout_1, Cout_2 : std_logic := '0';

begin

--extract components
sign_x <= x(31);
sign_y <= y(31);

exponent_x <= x(30 downto 23);
exponent_y <= y(30 downto 23);

mantissa_x <= "01" & x(22 downto 0);
mantissa_y <= "01" & y(22 downto 0);

mul_component: multiplierComponent PORT MAP ( x =>  mantissa_x, y => mantissa_y, p => mantissaProduct);


normalization_check: process(mantissaProduct)
begin
    if mantissaProduct(47) = '1' then  
        -- it needs normalization        
        mantissa_p <= mantissaProduct(46 downto 24);
    else
        -- normalization is not needed
        mantissa_p <= mantissaProduct(45 downto 23);
    end if;
end process;

-- normalization depends of the mantissa's first bit
normalized <= "0000000" &  mantissaProduct(47);

--compute the addition of the exponents 
-- subtract the bias from the first exponent
reduce_bias1: adderComponent PORT MAP( x => exponent_x, y => sub_bias, s => unbiasedExponent_x);     
-- subtract the bias from the second exponent
reduce_bias2: adderComponent PORT MAP( x => exponent_y, y => sub_bias, s => unbiasedExponent_y);
-- add the two exponents     
add_exp: adderComponent PORT MAP( x => unbiasedExponent_x, y => unbiasedExponent_y, s => unbiasedExponent); 
-- add the bias to the obtained sum
add_bias: adderComponent PORT MAP(x => unbiasedExponent, y => bias, cout => Cout_1, s => exponent_temp);
-- normalize final exponent
add_normalization : adderComponent PORT MAP (x => exponent_temp, y => normalized, cout => Cout_2, s => exponent_p);

--compute the sign of the result
sign_p <= sign_x xor sign_y;

specialCases: process(sign_p,exponent_p,mantissa_p)
begin

-- if one element is normal and one is +0
if x = "00000000000000000000000000000000" or y = "00000000000000000000000000000000" then
-- then the product will always be +0
p <= "00000000000000000000000000000000";

-- if one element is normal and one is -0
elsif x = "10000000000000000000000000000000" or y = "10000000000000000000000000000000" then
-- then the product will always be -0
p <= "10000000000000000000000000000000";

-- if the first element is + infinity 
elsif x = "01111111100000000000000000000000" then
    -- if both elements are + infinity
    if x = "01111111100000000000000000000000" and y = "01111111100000000000000000000000" then
    -- then the result will always be NaN
    p <= "01111111110000000000000000000000";
    -- if the first element is + infinity and the other is NaN
    elsif x = "01111111100000000000000000000000" and y = "01111111110000000000000000000000" then
    -- then the result will always be NaN
    p <= "01111111110000000000000000000000";
    else
    -- if the second element is normal -> the result will always be + infinity
    p <= "01111111100000000000000000000000";
    end if;

-- if the first element is - infinity and the other one is normal
elsif x = "11111111100000000000000000000000" then
    -- if both elements are - infinity
    if x = "11111111100000000000000000000000" and y = "11111111100000000000000000000000" then
    -- then the result will always be NaN
    p <= "01111111110000000000000000000000";
    -- if one element is - infinity and the other is NaN
    elsif x = "11111111100000000000000000000000" and y = "01111111110000000000000000000000" then
    -- then the result will always be NaN
    p <= "01111111110000000000000000000000";
    else
    -- if the second element is normal -> the result will always be - infinity
    p <= "11111111100000000000000000000000";
    end if;


-- if one element is normal and one is NaN
elsif x = "01111111110000000000000000000000" or y = "01111111110000000000000000000000" then
-- then the product will always be NaN
p <= "01111111110000000000000000000000";

else 
 p <= sign_p & exponent_p & mantissa_p;
end if;
end process;

-- handle overflow and underflow problems
handle_cases: process(exponent_temp, exponent_p, Cout_1, Cout_2, sign_p, mantissa_p)
begin
    if (x /= "01111111110000000000000000000000" and y /= "01111111110000000000000000000000") and (x /= "01111111100000000000000000000000" and y /= "01111111100000000000000000000000") and (x /= "11111111100000000000000000000000" and y /= "11111111100000000000000000000000") and ( x /= "00000000000000000000000000000000" and y /= "00000000000000000000000000000000") and ( x /= "10000000000000000000000000000000" and y /= "10000000000000000000000000000000") and (Cout_1 = '1' or Cout_2 = '1') then
        if exponent_p(7) = '0'  then
            overflow <= '1';   
            underflow <= '0'; 
          
              
       else
            overflow <= '0';    
            underflow <= '1';  
        end if;
    else
        overflow <= '0';
        underflow <= '0';
    end if;
end process;

end Behavioral;
