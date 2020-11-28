function ShowMenuPage() {
  const editButton = document.getElementById("menu_edit_btn");
  const editForm = document.getElementById("menu_edit_form");
  const Heading = document.getElementById("menu_heading");
  let formState = false;
  editButton.addEventListener("click", (event) => {
    if (formState === true) {
      editButton.innerHTML = "Edit";
      editForm.style.display = "none";
      Heading.style.display = "block";
      formState = false;
    } else {
      editButton.innerHTML = "Close";
      editButton.style.marginTop = 0;
      editForm.style.display = "block";
      Heading.style.display = "none";
      formState = true;
    }
  });
}
