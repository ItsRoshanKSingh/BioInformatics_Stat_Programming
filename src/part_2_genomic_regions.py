import random
import os
from typing import List
from lib import color


def extract():
    with open(os.path.join("output","files","free_energy.txt"), "r") as energy_file:
        free_energy_values = [float(value) for value in energy_file.read().split(",")]

    promoter_regions = []
    non_promoter_regions = []

    with open(os.path.join("resources","ecoli_k12_tss.txt"), "r") as tss_file:
        for tss_row in tss_file:
            if "forward" in tss_row:
                forward_index = int(tss_row.removesuffix("\n").split("\t")[1].strip())

                promoter_regions.append(
                    get_promotors(forward_index, free_energy_values)
                )
            else:
                random_start = random.randint(0, len(free_energy_values) - 200)
                random_end = random_start + 200
                non_promoter_regions.append(free_energy_values[random_start:random_end])

    with open(os.path.join("output","files","promoter_regions.csv"), "w") as file:
        print(
            f"{color.GREEN} \u2713 Promoter Region Values added to file:{color.YELLOW} 'output/files/promoter_regions.csv'{color.RESET}"
        )
        for region in promoter_regions:
            file.write(",".join(map(str, region)) + "\n")

    with open(os.path.join("output","files","non_promoter_regions.csv"), "w") as file:
        print(
            f"{color.GREEN} \u2713 Non-Promoter Region Values added to file:{color.YELLOW} 'output/files/non_promoter_regions.csv'{color.RESET}"
        )
        for region in non_promoter_regions:
            file.write(",".join(map(str, region)) + "\n")


def get_promotors(promotor_index: int, free_energy_values: List[float]) -> List[float]:
    start = int(promotor_index) - 150
    end = int(promotor_index) + 50
    return free_energy_values[start:end]
