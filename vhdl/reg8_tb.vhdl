library ieee;
use ieee.std_logic_1164.all;

entity reg8_tb is
end;

architecture tb of reg8_tb is
    constant CLK_PERIOD: time := 10 ns;
        
    component reg8 is
        port(
            d: in std_logic_vector(7 downto 0);
            nrw: in std_logic;
            reset: in std_logic;
            clk: in std_logic;
            q: out std_logic_vector(7 downto 0)
        );
    end component;

    signal sd: std_logic_vector(7 downto 0);
    signal snrw, sreset: std_logic;
    signal sclk: std_logic := '0';
    signal sq: std_logic_vector(7 downto 0);
begin
    u_reg8: reg8 port map(sd, snrw, sreset, sclk, sq);
    
    u_tb: process begin
        -- reset
        sreset <= '0';
        wait for CLK_PERIOD;
        sreset <= '1';
        
        -- read
        snrw <= '0';
        sd <= "11110000";
        wait for CLK_PERIOD;
        
        -- write
        snrw <= '1';
        sd <= "00001111";
        wait for CLK_PERIOD;
        
        -- read
        snrw <= '0';
        sd <= "11110000";
        wait for CLK_PERIOD;
    end process;


    u_clk: process begin
        sclk <= not sclk;
        wait for CLK_PERIOD / 2;
    end process;
end;


library ieee;
use ieee.std_logic_1164.all;

entity ffc_tb is
end;

architecture tb of ffc_tb is
    constant CLK_PERIOD: time := 10 ns;
        
    component ff_charge is
        port(
            d: in std_logic_vector(7 downto 0);
            nrw: in std_logic;
            clk: in std_logic;
            pr, cl: in std_logic;
            q: out std_logic_vector(7 downto 0)
        );
    end component;

    signal sd: std_logic_vector(7 downto 0);
    signal snrw: std_logic;
    signal sclk: std_logic := '0';
    signal spr, scl: std_logic;
    signal sq: std_logic_vector(7 downto 0);
begin
    u_reg8: ff_charge port map(sd, snrw, sclk, spr, scl, sq);
    
    u_tb: process begin
        -- preset
        spr <= '0';
        scl <= '1';
        wait for CLK_PERIOD;

        -- clear
        spr <= '1';
        scl <= '0';
        wait for CLK_PERIOD;

        -- done
        spr <= '1';
        scl <= '1';

        -- write
        snrw <= '1';
        sd <= "00001111";
        wait for CLK_PERIOD;

        -- read
        snrw <= '0';
        sd <= "11110000";
        wait for CLK_PERIOD;

        -- write
        snrw <= '1';
        sd <= "11110000";
        wait for CLK_PERIOD;
    end process;


    u_clk: process begin
        sclk <= not sclk;
        wait for CLK_PERIOD / 2;
    end process;
end;
