"""An AI-Powered Riddle Game"""

import from byllm.llm { Model }

glob llm = Model(model_name="gemini/gemini-2.0-flash", verbose=False);

"""Generate a riddle in JSON with fields 'riddle' and 'answer'"""
def generate_riddle() -> dict[str, str] by llm();

"""Provide a hint based on the riddle and the wrong guess"""
def give_hint(riddle: str, guess: str) -> str by llm();

walker RiddleGame {
    has riddle: str = "";
    has answer: str = "";
    has attempts: int = 0;
    has forfeited: bool = False;

    can start with entry {
        print("\n🎭 Welcome to the AI Riddle Game!");
        print("Type your guess, or 'forfeit' to give up.\n");

        let data = generate_riddle();
        self.riddle = data["riddle"];
        self.answer = data["answer"];

        print("Riddle: " + self.riddle);
        visit turn();
    }

    can process_guess with turn entry {
        print("\nYour answer (or 'forfeit'):");
        let guess = input();

        if guess == "forfeit" {
            self.forfeited = True;
            print("You gave up! The answer was: " + self.answer);
            return;
        }

        if guess.lower() == self.answer.lower() {
            print("✅ Correct! 🎉");
            return;
        } else {
            self.attempts = self.attempts + 1;
            let hint = give_hint(self.riddle, guess);
            print("❌ Wrong guess. 💡 Hint: " + hint);
            visit turn();
        }
    }
}

node turn { }

with entry:__main__ {
    root spawn RiddleGame();
}
