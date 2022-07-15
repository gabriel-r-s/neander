-- registros flags ================================
library ieee;
use ieee.std_logic_1164.all;

entity flags is
    port(
        in_zf, in_nf: in std_logic;
        nrw: in std_logic;
        reset: in std_logic; 
        clk: in std_logic;
        zf, nf: out std_logic
    );
end;

architecture b of flags is
    component ff_charge is
        port(
            d: in std_logic;
            nrw: in std_logic; 
            clk: in std_logic;
            pr, cl: in std_logic;
            q: out std_logic
        );
    end component;
    
    signal vcc: std_logic := '1';
begin
    u_zf: ff_charge port map(in_zf, nrw, clk, reset, vcc, zf);
    u_nf: ff_charge port map(in_nf, nrw, clk, vcc, reset, nf);
end;

-- cálculo de flags =================================
library ieee;
use ieee.std_logic_1164.all;

entity calc_flag is
    port(
        result: in std_logic_vector(7 downto 0);
        zf, nf: out std_logic
    );
end;

architecture b of calc_flag is
begin
    nf <= result(7);
    zf <= not (
        (result(7) or result(6) or result(5) or result(4))
        or (result(3) or result(2) or result(1) or result(0))
    );
end;
