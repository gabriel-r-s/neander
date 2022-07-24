library ieee;
use ieee.std_logic_1164.all;

entity NEANDER_TB is
end;

architecture tb of NEANDER_TB is
    constant CLK_PERIOD: time := 4 ns;

    component NEANDER is
        port(
            reset: in std_logic;
            clk: in std_logic
        );
    end component;
    
    signal sreset: std_logic;
    signal sclk: std_logic := '1';
begin
    u_NEANDER: NEANDER port map(sreset, sclk);
    
    t_tb: process begin
        sreset <= '0';
        wait for CLK_PERIOD;
        sreset <= '1';
        wait;
    end process;

    u_clk: process begin
        sclk <= not sclk;
        wait for CLK_PERIOD / 2;
    end process;
end;

