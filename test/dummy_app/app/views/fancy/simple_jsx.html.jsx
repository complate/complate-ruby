import { createElement } from 'complate-stream';
import MyButton from '../../components/button';

export default ({ text }) => {
  return <ul>
    <li>{(cb) => cb(<p>I could be async!</p>)}</li>
    <li>
      <span>
        <MyButton text={text} href={rails.fancy_simple_jsx_path({ x: 44 })}></MyButton>
      </span>
    </li>
  </ul>;
};
