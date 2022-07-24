library ieee;
use ieee.std_logic_1164.all;

entity NEANDER is
    port(
        reset: in std_logic;
        clk: in std_logic
    );
end;

architecture b OF NEANDER is
    component pc is
        port(
            nb_inc: in std_logic;
            pc_nrw: in std_logic;
            barr: in std_logic_vector(7 downto 0);
            reset: in std_logic;
            clk: in std_logic;
            end_out: out std_logic_vector(7 downto 0)
        );
    end component;

    component mem_mod is
        port(
            end_pc, end_bar: in std_logic_vector(7 downto 0); -- endereço PC (instrução), endereço barramento (dados)
            nb_pc: in std_logic; -- se 0->barr, 1->PC
            mar_nrw, mem_nrw, mbr_nrw: in std_logic; -- se 0->read, 1->write
            
            reset: in std_logic;
            clk: in std_logic;
            
            interface: inout std_logic_vector(7 downto 0)
        );
    end component;

    component ula_mod is
        port(
            mem: inout std_logic_vector(7 downto 0); -- NOTE: INOUT
            mem_nrw: in std_logic;
    
            ula_op: in std_logic_vector(2 downto 0);    
            ac_nrw: in std_logic;
            
            reset: in std_logic;
            clk: in std_logic;
    
            zf, nf: out std_logic
        );
    end component;
    
    component uc_mod is
        port(
            bar: inout std_logic_vector(7 downto 0);
            ri_nrw: in std_logic;
            zf, nf: in std_logic;
            
            reset: in std_logic;
            clk: in std_logic;
            
            bar_ctl: out std_logic_vector(10 downto 0) 
        );
    end component;
    
    signal bar_geral, rip_out: std_logic_vector(7 downto 0);
    signal ctl: std_logic_vector(10 downto 0);
    signal zf, nf: std_logic;
begin

-- 10nb_inc|9nb_pc|8..6ula_op|5pc_nrw|4ac_nrw|3mem_nrw|2mar_nrw|1mbr_nrw|0ri_nrw
    u_ula: ula_mod port map(bar_geral, ctl(3), ctl(8 downto 6), ctl(4), reset, clk, zf, nf);
    u_pc: pc port map(ctl(10), ctl(5), bar_geral, reset, clk, rip_out);
    u_mem: mem_mod port map(rip_out, bar_geral, ctl(9), ctl(2), ctl(3), ctl(1), reset, clk, bar_geral);
    u_uc: uc_mod port map(bar_geral, ctl(0), zf, nf, reset, clk, ctl);
end;

