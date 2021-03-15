
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FullAdder is
    Port ( a : in std_logic;
           b : in std_logic;
           Cin : in std_logic;
           Cout : out std_logic;
           s : out std_logic);
end FullAdder;

architecture Behavioral of FullAdder is
signal s1,s2,s3 : std_logic;
begin
    s1 <= a and b;
    s2 <= a xor b;
    s3 <= s2 and Cin;
    Cout <= s1 or s3;
    s <= s2 xor Cin;
    
end Behavioral;
