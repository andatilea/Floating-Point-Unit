LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY testbench_mul IS
END testbench_mul;
 
ARCHITECTURE Behavioral OF testbench_mul IS

signal a,b : std_logic_vector(31 downto 0) := (others => '0');
signal p, expected_output : std_logic_vector(31 downto 0) := (others => '0');
signal underflow,overflow: std_logic := '0';

BEGIN

uut: entity work.FPMultiplicator port map(a,b,underflow, overflow, p);

tb: process
begin

    a <= "01000000111000000000000000000000";     -- 7
    b <= "01000001010100000000000000000000";     -- 13              
    expected_output <= "01000010101101100000000000000000";      -- result: 91                                  
   
    wait for 100 ns;
    
    a <= "01000001101001000000000000000000";     -- 20.5
    b <= "01000000000000000000000000000000";     -- 2                          
    expected_output <= "01000010001001000000000000000000";      -- result: 41
    
    wait for 100 ns;
    
    a <= "11000001011010000000000000000000";     -- - 14.5
    b <= "10111110110000000000000000000000";     -- - 0.375                                               
    expected_output <= "01000000101011100000000000000000";       -- result: 5.4375
   
    wait for 100 ns;
    
    a <= "01000010010111100000000000000000";     --55.5
    b <= "11000001101110000000000000000000";     -- -23                                               
    expected_output <= "11000100100111111001000000000000";       -- result: -1276.5
   
    wait for 100 ns;
    
    a <= "11000001101111011001100110011010";    -- -23.7
    b <= "11000001100100000000000000000000";    -- - 18
    expected_output <= "01000011110101010100110011001101";       -- 426.6
    
    wait for 100 ns;
    
    a <= "01000011011000000000000000000000";       --224
    b <= "01000001011000000000000000000000";       --14
    expected_output <= "01000101010001000000000000000000";       --3136
    
    wait for 100 ns;
    
    a <= "01000011011111110000000000000000";     --255
    b <= "01000011011111110000000000000000";     --255        
    expected_output <= "01000111011111100000000100000000";       --65025 
            
wait;
 
end process tb;
 
END Behavioral;
