LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY testbench_adder IS
END testbench_adder;
 
ARCHITECTURE Behavioral OF testbench_adder IS

signal a,b,s : std_logic_vector(7 downto 0) := (others => '0');
signal Cout : std_logic := '0';
signal expected_output: std_logic_vector(7 downto 0) := (others => '0');
 
BEGIN

uut: entity work.adderComponent port map(a,b,Cout,s);
 
tb: process
begin

    a<= "01010010";     -- 82
    b<= "00000011";     -- 3
    expected_output <= "01010101";  -- 85
    
    wait for 100ns;
    
    a <= "00110000";        -- 48
    b <= "01010111";        -- 87
    expected_output <= "10000111";      -- 135
    
    wait for 100 ns;
    
    a<= "00111110";     -- 62
    b<= "00000010";     -- 2
    expected_output <= "01000000";  -- 64
    
    wait for 100ns;
    
    a <= "00000001";        -- 1
    b <= "00000000";        -- 0
    expected_output <= "00000001";      -- 1
    
    wait for 100 ns;
    
    a <= "00110000";         -- 48
    b <= "10101110";         -- 174
    expected_output <= "11011110";      -- 222
    
    wait for 100 ns;
    
    a <= "00010111";         -- 23
    b <= "00011110";         -- 30
    expected_output <= "00110101";      -- 53
    
    a<= "00000000";     -- 0
    b<= "11111111";     -- 255 (the largest number in binary representation)
    expected_output <=  "11111111";  -- 255
    
    wait for 100ns;
    
    a<= "00001110";     -- 14
    b<= "11100000";     -- 224
    expected_output <= "11101110";          -- 238
 
wait;
 
end process tb;
 
END Behavioral;
