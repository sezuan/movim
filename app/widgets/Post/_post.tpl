<article class="block">
    {if="isset($attachements.pictures)"}
    <header
        class="big"
        style="
            background-image: linear-gradient(to bottom, rgba(0,0,0,0.9) 0%, rgba(0,0,0,0.5) 100%), url('{$attachements['pictures'][0]['href']}');">
    {else}
    <header>
    {/if}
        <ul class="thick">
            <li class="condensed">
                {if="$recycled"}
                    {$contact = $recycled}
                {else}
                    {$contact = $post->getContact()}
                {/if}

                {if="$post->node == 'urn:xmpp:microblog:0'"}
                    <a href="{$c->route('contact', $contact->jid)}">
                        {$url = $contact->getPhoto('s')}
                        {if="$url"}
                            <span class="icon bubble">
                                <img src="{$url}">
                            </span>
                        {else}
                            <span class="icon bubble color {$contact->jid|stringToColor}">
                                <i class="zmdi zmdi-account"></i>
                            </span>
                        {/if}
                    </a>
                {else}
                    <a href="{$c->route('group', array($post->origin, $post->node))}">
                        <span class="icon bubble color {$post->node|stringToColor}">{$post->node|firstLetterCapitalize}</span>
                    </a>
                {/if}
                <h2 {if="$post->title != null"}title="{$post->title|strip_tags}"{/if}>
                    {if="$post->title != null"}
                        {$post->title}
                    {else}
                        {$c->__('post.default_title')}
                    {/if}
                </h2>
                <p>
                    {if="$contact->getTrueName() != ''"}
                        <a href="{$c->route('contact', $contact->jid)}">
                            <i class="zmdi zmdi-account"></i> {$contact->getTrueName()}
                        </a> –
                    {/if}
                    {if="$post->node != 'urn:xmpp:microblog:0'"}
                        {$post->origin} /
                        <a href="{$c->route('group', array($post->origin, $post->node))}">
                            <i class="zmdi zmdi-pages"></i> {$post->node}
                        </a> –
                    {/if}
                    {$post->published|strtotime|prepareDate}
                    {if="$post->published != $post->updated"}
                        - <i class="zmdi zmdi-edit"></i> {$post->updated|strtotime|prepareDate}
                    {/if}
                </p>
            </li>
        </ul>
    </header>

    <section>
        <content>
            {if="$post->isShort() && isset($attachements.pictures)"}
                {loop="$attachements.pictures"}
                    <a href="{$value.href}" class="alternate" target="_blank">
                        <img class="big_picture" type="{$value.type}" src="{$value.href|urldecode}"/>
                    </a>
                {/loop}
            {/if}
            {$post->contentcleaned}
        </content>
    </section>

    <footer>
        <ul class="middle divided spaced">
            {if="isset($attachements.links)"}
                {loop="$attachements.links"}
                    {if="substr($value.href, 0, 5) != 'xmpp:' && filter_var($value.href, FILTER_VALIDATE_URL)"}
                        <li>
                            <span class="icon">
                                <img src="https://icons.duckduckgo.com/ip2/{$value.url.host}.ico"/>
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
        {if="!$post->isShort() && isset($attachements.pictures)"}
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
        {if="$post->isMine()"}
            <ul class="middle">
                <li class="action">
                    <form>
                        <div class="action">
                            <div class="checkbox">
                                <input
                                    type="checkbox"
                                    id="privacy"
                                    name="privacy"
                                    {if="$post->privacy"}
                                        checked
                                    {/if}
                                    onclick="Post_ajaxTogglePrivacy('{$post->nodeid}')">
                                <label for="privacy"></label>
                            </div>
                        </div>
                    </form>
                    <span class="icon gray">
                        <i class="zmdi zmdi-portable-wifi"></i>
                    </span>
                    <span>
                        <a target="_blank" href="{$post->getPublicUrl()}">
                            {$c->__('post.public')}
                        </a>
                    </span>
                </li>
            </ul>
        {/if}
    </footer>

    {if="$recycled"}
        <a href="{$c->route('contact', $post->getContact()->jid)}">
            <ul class="active middle">
                <li class="condensed action">
                    <div class="action">
                        <i class="zmdi zmdi-chevron-right"></i>
                    </div>
                    {$url = $post->getContact()->getPhoto('s')}
                    {if="$url"}
                        <span class="icon bubble" style="background-image: url('{$url}');">
                            <i class="zmdi zmdi-loop"></i>
                        </span>
                    {else}
                        <span class="icon bubble color {$post->getContact()->jid|stringToColor}">
                            <i class="zmdi zmdi-loop"></i>
                        </span>
                    {/if}

                    <span>{$c->__('post.repost', $post->getContact()->getTrueName())}</span>
                    <p>{$c->__('post.repost_profile', $post->getContact()->getTrueName())}</p>
                </li>
            </ul>
        </a>
    {/if}

    <div id="comments"></div>
</article>
