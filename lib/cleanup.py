import os
from lib import color


class Output:
    @staticmethod
    def clean(folder_path="output"):
        print("\n", "#" * 20 + " Cleanup Started " + "#" * 20, "\n")
        try:
            for filename in os.listdir("output\\files\\"):
                print(
                    f"{color.YELLOW} Cleaning up Output folder...{color.RESET}",
                    end="\r",
                )
                file_path = os.path.join(folder_path, "files", filename)
                if os.path.isfile(file_path):
                    os.remove(file_path)
                    print(f"{color.RED} Deleted: {file_path}{color.RESET}")

            for filename in os.listdir("output\\graph\\"):
                print(
                    f"{color.YELLOW} Cleaning up Output folder...{color.RESET}",
                    end="\r",
                )
                file_path = os.path.join(folder_path, "graph", filename)
                if os.path.isfile(file_path):
                    os.remove(file_path)
                    print(f"{color.RED} Deleted: {file_path}{color.RESET}")

            if os.path.isfile("t-test-result.txt"):
                os.remove("t-test-result.txt")
                print(f"{color.RED} Deleted: t-test-result.txt{color.RESET}")

            print(f"{color.GREEN} \u2713 Cleanup complete.{color.RESET}\n")
        except Exception as e:
            print(f" Error during cleanup: {e}")
