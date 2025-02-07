<div class="card shadow" title="{$c->__('page.feed')}" id="blog" >
    <ul class="thick">
        {if="$mode == 'blog'"}
        <li class="action {if="isset($contact->description)"}condensed{/if}">
            <div class="action">
                <a
                    href="{$c->route('feed', array($contact->jid))}"
                    target="_blank"
                    title="Atom"
                >
                    <i class="zmdi zmdi-portable-wifi"></i>
                </a>
            </div>
            <span class="icon gray">
                <i class="zmdi zmdi-edit"></i>
            </span>
            {if="$contact"}
            <h2>
                <a href="{$c->route('blog', array($contact->jid))}">
                    {$c->__('blog.title', $contact->getTrueName())}
                </a>
            </h2>
            {else}
            <h2>
                <a href="{$c->route('blog', array($contact->jid))}">
                    {$c->__('page.blog')}
                </a>
            </h2>
            {/if}
            {if="isset($contact->description)"}
                <p>{$contact->description}</p>
            {/if}
        </li>
        {else}
        <li class="condensed action">
            <div class="action">
                <a
                    href="{$c->route('feed', array($server, $node))}"
                    target="_blank"
                >
                    <i class="zmdi zmdi-portable-wifi"></i> Atom
                </a>
            </div>
            <span class="icon gray">
                <i class="zmdi zmdi-pages"></i>
            </span>
            <h2>
                <a href="{$c->route('node', array($server, $node))}">
                    {if="$item != null"}
                        {if="$item->name"}
                            {$item->name}
                        {else}
                            {$item->node}
                        {/if}
                    {/if}
                </a>
            </h2>
            {if="$item->description"}
                <h4 title="{$item->description|strip_tags}">
                    {$item->description|strip_tags}
                </h4>
            {else}
                <h4>{$item->server}</h4>
            {/if}
        </li>
        {/if}
    </ul>

    {loop="$posts"}
        <article class="block">
            <header>
                <ul class="thick">
                    <li class="condensed">
                        {$url = $value->getContact()->getPhoto('s')}
                        {if="$url"}
                            <span class="icon bubble">
                                <img src="{$url}">
                            </span>
                        {else}
                            <span class="icon bubble color {$value->getContact()->jid|stringToColor}">
                                <i class="zmdi zmdi-account"></i>
                            </span>
                        {/if}
                        <h2>
                            <a {if="$value->isMicroblog()"}
                                href="{$c->route('blog', array($value->origin, $value->nodeid))}"
                                {else}
                                href="{$c->route('node', array($value->origin, $value->node, $value->nodeid))}"
                                {/if}
                                >
                                {if="$value->title != null"}
                                    {$value->title}
                                {else}
                                    {$c->__('post.default_title')}
                                {/if}
                            </a>
                        </h2>
                        <p>
                            {if="$value->getContact()->getTrueName() != '' && $value->privacy"}
                                <i class="zmdi zmdi-account"></i> {$value->getContact()->getTrueName()} –
                            {/if}
                            {$value->published|strtotime|prepareDate}
                            {if="$value->published != $value->updated"}
                                - <i class="zmdi zmdi-edit"></i> {$value->updated|strtotime|prepareDate}
                            {/if}
                        </p>
                    </li>
                </ul>
            </header>
            {if="!$value->isPublic()"}
                <ul class="thick">
                    <li>
                        <span class="icon color gray bubble">
                            <i class="zmdi zmdi-lock"></i>
                        </span>
                        <p class="center"> {$c->__('blog.private')} - <a href="{$c->route('main')}">{$c->__('page.login')}</a></p>
                    </li>
                </ul>
                <br />
            {else}
                {$attachements = $value->getAttachements()}
                <section>
                    <content>
                        {if="$value->isShort() && isset($attachements.pictures)"}
                            {loop="$attachements.pictures"}
                                <a href="{$value.href}" class="alternate" target="_blank">
                                    <img class="big_picture" type="{$value.type}" src="{$value.href|urldecode}"/>
                                </a>
                            {/loop}
                        {/if}
                        {$value->contentcleaned}
                    </content>
                </section>
                <footer>
                    <ul class="middle divided spaced">
                        {if="isset($attachements.links)"}
                            {loop="$attachements.links"}
                                {if="substr($value.href, 0, 5) != 'xmpp:' && filter_var($value.href, FILTER_VALIDATE_URL)"}
                                    <li>
                                        <span class="icon">
                                            <img src="http://icons.duckduckgo.com/ip2/{$value.url.host}.ico"/>
                                        </span>
                                        <a href="{$value.href}" class="alternate" target="_blank">
                                            <span>{$value.href|urldecode}</span>
                                        </a>
                                    </li>
                                {/if}
                            {/loop}
                        {/if}
                        {if="isset($attachements.files)"}
                            {loop="$attachements.files"}
                                <li>
                                    <a
                                        href="{$value.href}"
                                        class="enclosure"
                                        type="{$value.type}"
                                        target="_blank">
                                        <span class="icon gray">
                                            <span class="zmdi zmdi-attachment-alt"></span>
                                        </span>
                                        <span>{$value.href|urldecode}</span>
                                    </a>
                                </li>
                            {/loop}
                        {/if}
                    </ul>
                    {if="!$value->isShort() && isset($attachements.pictures)"}
                        <ul class="flex middle">
                        {loop="$attachements.pictures"}
                            <li class="block pic">
                                <span class="icon gray">
                                    <i class="zmdi zmdi-image"></i>
                                </span>
                                <a href="{$value.href}" class="alternate" target="_blank">
                                    <img type="{$value.type}" src="{$value.href|urldecode}"/>
                                </a>
                            </li>
                        {/loop}
                        </ul>
                    {/if}
                </footer>
                {$comments = $c->getComments($value)}
                {if="$comments"}
                    <ul class="spaced middle">
                        <li class="subheader">
                            {$c->__('post.comments')}
                            <span class="info">{$comments|count}</span>
                        </li>
                        {loop="$comments"}
                            <li class="condensed">
                                {$url = $value->getContact()->getPhoto('s')}
                                {if="$url"}
                                    <span class="icon bubble">
                                        <img src="{$url}">
                                    </span>
                                {else}
                                    <span class="icon bubble color {$value->getContact()->jid|stringToColor}">
                                        <i class="zmdi zmdi-account"></i>
                                    </span>
                                {/if}
                                <span class="info">{$value->published|strtotime|prepareDate}</span>
                                <span>
                                    {$value->getContact()->getTrueName()}
                                </span>
                                <p class="all">
                                    {$value->contentraw}
                                </p>
                            </li>
                        {/loop}
                    </ul>
                {/if}
                <br />
            {/if}
        </article>
    {/loop}
    {if="isset($more)"}
        <article>
            <ul class="active">
                {if="$mode == 'blog'"}
                <a href="{$c->route('blog', array($contact->jid, $more))}">
                {else}
                <a href="{$c->route('group', array($server, $node, $more))}">
                {/if}
                    <li id="history" class="block large">
                        <span class="icon"><i class="zmdi zmdi-time-restore"></i></span>
                        <span>{$c->__('post.older')}</span>
                    </li>
                </a>
            </ul>
        </article>
    {/if}
    {if="$posts == null"}
        <ul class="simple thick">
            <li>
                <span>{$c->__('blog.empty')}</span>
            </li>
        </ul>
    {/if}

    <ul>
        <li>
            <a target="_blank" href="https://movim.eu">
                <span class="icon">
                    <i class="zmdi zmdi-cloud-outline"></i>
                </span>
                <span>Powered by Movim</span>
            </a>
        </li>
    </ul>
</div>
