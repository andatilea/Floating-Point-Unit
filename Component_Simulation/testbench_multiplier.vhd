LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY testbench_multiplier IS
END testbench_multiplier;
 
ARCHITECTURE Behavioral OF testbench_multiplier IS

signal a,b : std_logic_vector(24 downto 0) := (others => '0');
signal p : std_logic_vector(47 downto 0) := (others => '0');
signal expected_output: std_logic_vector(47 downto 0) := (others => '0');

BEGIN

uut: entity work.multiplierComponent port map(a,b,p);
 
tb: process
begin

    a <= "0000000000000000000001100";        -- 12
    b <= "0000000000000000000000101";        -- 5
    expected_output <= "000000000000000000000000000000000000000000111100"; -- 60
    
    wait for 100 ns;
    
    a <= "0101001000000000000000000";        -- 10747904
    b <= "0100000000000000000000000";        -- 8388608
    expected_output <= "010100100000000000000000000000000000000000000000";  -- 90159953477632
    
    wait for 100ns;
    
    a <= "0000000000000000000011000";        -- 24
    b <= "0000000000000000000000110";        -- 6
    expected_output <= "000000000000000000000000000000000000000010010000";  -- 144
    
    wait for 100 ns;
    
    a <= "0110001111100111000001100";        -- 13094412
    b <= "0101001000000000000000000";        -- 10747904
    expected_output <= "011111111111111111111111101100000000000000000000";  -- 140737483112448
    
     wait for 100ns;
     
    a <= "0000000000000000001111101";       -- 125
    b <= "0000000000000000000001100";       -- 12
    expected_output <= "000000000000000000000000000000000000010111011100";       -- 1500
    
    wait for 100 ns;
    
    a <= "0000000000000000000100101";       -- 37
    b <= "0000000000000000000001010";       -- 10
    expected_output <= "000000000000000000000000000000000000000101110010";       -- 370
    
    wait for 100 ns;
    
    a <= "1111111111111111111111111";       -- 33554431 (the largest number that can be represented)
    b <= "0000000000000000000000000";       -- 0
    expected_output <= "000000000000000000000000000000000000000000000000";      -- 0
    
    wait for 100 ns;
    
    a <= "0000000000000000001100000";       -- 96
    b <= "0000000000000000000010011";       -- 19
    expected_output <= "000000000000000000000000000000000000011100100000";      -- 1824
    
wait;
 
end process tb;
 
END Behavioral;
