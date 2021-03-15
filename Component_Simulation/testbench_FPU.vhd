
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity testbench_FPU is
--  Port ( );
end testbench_FPU;

architecture Behavioral of testbench_FPU is

signal x,y : std_logic_vector(31 downto 0) := (others => '0');
signal r, expected_output : std_logic_vector(31 downto 0) := (others => '0');
signal op, overflow, underflow: std_logic := '0';

begin
uut: entity work.FPU port map(x,y,op,overflow, underflow, r);


tb: process
begin
    
    x <= "01000100011110100000000000000000";     --1000
    y <= "01000001001000000000000000000000";     --10
    op <= '0';                                            
    expected_output <= "01000010110010000000000000000000";      -- result: 100 -> division                                
    
    wait for 20 ns;
    
    x <= "01000100011110100000000000000000";     --1000
    y <= "01000011101111011000000000000000";     --379
    op <= '1';                                       
    expected_output <= "01001000101110010000111100000000";      -- result: 379000 -> multiplication 
    
    wait for 20 ns;
                         
    x <= "01000000001000000000000000000000";     -- 2.5
    y <= "00111111000000000000000000000000";     -- 0.5
    op <= '0';                                               
    expected_output <= "01000000101000000000000000000000";       -- result: 5 -> division
    
    wait for 20 ns;
  
    x <= "01000011000001100000000000000000";      -- 134
    y <= "11000000001000000000000000000000";      -- -2.5
    op <= '1';                                                 
    expected_output <= "11000011101001111000000000000000";         -- result: -335 -> multiplication 
  
    wait for 20 ns;
  
    x <= "01000011011111110000000000000000";     --255
    y <= "01000011011111110000000000000000";     --255   
    op <= '0';     
    expected_output <= "00111111100000000000000000000000";       --result: 1 -> division
    
    wait for 20 ns;
    
    x <= "01000011011000000000000000000000";       --224
    y <= "01000001011000000000000000000000";       --14
    op <= '1';
    expected_output <= "01000101010001000000000000000000";       --result: 3136 -> multiplication
            
    wait for 20 ns;
    
    x <= "01000001101001000000000000000000";     -- 20.5
    y <= "01000000000000000000000000000000";     -- 2      
    op <= '0';                    
    expected_output <= "01000001001001000000000000000000";      -- result: 10.25 -> division
    
    wait for 20 ns;
    
    x <= "01000011011111110000000000000000";     --255
    y <= "01000011011111110000000000000000";     --255       
    op <= '1'; 
    expected_output <= "01000111011111100000000100000000";       --result: 65025 -> multiplication
    
    wait for 20 ns;
    
    x <= "01000010111000100000000000000000";     --113
    y <= "01000001110010000000000000000000";     -- 25 
    op <= '0';
    expected_output <= "01000000100100001010001111010111";     -- result:4.52  -> division
    
    wait for 20 ns;
    
    x <= "11000001011010000000000000000000";     -- - 14.5
    y <= "10111110110000000000000000000000";     -- - 0.375   
    op <= '1';                                            
    expected_output <= "01000000101011100000000000000000";       -- result: 5.4375  -> multiplication 
    
    wait for 20 ns;
    
    x <= "01000000111000000000000000000000";     --7
    y <= "01000000000000000000000000000000";     --2                       
    op <= '0';    
    expected_output <= "01000000011000000000000000000000";   -- result: 3.5 -> division
    
    wait for 20 ns;
    
    x <= "01000000111000000000000000000000";     -- 7
    y <= "01000001010100000000000000000000";     -- 13  
    op <= '1';            
    expected_output <= "01000010101101100000000000000000";      -- result: 91 -> multiplication    
    
    wait for 20 ns;
    
    x <= "11000000011011001100110011001101";     -- -3.7
    y <= "00111111100000000000000000000000";     -- 1.0  
    op <= '0';                                             
    expected_output <= "11000000011011001100110011001101";    -- result: -3.7 -> division
    
    wait for 20 ns;
    
    x <= "01000011011000000000000000000000";       --224
    y <= "01000001011000000000000000000000";       --14
    op <= '0';   
    expected_output <= "01000001100000000000000000000000";     -- result: 16 -> division
    
    wait for 20 ns;   
    
    x <= "01000001101001000000000000000000";     -- 20.5
    y <= "01000000000000000000000000000000";     -- 2     
    op <= '1';                     
    expected_output <= "01000010001001000000000000000000";      -- result: 41  -> multiplication
    
    wait for 20 ns;
    
    x <= "01000010010111100000000000000000";     --55.5
    y <= "11000001101110000000000000000000";     -- -23
    op <= '1';                                               
    expected_output <= "11000100100111111001000000000000";       -- result: -1276.5  -> multiplication
    
    wait for 20 ns;
    
    x <= "11000001101111011001100110011010";    -- -23.7
    y <= "11000001100100000000000000000000";    -- - 18
    op <= '1';
    expected_output <= "01000011110101010100110011001101";       -- result: 426.6 -> multiplication          

    wait for 20 ns;

-- some special cases

    x <= "01111111110000000000000000000000";    -- NaN
    y <= "01000000101000000000000000000000";    -- 5
    op <= '0';
    expected_output <= "01111111110000000000000000000000";      -- result: NaN -> division
    
    wait for 20 ns;
    
    x <= "01000001100011000000000000000000";    -- 17.5
    y <= "00000000000000000000000000000000";    -- +0
    op <= '0';
    expected_output <= "01111111100000000000000000000000";     -- result: + infinity -> division
    
    wait for 20 ns;
    
    x <= "00000000000000000000000000000000";    -- +0
    y <= "01000000110000000000000000000000";    -- 6
    op <= '0';
    expected_output <= "00000000000000000000000000000000";      -- result: +0 -> division
    
   wait for 20 ns;
   
   x <= "01111111100000000000000000000000";     -- + infinity
   y <= "01000000111000000000000000000000";    -- 7
   op <= '0';
   expected_output <= "01111111100000000000000000000000";       -- result: + infinity -> division
    
   wait for 20 ns;
   
   x <= "01000001101110100110011001100110";     -- 23.3
   y <= "01111111100000000000000000000000";     -- + infinity
   op <= '0';
   expected_output <= "00000000000000000000000000000000";       -- result: +0 -> division
   
   wait for 20 ns;
   
   x <= "01111111100000000000000000000000";     -- + infinity
   y <= "01111111100000000000000000000000";     -- + infinity
   op <= '0';
   expected_output <= "01111111110000000000000000000000";       -- result: NaN -> division
   
   wait for 20 ns;
   
   x <= "00000000000000000000000000000000";     -- +0
   y <= "01000011000001100000000000000000";     -- 134
   op <= '1';
   expected_output <= "00000000000000000000000000000000";      -- result: +0 -> multiplication
   
   wait for 20 ns;
   
   x <= "01000011000001100000000000000000";     -- 134
   y <= "01111111110000000000000000000000";     -- NaN
   op <= '1';
   expected_output <= "01111111110000000000000000000000";      -- result: NaN -> multiplication
   
   wait for 20 ns;
   
   x <= "01111111100000000000000000000000";     -- + infinity
   y <= "01000011000001100000000000000000";     -- 134
   op <= '1';
   expected_output <= "01111111100000000000000000000000";      -- result: + infinity -> multiplication
   
   wait for 20 ns;
   
   x <= "01111111100000000000000000000000";     -- + infinity
   y <= "01111111100000000000000000000000";     -- + infinity
   op <= '1';
   expected_output <= "01111111110000000000000000000000";       -- result: NaN -> multiplication
   
   wait for 20 ns;
  
 -- underflow case
  
   x <= "00000000100000000000000000000000";     -- 1.17549435e-38 (smallest normal number -> underflow threshold)
   y <= "01000000000000000000000000000000";     -- 2
   op <= '0';
   expected_output <= "00000000000000000000000000000000";       -- result : 0 (a subnormal result will be obtained, so since the precision will not allow it, we will return the answer 0) -> division
   
   wait for 20 ns;
    
-- oveflow case

--    x <= "01111111011111111111111111111111";    -- 3.40282347e+38 (maximum normal number)
--    y <= "01111111000011111111111111111111";    -- 1.914088111106183e+38
--    op <= '1';
--    expected_output <= "00111111000011111111111111111110";      -- result : overflow -> multiplication
    
wait;
end process tb;
end Behavioral;
