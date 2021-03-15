
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity adderComponent is
    Port ( x : in STD_LOGIC_VECTOR (7 downto 0);
           y : in STD_LOGIC_VECTOR (7 downto 0);
           Cout : out std_logic;
           s : out STD_LOGIC_VECTOR (7 downto 0));
end adderComponent;

architecture Behavioral of adderComponent is
signal Carry , carry_out: std_logic_vector(8 downto 0);

component FullAdder is
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           Cin : in STD_LOGIC;
           Cout : out STD_LOGIC;
           s : out STD_LOGIC);
end component  FullAdder;

component CarryGenerator is
    Port ( x : in STD_LOGIC_VECTOR (7 downto 0);
           y: in STD_LOGIC_VECTOR (7 downto 0);
           Cin : in STD_LOGIC;
           Cout : out STD_LOGIC_VECTOR (8 downto 1));
end component CarryGenerator;

begin

adders: for i in 0 to 7 generate    
        adders8: FullAdder PORT MAP (a => x(i), b => y(i), Cin => Carry(i), Cout => carry_out(i), s => s(i));
end generate;

generate_propagate: CarryGenerator PORT MAP ( x => x, y => y, Cin => '0', Cout => Carry(8 downto 1));
Carry(0) <= '0';


cout <= carry_out(7);
end Behavioral;
