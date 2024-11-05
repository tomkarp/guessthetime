import './assets/style.css';

import Main from './src/Main.elm';

let app = Main.init({
    node: document.getElementById('app'),
    flags: {
        myFlag: "Hi, this is a flag from JS"
    }
});
