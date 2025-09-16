import datetime
import os
from typing import List, Tuple


class WallpaperRenamer:
    """A class to rename wallpaper image files in a folder based on their creation date."""

    def __init__(self, folder: str = ".") -> None:
        """
        Initializes the WallpaperRenamer.

        Args:
            folder (str): The folder containing the wallpaper files. Defaults to current directory.
        """
        self.folder = folder

    def get_creation_date(self, path: str) -> datetime.datetime:
        """
        Gets the creation date of a file. Falls back to last modified date if creation date is unavailable.

        Args:
            path (str): The file path.

        Returns:
            datetime.datetime: The creation or last modified date of the file.
        """
        stat = os.stat(path)
        try:
            # On Mac, st_birthtime is the creation date
            return datetime.datetime.fromtimestamp(stat.st_birthtime)
        except AttributeError:
            # Fallback to last modified date
            return datetime.datetime.fromtimestamp(stat.st_mtime)

    def get_image_files(self) -> List[str]:
        """
        Retrieves a list of image files in the folder.

        Returns:
            List[str]: List of image file names.
        """
        return [
            f
            for f in os.listdir(self.folder)
            if f.lower().endswith((".jpg", ".jpeg", ".png"))
        ]

    def get_files_with_dates(self) -> List[Tuple[str, datetime.datetime]]:
        """
        Gets a list of tuples containing file names and their creation dates.

        Returns:
            List[Tuple[str, datetime.datetime]]: List of (filename, creation_date) tuples.
        """
        files = self.get_image_files()
        files_with_dates = []
        for f in files:
            path = os.path.join(self.folder, f)
            date = self.get_creation_date(path)
            files_with_dates.append((f, date))
        return files_with_dates

    def rename_files(self) -> None:
        """
        Renames the image files in the folder based on their creation date.
        """
        files_with_dates = self.get_files_with_dates()
        files_with_dates.sort(key=lambda x: x[1])

        for idx, (filename, date) in enumerate(files_with_dates, 1):
            ext = os.path.splitext(filename)[1]
            date_str = date.strftime("%Y%m%d")
            new_name = f"{idx:02d}-wallpaper-{date_str}{ext}"
            src = os.path.join(self.folder, filename)
            dst = os.path.join(self.folder, new_name)
            os.rename(src, dst)
            print(f"Renamed '{filename}' -> '{new_name}'")


def main() -> None:
    """
    Main function to execute the wallpaper renaming process.
    """
    renamer = WallpaperRenamer()
    renamer.rename_files()
    print("Wallpaper files renamed successfully.")


if __name__ == "__main__":
    main()
