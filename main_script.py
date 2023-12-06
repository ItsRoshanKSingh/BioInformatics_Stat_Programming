from lib.cleanup import Output

from src import part_1_free_energy
from src import part_2_genomic_regions


def main():
    Output.clean()
    print("\n", "#" * 25 + " Spec " + "#" * 26, "\n")
    part_1_free_energy.calculate()
    part_2_genomic_regions.extract()


if __name__ == "__main__":
    main()
