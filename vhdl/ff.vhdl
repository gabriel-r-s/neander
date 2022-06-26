-- FlipFlop JK ======================================================
library ieee;
use ieee.std_logic_1164.all; -- std_logic para detectar erros

entity ffjk is
    port(
        j, k   : in std_logic;
        clk    : in std_logic;
        pr, cl : in std_logic;
        q, nq  : out std_logic
    );
end entity;

architecture latch of ffjk is
    signal sq  : std_logic := '0'; -- opcional -> valor inicial
    signal snq : std_logic := '1';
begin

    q  <= sq;
    nq <= snq;

    u_ff : process (clk, pr, cl)
    begin
        -- pr = 0 e cl = 0 -> Desconhecido
        if (pr = '0') and (cl = '0') then
            sq  <= 'X';
            snq <= 'X';
            -- prioridade para cl
            elsif (pr = '1') and (cl = '0') then
                sq  <= '0';
                snq <= '1';
                -- tratamento de pr
                elsif (pr = '0') and (cl = '1') then
                    sq  <= '1';
                    snq <= '0';
                    -- pr e cl desativados
                    elsif (pr = '1') and (cl = '1') then
                        if falling_edge(clk) then
                            -- jk = 00 -> mantém estado
                            if    (j = '0') and (k = '0') then
                                sq  <= sq;
                                snq <= snq;
                            -- jk = 01 -> q = 0
                            elsif (j = '0') and (k = '1') then
                                sq  <= '0';
                                snq <= '1';
                            -- jk = 01 -> q = 1
                            elsif (j = '1') and (k = '0') then
                                sq  <= '1';
                                snq <= '0';
                            -- jk = 11 -> q = !q
                            elsif (j = '1') and (k = '1') then
                                sq  <= not(sq);
                                snq <= not(snq);
                            -- jk = ?? -> falha
                            else
                                sq  <= 'U';
                                snq <= 'U';
                            end if;
                        end if;
            else
                sq  <= 'X';
                snq <= 'X';
        end if;
    end process;

end architecture;


-- Flip-Flop Tipo D ==============================================================
library ieee;
use ieee.std_logic_1164.all;

entity ffd is
    port(
        d: in std_logic;
        clk: in std_logic;
        pr, cl: in std_logic;
        q, nq: out std_logic
    );
end;

architecture b of ffd is
    component ffjk is
        port(
            j, k   : in std_logic;
            clk    : in std_logic;
            pr, cl : in std_logic;
            q, nq  : out std_logic
        );
    end component;

    signal nd: std_logic := not d;
begin
    ff: ffjk port map(d, nd, clk, pr, cl, q, nq);
end;


-- Registrador com Carga ==============================================================
library ieee;
use ieee.std_logic_1164.all;

entity ff_charge is
    port(
        d: in std_logic;
        nrw: in std_logic; -- se 0=read, 1=write
        clk: in std_logic;
        pr, cl: in std_logic;
        q: out std_logic
    );
end;

architecture b of ff_charge is
    component ffd is
        port(
            d: in std_logic;
            clk: in std_logic;
            pr, cl: in std_logic;
            q, nq: out std_logic
        );
    end component;
        

    signal sq, snq_dump, sout_mux: std_logic;
begin
    sout_mux <= sq when nrw='0' else d;
    u_ffd: ffd port map(sout_mux, clk, pr, cl, sq, snq_dump);
    q <= sq;
end;

