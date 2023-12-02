import time
from lib import color
import os

def get_free_energy(di_seq: str):
    energy_mapping = {
        "AA": -1.00,
        "TT": -1.00,
        "AT": -0.88,
        "TA": -0.58,
        "CA": -1.45,
        "TG": -1.45,
        "GT": -1.44,
        "AC": -1.44,
        "CT": -1.28,
        "AG": -1.28,
        "GA": -1.30,
        "TC": -1.30,
        "CG": -2.17,
        "GC": -2.24,
        "GG": -1.84,
        "CC": -1.84,
    }

    return energy_mapping.get(di_seq, f"{di_seq} is not a valid dinucleotide sequence")


def calculate():
    print(f"{color.YELLOW} scanning...{color.RESET}", end="\r")

    energy_values = []
    with open(os.path.join('resources', 'ecoli_k12.fna'), "r") as fasta_file:
        fasta_seq = "".join(fasta_file.readlines()[1:]).replace("\n", "")
        for index, current_pair in enumerate(zip(fasta_seq, fasta_seq[1:])):
            di_seq = "".join(current_pair)
            free_energy = get_free_energy(di_seq)
            energy_values.append(str(free_energy))
    
    with open(os.path.join("output", "files", "free_energy.txt"), "w") as output_file:
        output_file.write(",".join(energy_values))
        print(
            f"{color.GREEN} \u2713 Free energy values added successfully to {color.YELLOW}'output\\files\\free_energy.txt'{color.RESET}"
        )
