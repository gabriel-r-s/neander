library ieee;
use ieee.std_logic_1164.all;

entity ula_mod is
    port(
        mem: inout std_logic_vector(7 downto 0);
        mem_nrw: in std_logic;

        ula_op: in std_logic_vector(2 downto 0);    
        ac_nrw: in std_logic;
        
        reset: in std_logic;
        clk: in std_logic;

        zf, nf: out std_logic
    );
end;

architecture b of ula_mod is
    component ac is
        port(
            d: in std_logic_vector(7 downto 0);
            nrw: in std_logic;
            reset: in std_logic;
            clk: in std_logic;
            q: out std_logic_vector(7 downto 0)
        );
    end component;
    
    component ula_alu is
        port(
            x, y: in std_logic_vector(7 downto 0);
            op: in std_logic_vector(2 downto 0);
            
            zf, nf: out std_logic;
            s: out std_logic_vector(7 downto 0)
        );
    end component;
    
    component flags is
        port(
            in_zf, in_nf: in std_logic;
            nrw: in std_logic;
            reset: in std_logic; 
            clk: in std_logic;
            zf, nf: out std_logic
        );
    end component;

    signal ac_out, ula_out, mem_inout: std_logic_vector(7 downto 0);
    signal szf, snf: std_logic;
begin
    mem_inout <= "10101010";

    u_ac: ac port map(ula_out, ac_nrw, reset, clk, ac_out);
    u_alu: ula_alu port map(ac_out, mem_inout, ula_op, szf, snf, ula_out);
    u_flags: flags port map(szf, snf, ac_nrw, reset, clk, zf, nf);
    -- u_mem: ?
end;
