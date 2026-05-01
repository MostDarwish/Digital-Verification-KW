import os
import shutil

TARGET_EXTENSIONS = {".xml", ".wlf", ".vstf"}

def clean_directory(root_dir):
    for dirpath, dirnames, filenames in os.walk(root_dir, topdown=False):

        # 1. Remove folders named "work"
        for dirname in dirnames:
            if dirname.lower() == "work":
                full_path = os.path.join(dirpath, dirname)
                print(f"Removing folder: {full_path}")
                shutil.rmtree(full_path)

        # 2. Remove unwanted files
        for filename in filenames:
            full_path = os.path.join(dirpath, filename)
            name, ext = os.path.splitext(filename)

            # Remove "transcript" files
            if name.lower() == "transcript":
                print(f"Removing file: {full_path}")
                os.remove(full_path)

            # Remove files with specific extensions
            elif ext.lower() in TARGET_EXTENSIONS:
                print(f"Removing file: {full_path}")
                os.remove(full_path)


if __name__ == "__main__":
    project_path = r"."  # change this
    clean_directory(project_path)
    print("Cleanup completed.")