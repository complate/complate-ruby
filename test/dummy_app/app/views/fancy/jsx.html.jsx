import {createElement} from 'complate-stream';
import MyButton from '../../components/button';

export default ({text}) => {
  return <span>
    <MyButton text={text} href={rails.fancy_jsx_path()}></MyButton>
  </span>;
};
