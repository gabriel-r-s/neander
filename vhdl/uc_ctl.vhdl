library ieee;
use ieee.std_logic_1164.all;

entity uc_ctl is
    port(
        inst: in std_logic_vector(10 downto 0);
        -- 10nop|9lda|8sta|7add|6and|5or|4not|3jmp|2jn|1jz|0hlt
        reset: in std_logic;
        clk: in std_logic;
        outs: out std_logic(10 downto 0)
        -- 10nb_inc|9nb_pc|8..6ula_op|5pc_nrw|4ac_nrw|3mem_nrw|2mar_nrw|1mbr_nrw|0ri_nrw
    );
end;

architecture b of uc_ctl is
    component count0a7 is
        port(
            reset: in std_logic;
            clk: in std_logic;
            num: out std_logic_vector(2 downto 0)
        );
    end component;
    
    signal st: std_logic_vector(2 downto 0);
begin
    outs <= "00000000000";
    u_count: count0a7 port map(reset, clk, st);
    

    outs(10) <= inst(10) and (not st(2) and not st(1) and st(0));
    outs(9) <= inst(10) and (not st(2) and not st(1) and not st(0));
    
    -- outs(8) 
    -- outs(7) 
    -- outs(6) 
    
    outs(5) <= inst(10) and (not st(2) and not st(1) and st(0));
    
    -- outs(4)
    -- outs(3)

    outs(2) <= inst(10) and (not st(2) and not st(1) and not st(0));
    outs(1) <= inst(10) and (not st(2) and not st(1) and st(0));
    outs(0) <= inst(10) and (not st(2) and st(1) and not st(0));
end;

library ieee;
use ieee.std_logic_1164.all;

entity count0a7 is
    port(
        reset: in std_logic;
        clk: in std_logic;
        num: out std_logic_vector(2 downto 0)
    );
end;

architecture b of count0a7 is
    component ffd is
        port(
            d: in std_logic;
            clk: in std_logic;
            pr, cl: in std_logic;
            q, nq: out std_logic
        );
    end component;


    signal sadd: std_logic_vector(2 downto 0);
    signal spr, scl: std_logic;
    signal vcc: std_logic := '1';
begin

    u_ffs: for i in 2 downto 0 generate
        st: ffd port map(sadd(i), clk, vcc, reset, snum(i));
    end generate;
    
    -- incrementador 3 bits manual
    sadd(0) <= not snum(0);
    sadd(1) <= snum(0) xor snum(1);
    sadd(2) <= snum(2) xor (snum(1) and snum(0));
end;

