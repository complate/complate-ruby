import {createElement} from 'complate-stream';

export default ({text, href}) => {
	return <a class="button" href={href}>{text}</a>;
}
