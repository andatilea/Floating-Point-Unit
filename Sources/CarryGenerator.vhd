
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CarryGenerator is
    Port ( x : in std_logic_vector (7 downto 0);
           y : in std_logic_vector (7 downto 0);
           Cin : in std_logic;
           Cout : out std_logic_vector (8 downto 1));
end CarryGenerator;

architecture Behavioral of CarryGenerator is
signal C : std_logic_vector(8 downto 0) := (others => '0');
signal G,P: std_logic_vector(7 downto 0) := (others => '0');
signal temp : std_logic_vector(7 downto 0) := (others => '0');

begin
C(0) <= Cin; 
    proc:   FOR i in 0 to 7 Generate
            G(i) <= x(i) and y(i);
            P(i) <= x(i) or y(i);
            temp(i) <= P(i) and C(i);
            C(i+1) <= G(i) or temp(i);
    end generate;

Cout <= C(8 downto 1);
end Behavioral;
