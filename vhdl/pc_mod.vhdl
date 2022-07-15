library ieee;
use ieee.std_logic_1164.all;

entity pc is
    port(
        nb_inc: in std_logic;
        pc_nrw: in std_logic;
        barr: in std_logic_vector(7 downto 0);
        reset: in std_logic;
        clk: in std_logic;
        end_out: out std_logic_vector(7 downto 0)
    );
end;

architecture b of pc is
    component reg8 is
        port(
            d: in std_logic_vector(7 downto 0);
            nrw: in std_logic;
            reset: in std_logic;
            clk: in std_logic;
            q: out std_logic_vector(7 downto 0)
        );
    end component;

    component add8 is
        port(
            x, y: in std_logic_vector(7 downto 0);
            cin: in std_logic;
            cout: out std_logic;
            s: out std_logic_vector(7 downto 0)
        );
    end component;
    
    signal szero: std_logic_vector(7 downto 0) := "00000000";
    signal sadd, smux, spc: std_logic_vector(7 downto 0);
    signal vcc: std_logic := '1';
    signal cout_dump: std_logic;
begin
    u_add: add8 port map(szero, spc, vcc, cout_dump, sadd);
    smux <= barr when nb_inc='0' else sadd;
    u_pc: reg8 port map(smux, pc_nrw, reset, clk, spc);
    end_out <= spc;
end;

