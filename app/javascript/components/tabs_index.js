
const toogleTab = () => {

  const clickButton1 = document.getElementById("tab1");
  const clickButton2 = document.getElementById("tab2");

  const tab1 = document.getElementById("my-communities");
  const tab2 = document.getElementById("participate-in");

  if (clickButton1) {
    clickButton1.addEventListener('click', (event) => {
      event.currentTarget.classList.add('active');
      clickButton2.classList.remove('active');

      tab1.classList.remove('inactive-tab')
      tab2.classList.add('inactive-tab')
    });

    clickButton2.addEventListener('click', (event) => {
      event.currentTarget.classList.add('active');
      clickButton1.classList.remove('active');

      tab2.classList.remove('inactive-tab')
      tab1.classList.add('inactive-tab')
    });
  }
};

export { toogleTab };