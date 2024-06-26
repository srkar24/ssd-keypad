library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity ssd_keypad_top is
   port (
       clk : in STD_LOGIC;
       btn : in STD_LOGIC_VECTOR(3 downto 0);
       kypd : inout STD_LOGIC_VECTOR (7 downto 0); -- PmodKYPD is designed to be connected to JA
       chip_sel : out STD_LOGIC; -- Controls which position of the seven segment display to display
       seg : out STD_LOGIC_VECTOR (6 downto 0);
       sw : in STD_LOGIC_VECTOR(3 downto 0);
       led : out STD_LOGIC_VECTOR(3 downto 0)
   );
end ssd_keypad_top;

architecture Behavioral of ssd_keypad_top is

   constant clk_freq : INTEGER := 50_000_000;
   constant stable_time : INTEGER := 10;

   component debounce
       generic (
           clk_freq : INTEGER := 50_000_000;
           stable_time : INTEGER := 10
       );
       port (
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           button : in STD_LOGIC;
           result : out STD_LOGIC);
   end component;

   component single_pulse_detector
       generic (detect_type : STD_LOGIC_VECTOR(1 downto 0) := "01");
       port (
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           input_signal : in STD_LOGIC;
           output_pulse : out STD_LOGIC);
   end component;

   component DisplayController is
       port (
           --output from the Decoder
           DispVal : in STD_LOGIC_VECTOR (3 downto 0);
           --controls which digit to display
           segOut : out STD_LOGIC_VECTOR (6 downto 0));
   end component;
   
   component Decoder is
       port (
           clk : in STD_LOGIC;
           rst: in std_logic;
           Row : in STD_LOGIC_VECTOR (3 downto 0);
           Col : out STD_LOGIC_VECTOR (3 downto 0);
           DecodeOut : out STD_LOGIC_VECTOR (3 downto 0);
           is_a_key_pressed: out std_logic
           );
    end component;
   
   signal rst : STD_LOGIC;
   signal btn1_debounce : STD_LOGIC;
   signal btn1_pulse : STD_LOGIC;
   signal c_sel : STD_LOGIC;
   signal decode : STD_LOGIC_VECTOR (3 downto 0);
   signal is_kypd_pressed: std_logic;
   
begin

   db1 : debounce port map(clk => clk, rst => rst, button => btn(1), result => btn1_debounce);
   pd1 : single_pulse_detector port map(clk => clk, rst => rst, input_signal => btn1_debounce, output_pulse => btn1_pulse);
   DC0 : Decoder port map(clk => clk, rst => rst, Row => kypd(7 downto 4), Col => kypd(3 downto 0), DecodeOut => decode, is_a_key_pressed => is_kypd_pressed);
   ssd1 : DisplayController port map(DispVal => decode, segOut => seg); 

   process (rst, clk)
   begin
       if rst = '1' then
           c_sel <= '0';
       elsif rising_edge (clk) and btn1_pulse = '1' then
           c_sel <= not c_sel;
       end if;
   end process;

   rst <= btn(0);
   chip_sel <= c_sel;
   led <= decode;

end Behavioral;