import {createElement} from 'complate-stream';
import MyButton from '../../components/button';

export default ({text}) => {
  return <span>
    <MyButton text={text}></MyButton>
  </span>;
};
