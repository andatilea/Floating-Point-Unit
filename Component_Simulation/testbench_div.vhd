
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity testbench_div is
--  Port ( );
end testbench_div;

architecture Behavioral of testbench_div is

signal x,y : std_logic_vector(31 downto 0) := (others => '0');
signal d, expected_output : std_logic_vector(31 downto 0) := (others => '0');
signal underflow: std_logic := '0';

begin

uut: entity work.FPDivider port map(x,y,underflow, d);
 
tb: process
begin

    x <= "01000000111000000000000000000000";     --7
    y <= "01000000000000000000000000000000";     --2                           
    expected_output <= "01000000011000000000000000000000";   -- result: 3.5
   
    wait for 100ns;
    
    x<= "01000000001000000000000000000000";     -- 2.5
    y<= "00111111000000000000000000000000";     -- 0.5                                              
    expected_output <= "01000000101000000000000000000000";    -- result: 5                          
   
   wait for 100ns;

    x <= "11000000011011001100110011001101";     -- -3.7
    y <= "00111111100000000000000000000000";     -- 1.0                                               
    expected_output <= "11000000011011001100110011001101";    -- result: -3.7
   
    wait for 100 ns;
    
    x <= "01000100011110100000000000000000";     --1000
    y <= "01000001001000000000000000000000";     --10                                         
    expected_output <= "01000010110010000000000000000000";     -- result: 100   
    
    wait for 100 ns;
    
    x <= "01000010111000100000000000000000";     --113
    y <= "01000001110010000000000000000000";     -- 25 
    expected_output <= "01000000100100001010001111010111";     -- result:4.52
    
    wait for 100 ns;
    
    x <= "01000011011000000000000000000000";       --224
    y <= "01000001011000000000000000000000";       --14   
    expected_output <= "01000001100000000000000000000000";     -- result: 16 
    
    wait for 100 ns;
    
    x <= "01000011011111110000000000000000";     --255
    y <= "01000011011111110000000000000000";     --255        
    expected_output <= "00111111100000000000000000000000";       --result: 1
    
    wait for 100 ns;
    
    x <= "01000001101001000000000000000000";     -- 20.5
    y <= "01000000000000000000000000000000";     -- 2                          
    expected_output <= "01000001001001000000000000000000";      -- result: 10.25                                
                                                   
wait;
 
end process tb;
end Behavioral;
