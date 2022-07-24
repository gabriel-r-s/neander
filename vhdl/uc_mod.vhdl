library ieee;
use ieee.std_logic_1164.all;


entity uc_mod is
    port(
        bar: inout std_logic_vector(7 downto 0);
        ri_nrw: in std_logic;
        zf, nf: in std_logic;
        
        reset: in std_logic;
        clk: in std_logic;
        
        bar_ctl: out std_logic_vector(10 downto 0)

    );
end;

architecture b of uc_mod is
    component reg8 is
        port(
            d: in std_logic_vector(7 downto 0);
            nrw: in std_logic;
            reset: in std_logic;
            clk: in std_logic;
            q: out std_logic_vector(7 downto 0)
        );
    end component;

    component uc_decode is
        port(
            code: in std_logic_vector(7 downto 0);
            inst: out std_logic_vector(10 downto 0)
        );
    end component;
    
    
    component uc_ctl is
        port(
            inst: in std_logic_vector(10 downto 0);
            -- 10nop|9lda|8sta|7add|6and|5or|4not|3jmp|2jn|1jz|0hlt
            zf, nf: in std_logic;
            reset: in std_logic;
            clk: in std_logic;
            bar_ctl: out std_logic_vector(10 downto 0)
            -- 10nb_inc|9nb_pc|8..6ula_op|5pc_nrw|4ac_nrw|3mem_nrw|2mar_nrw|1mbr_nrw|0ri_nrw
        );
    end component;
    signal ri_out: std_logic_vector(7 downto 0);
    signal decoded: std_logic_vector(10 downto 0);
begin
    u_ri: reg8 port map(bar, ri_nrw, reset, clk, ri_out);
    u_decoder: uc_decode port map(ri_out, decoded);
    u_ctl: uc_ctl port map(decoded, zf, nf, reset, clk, bar_ctl);
end;

