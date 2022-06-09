with AAA.Strings;

with Ada.Text_IO; use Ada.Text_IO;

with AnsiAda;

with Wordlelib;
with Wordlist;

procedure Wordle is

   Max_Attempts : constant := 6;

   Word_Length  : constant := 5;

   package W is new Wordlelib (Word_Length);

   Candidates : constant Wordlist.Word_Vector :=
                  Wordlist.With_Length (Word_Length).To_Vector;

   Game : W.Game :=
            W.New_Game (AAA.Strings.To_Upper_Case (Candidates.Random_Word));

   ----------------
   -- User_Input --
   ----------------

   function User_Input return W.Word is
   begin
      loop
         Put ("Please enter your guess #"
              & AAA.Strings.Trim (Integer (Game.Attempt_Count + 1)'Image)
              & ": ");
         declare
            Attempt : constant String := AAA.Strings.To_Upper_Case (Get_Line);
         begin
            if Attempt'Length /= Word_Length then
               Put_Line ("Words must have"
                         & Word_Length'Image & " characters");
            elsif Attempt not in W.Word then
               Put_Line ("That's not a valid input!");
            elsif not Wordlist.With_Length (Word_Length).Contains
              (AAA.Strings.To_Lower_Case (Attempt))
            then
               Put_Line ("I don't know that word, "
                         & "I apologize about my ignorance...");
            else
               return Attempt;
            end if;
         end;
      end loop;
   end User_Input;

   -----------
   -- Print --
   -----------

   procedure Print (Attempt : W.Word; Guess : W.Guess_Result) is
      use AnsiAda;
      use all type W.Guess_Kind;
   begin
      for I in Attempt'Range loop
         case Guess (I) is
            when Hit =>
               Put (Wrap (Attempt (I) & "", Bright, Foreground (Green)));
            when Miss =>
               Put (Wrap (Attempt (I) & "", Default, Foreground (Grey)));
            when Missplaced =>
               Put (Wrap (Attempt (I) & "", Bright, Foreground (Yellow)));
         end case;
      end loop;
      New_Line;
   end Print;

begin
   Put_Line ("*** Welcome to WORDLE ***");

   while Game.Attempt_Count < Max_Attempts loop

      Game.Make_Attempt (User_Input);

      for I in 1 .. Game.Attempt_Count loop
         Print (Game.Attempts (I), Game.Guesses (I));
      end loop;

      exit when Game.Attempt_Count = Max_Attempts or else Game.Won;

   end loop;

   if Game.Won then
      Put_Line ("Congratulations! You guessed it correctly");
   else
      Put_Line ("I'm sorry, you ran out of attempts.");
      Put_Line ("The word was: " & Game.Target);
   end if;
end Wordle;
