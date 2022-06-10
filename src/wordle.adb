--  STEP 2: Enable the use of colors.
--  There is an ANSI crate providing color sequences for most usual terminals.
--  If you are on Windows 10, this should work too. Otherwise you can skip to
--  step 4 at the bottom of this file.
--  More info: https://stackoverflow.com/questions/51680709/colored-text-output
--             -in-powershell-console-using-ansi-vt100-codes
--
--  TODO: add the 'ansiada' dependency. This crate is available normally in the
--  community index, so you only need to 'alr with' it.
--
--  TODO: after adding it, you need to close and reopen your editor; otherwise
--  the environment won't contain the new crate and the build will fail.
--
--  TODO: look for the "Print_Char" procedure below (around line 100). Continue
--  with STEP 3 from there.

with AAA.Strings;

with Ada.Text_IO; use Ada.Text_IO;

--  with AnsiAda;

with Wordlelib;
--  with Wordlist;

procedure Wordle is

   Max_Attempts : constant := 6;
   Word_Length  : constant := 5;

   package W is new Wordlelib (Word_Length);

   -------------------
   -- Word_To_Guess --
   -------------------

   function Word_To_Guess return String is
   begin
      --  return
      --    AAA.Strings.To_Upper_Case
      --      (Wordlist
      --       .With_Length (Word_Length)
      --       .To_Vector
      --       .Random_Word);
      return "QUICK";
   end Word_To_Guess;

   Game : W.Game := W.New_Game (Word_To_Guess);
   --  This variable encapsulates the game progression. We need to pass as the
   --  only argument the word to be guessed by the user.

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
            --  elsif not Wordlist.With_Length (Word_Length).Contains
            --    (AAA.Strings.To_Lower_Case (Attempt))
            --  then
            --     Put_Line ("I don't know that word, "
            --               & "I apologize about my ignorance...");
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

      ----------------
      -- Print_Char --
      ----------------
      --
      --  STEP 3: Uncomment the implementation below of the Print_Char
      --  procedure, and comment the current implementation that isn't
      --  using Ansiada.
      --  TODO: also add/uncomment "with AnsiAda;" at the top of this file.
      --  TODO: execute the game with the new implementation and verify colors
      --    are now showing. This would be also a good time to inspect the spec
      --    in wordlelib.ads if you're curious about how track of the game is
      --    being kept.
      --  TODO: continue with step 4 at the bottom of this file.
      --
      --  procedure Print_Char (Char : Character; Kind : W.Guess_Kind) is
      --     use AnsiAda;
      --     use all type W.Guess_Kind;
      --  begin
      --     Put (AnsiAda.Wrap (Char & "", Bright,
      --          Foreground (case Kind is
      --                         when Hit        => Green,
      --                         when Miss       => Grey,
      --                         when Missplaced => Yellow)));
      --  end Print_Char;

      procedure Print_Char (Char : Character; Kind : W.Guess_Kind) is
         use all type W.Guess_Kind;
      begin
         Put (Char & "");
         Put (case Kind is
                 when Hit => "* ",
                 when Missplaced => "+ ",
                 when Miss       => "  ");
      end Print_Char;

   begin
      for I in Attempt'Range loop
         Print_Char (Attempt (I), Guess (I));
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

--  STEP 4: using a random word.
--  As you'll have noticed, we are now playing using always a predefined word.
--  To fix this issue we are going to use a wordlist, which is available in the
--  crate with the same name. We could simply pin it, but to spice things a bit
--  up, we'll first use the indexed version in a personal index of mine.
--
--  TODO: verify "wordlist" is not yet available, running either
--    alr show wordlist
--    alr search --crates wordlist
--
--  TODO: add a new index, found at
--    https://github.com/mosteo/alire-personal-index
--  To do so, you can use the `alr index` command. Check its help, or the
--- slides that explain how to use it. The syntax to use is
--    alr index --add <url> --name <name>
--  The name is arbitrary (e.g., you can use "personal" or "mosteo").
--
--  TODO: verify the index is properly added by running `alr index`
--
--  TODO: check that the "wordlist" crate is available now with
--    alr show <crate name>
--
--  TODO: add the crate as a dependency with `alr with`. Don't forget to close
--    and reopen the editor afterwards.
--
--  TODO: continue with step 5, found in file step5.txt at the root of the
--    wordle_ada repository you're already working with.
