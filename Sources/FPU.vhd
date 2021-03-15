
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FPU is
Port     ( a : in STD_LOGIC_VECTOR (31 downto 0);
           b : in STD_LOGIC_VECTOR (31 downto 0);
           op: in std_logic;
           overf, underf: out std_logic;
           r : out STD_LOGIC_VECTOR (31 downto 0));
end FPU;

architecture Behavioral of FPU is

component FPMultiplicator is
    Port ( x : in STD_LOGIC_VECTOR (31 downto 0);
           y : in STD_LOGIC_VECTOR (31 downto 0);
          underflow,overflow: out std_logic;
           p : out STD_LOGIC_VECTOR (31 downto 0));
end component FPMultiplicator;

component FPDivider is
    Port ( x : in STD_LOGIC_VECTOR (31 downto 0);
           y : in STD_LOGIC_VECTOR (31 downto 0);
           underflow : out std_logic;
           d : out STD_LOGIC_VECTOR (31 downto 0));
end component FPDivider;

signal mul_result, div_result: std_logic_vector(31 downto 0) := (others => '0');
signal  overflow, underflow: std_logic := '0';

begin

fpu_multiplication: FPMultiplicator PORT MAP(
x => a,
y => b,
overflow => overflow,
p => mul_result
);

fpu_division: FPDivider PORT MAP (
 x => a,
 y => b,    
 underflow => underflow,
 d => div_result  
);

process(op, mul_result, div_result)
begin

if op = '1' then
    r <= mul_result;
    overf <= overflow;
    underf <= '0';
    
elsif op = '0' then
    r <= div_result;
    underf <= underflow;
    overf <= '0'; 
end if;
end process;



end Behavioral;
