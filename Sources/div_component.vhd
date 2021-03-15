
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.STD_LOGIC_ARITH.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity divisionComponent is
     Port (x : in STD_LOGIC_VECTOR (23 downto 0);
           y : in STD_LOGIC_VECTOR (23 downto 0);
           normalize : out std_logic_vector(5 downto 0);
           d : out STD_LOGIC_VECTOR (22 downto 0));
end divisionComponent;

architecture Behavioral of divisionComponent is

begin

process(x,y)

-- doubled in size for a higher accuracy;
variable temp_x, temp_y : std_logic_vector(47 downto 0) := (others => '0');  
variable result : std_logic_vector(47 downto 0) := (others=> '0');
variable normalized : std_logic_vector(5 downto 0) := (others => '0');

variable decimal_p : INTEGER := 0;
variable y_len : INTEGER := 0;
variable result_point : INTEGER := 0;

begin
    temp_x := (others => '0');
    temp_y := (others => '0');
    temp_x(47 downto 24) := x;
    temp_y(47 downto 24) := y;
    result := (others => '0');
    -- initialize the result's decimal point as being on the first position;
    result_point := 47; 
    -- a loop for all the bits in the input;
    for i in 23 downto 0 LOOP   
        -- we find the lowest significant '1' in the divisor;
        if y(i) = '1' then   
            -- then we know the decimal point will be on that position;   
            decimal_p := i;
            y_len := 23 - i ;
        end if;
    end loop;
    --we need to transform the decimal point position;
    decimal_p := decimal_p + 24;
    -- we start the division steps:
    -- check if the divisor can be contained by the divident
    if temp_x(47 downto decimal_p) >= temp_y(47 downto decimal_p) then   
       -- the new dividend will be the difference between the 2 terms;
       temp_x(47 downto decimal_p) := (temp_x(47 downto decimal_p) - temp_y(47 downto decimal_p)); 
       -- we add a '1' to the result;
       result := result(46 downto 0) & '1';        
       -- if the divisor cannot be contained by the dividend
    else
       -- we add a '0' to the result;
       result := result(46 downto 0) & '0';
       -- the subtraction cannot be performed in this case;
    end if;
    
 ---------------------------------------------------------
 
 -- create the loop for all the remaining values;
 for i in decimal_p-1 downto 0 LOOP 
        -- we start the division steps: 
        if temp_x(y_len + i+1 downto i) >= '0' & temp_y(47 downto decimal_p) then 
            -- the new divident will be the difference between the 2 terms;    
            temp_x(y_len + i downto i) := (temp_x(y_len + i downto i) - temp_y(47 downto decimal_p));
            -- we add a '1' to the result;
            result := result(46 downto 0) & '1';    
        else    
            -- we add a '0' to the result; 
            result := result(46 downto 0) & '0';
            -- the subtraction cannot be performed in this case;
        end if;
        
    end loop;
    
    -- search to find the highest significant '1';
    for i in 0 to 47 loop
        if result(i) = '1' then
            -- then we know that the decimal point will be on that position;
            result_point := i;
        end if;
        
    end loop;
    -- the normalization value is represented by the difference between the initial position and the result's one;
    normalized := std_logic_vector(to_unsigned(decimal_p - result_point,6));  
   
    -- the value needs to be transformed in 2's Complement (subtract it in the exponents);
    normalize <= not(normalized) + 1 ;
    
    -- obtain the value for the result;
    d <= result(result_point - 1 downto result_point - 23);
end process;

end Behavioral;
