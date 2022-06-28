library ieee;
use ieee.std_logic_1164.all;

entity reg8 is
    port(
        d: in std_logic_vector(7 downto 0);
        nrw: in std_logic;
        reset: in std_logic;
        clk: in std_logic;
        q: out std_logic_vector(7 downto 0)
    );
end;

architecture b of reg8 is
    component ff_charge is
        port(
            d: in std_logic;
            nrw: in std_logic; -- se 0=read, 1=write
            clk: in std_logic;
            pr, cl: in std_logic;
            q: out std_logic
        );
    end component;

    signal vcc: std_logic := '1';
begin
    u_fios: for i in 7 downto 0 generate
        ffc: ff_charge port map(d(i), nrw, clk, vcc, reset, q(i));
    end generate;
end;

