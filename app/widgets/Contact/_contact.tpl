{if="$contact != null"}
    {$url = $contact->getPhoto('s')}
<div class="block">
    <header class="big"
        {if="$url"}
            style="background-image: linear-gradient(to bottom, rgba(0,0,0,0.5) 0%, rgba(0,0,0,0) 100%), url('{$contact->getPhoto('xxl')}');"
        {else}
            style="background-color: rgba(62,81,181,1);"
        {/if}
        >
        <ul class="thick">
            <li class="condensed">
                {if="$url"}
                    <span class="icon bubble color {if="isset($presence)"}status {$presence}{/if}">
                        <img src="{$url}">
                    </span>
                {else}
                    <span class="icon bubble color {$contact->jid|stringToColor} {if="isset($presence)"}status {$presence}{/if}">
                        <i class="zmdi zmdi-account"></i>
                    </span>
                {/if}
                <span>
                    <h2>{$contact->getTrueName()}</h2>
                </span>
                <p>{$contact->jid}</p>
            </li>
            {if="$caps"}
                <li>
                    <span class="icon">
                        <i class="zmdi
                            {if="$caps->type == 'handheld' || $caps->type == 'phone'"}
                                zmdi-smartphone-android
                            {elseif="$caps->type == 'bot'"}
                                zmdi-memory
                            {else}
                                zmdi-laptop
                            {/if}
                        ">
                        </i>
                    </span>
                    <span>
                        {$caps->name}
                        {if="isset($clienttype[$caps->type])"}
                            - {$clienttype[$caps->type]}
                        {/if}
                    </span>
                </li>
            {/if}
        </ul>
    </header>
    <a onclick="{$chat}" class="button action color red">
        <i class="zmdi zmdi-comment-text-alt"></i>
    </a>

    <ul class="flex">
        {if="$contact->delay != null"}
        <li class="condensed block">
            <span class="icon brown"><i class="zmdi zmdi-restore"></i></span>
            <span>{$c->__('last.title')}</span>
            <p>{$contact->delay}</p>
        </li>
        {/if}

        {if="$contact->fn != null"}
        <li class="condensed block">
            <span class="icon gray">{$contact->fn|firstLetterCapitalize}</span>
            <span>{$c->__('general.name')}</span>
            <p>{$contact->fn}</p>
        </li>
        {/if}

        {if="$contact->nickname != null"}
        <li class="condensed block">
            <span class="icon gray">{$contact->nickname|firstLetterCapitalize}</span>
            <span>{$c->__('general.nickname')}</span>
            <p>{$contact->nickname}</p>
        </li>
        {/if}

        {if="strtotime($contact->date) != 0"}
        <li class="condensed block">
            <span class="icon gray"><i class="zmdi zmdi-cake"></i></span>
            <span>{$c->__('general.date_of_birth')}</span>
            <p>{$contact->date|strtotime|prepareDate:false}</p>
        </li>
        {/if}

        {if="$contact->url != null"}
        <li class="condensed block">
            <span class="icon gray"><i class="zmdi zmdi-link"></i></span>
            <span>{$c->__('general.website')}</span>
            <p class="wrap">
                {if="filter_var($contact->url, FILTER_VALIDATE_URL)"}
                    <a href="{$contact->url}" target="_blank">{$contact->url}</a>
                {else}
                    {$contact->url}
                {/if}
            </p>
        </li>
        {/if}

        {if="$contact->email != null"}
        <li class="condensed block">
            <span class="icon gray"><i class="zmdi zmdi-email"></i></span>
            <span>{$c->__('general.email')}</span>
            <p><img src="{$contact->getPhoto('email')}"/></p>
        </li>
        {/if}

        {if="$contact->getMarital() != null"}
        <li class="condensed block">
            <span class="icon gray"><i class="zmdi zmdi-accounts"></i></span>
            <span>{$c->__('general.marital')}</span>
            <p>{$contact->getMarital()}</p>
        </li>
        {/if}

        {if="$contact->getGender() != null"}
        <li class="condensed block">
            <span class="icon gray"><i class="zmdi zmdi-face"></i></span>
            <span>{$c->__('general.gender')}</span>
            <p>{$contact->getGender()}</p>
        </li>
        {/if}

        {if="$contactr->delay != null"}
        <li class="condensed block">
            <span class="icon gray"><i class="zmdi zmdi-time-countdown"></i></span>
            <span>{$c->__('last.title')}</span>
            <p>{$contactr->delay|strtotime|prepareDate}</p>
        </li>
        {/if}

        {if="$contact->mood != null"}
        {$moods = unserialize($contact->mood)}
        <li class="condensed block">
            <span class="icon gray"><i class="zmdi zmdi-mood"></i></span>
            <span>{$c->__('mood.title')}</span>
            <p>{loop="$moods"}
                {$mood[$value]}
                {/loop}
            </p>
        </li>
        {/if}

        {if="$contact->description != null && trim($contact->description) != ''"}
        <li class="condensed block large">
            <span class="icon gray"><i class="zmdi zmdi-format-align-justify"></i></span>
            <span>{$c->__('general.about')}</span>
            <p class="all">{$contact->description}</p>
        </li>
        {/if}
    </ul>
    <br />

    {if="$blog != null"}
        <ul class="active block flex">
            <li class="block large subheader">{$c->__('blog.last')}</li>
            {loop="$blog"}
                <li class="block condensed" onclick="movim_reload('{$c->route('news', $value->nodeid)}')">
                    {$url = $value->getContact()->getPhoto('l')}
                    {if="$url"}
                        <span class="icon bubble" style="background-image: url({$url});">
                        </span>
                    {else}
                        <span class="icon thumb color {$value->getContact()->jid|stringToColor}">
                            <i class="zmdi zmdi-account"></i>
                        </span>
                    {/if}
                    {if="$value->title != null"}
                        <span>{$value->title}</span>
                    {else}
                        <span>{$c->__('hello.contact_post')}</span>
                    {/if}
                    <p>{$value->contentcleaned|strip_tags}</p>
                    <span class="info">{$value->published|strtotime|prepareDate}</span>
                </li>
            {/loop}
            <a href="{$c->route('blog', array($contact->jid))}" target="_blank" class="block large">
                <li class="action">
                    <div class="action">
                        <i class="zmdi zmdi-chevron-right"></i>
                    </div>
                    <span class="icon">
                        <i class="zmdi zmdi-portable-wifi"></i>
                    </span>
                    <span>{$c->__('blog.visit')}</span>
                </li>
            </a>
        </ul>
    {/if}

    {$album = $contact->getAlbum()}
    {if="$album"}
    <ul class="flex">
        <li class="subheader block large">{$c->__('general.tune')}</li>

        <li class="
            block
            {if="$contact->tunetitle"}condensed{/if}
            action
            ">
            
            <div class="action">
                <a href="{$album->url}" target="_blank">
                    <i class="zmdi zmdi-radio"></i>
                </a>
            </div>
            <span class="icon bubble">
                {if="isset($album->url)"}
                    <img src="{$album->url}"/>
                {else}
                    <i class="zmdi zmdi-play-circle-fill"></i>
                {/if}
            </span>
            <span>
                {if="$contact->tuneartist"}
                    {$contact->tuneartist} -
                {/if}
                {if="$contact->tunesource"}
                    {$contact->tunesource}
                {/if}
            </span>
            {if="$contact->tunetitle"}
                <p>{$contact->tunetitle}</p>
            {/if}
        </li>
    </ul>
    <br />
    {/if}

    {if="$contact->adrlocality != null || $contact->adrcountry != null"}
    <ul class="flex">
        <li class="subheader block large">{$c->__('position.legend')}</li>

        {if="$contact->adrlocality != null"}
        <li class="condensed block">
            <span class="icon gray"><i class="zmdi zmdi-city"></i></span>
            <span>{$c->__('position.locality')}</span>
            <p>
                {$contact->adrlocality}
            </p>
        </li>
        {/if}
        {if="$contact->adrcountry != null"}
        <li class="condensed block">
            <span class="icon gray"><i class="zmdi zmdi-pin"></i></span>
            <span>{$c->__('position.country')}</span>
            <p>
                {$contact->adrcountry}
            </p>
        </li>
        {/if}
    </ul>
    <br />
    {/if}

    <div class="clear"></div>
    {if="$contact->twitter != null || $contact->skype != null || $contact->yahoo != null"}
    <ul class="flex">
        <li class="subheader block large">{$c->__('general.accounts')}</li>

        {if="$contact->twitter != null"}
        <li class="condensed block">
            <span class="icon gray">
                <i class="zmdi zmdi-twitter"></i>
            </span>
            <span>Twitter</span>
            <p>
                <a
                    target="_blank"
                    href="https://twitter.com/{$contact->twitter}">
                    @{$contact->twitter}
                </a>
            </p>
        </li>
        {/if}
        {if="$contact->skype != null"}
        <li class="condensed block">
            <span class="icon gray">S</span>
            <span>Skype</span>
            <p>
                <a
                    target="_blank"
                    href="callto://{$contact->skype}">
                    {$contact->skype}
                </a>
            </p>
        </li>
        {/if}
        {if="$contact->yahoo != null"}
        <li class="condensed block">
            <span class="icon gray">Y</span>
            <span>Yahoo!</span>
            <p>
                <a
                    target="_blank"
                    href="ymsgr:sendIM?{$contact->yahoo}">
                    {$contact->yahoo}
                </a>
            </p>
        </li>
        {/if}
    </ul>
    <br />
    {/if}

    {if="isset($gallery)"}
        <ul>
            <li class="subheader">{$c->__('page.gallery')}</li>
        </ul>
        <ul class="grid active padded">
            {loop="$gallery"}
                {$attachements = $value->getAttachements()}
                <li style="background-image: url('{$attachements['pictures'][0]['href']}');"
                    onclick="movim_reload('{$c->route('news', $value->nodeid)}')">
                    <nav>
                        <span>{$value->title}</span>
                    </nav>
                </li>
            {/loop}
        </ul>
    {/if}

    {if="$contactr && $contactr->rostersubscription != 'both'"}
        <div class="card">
            <ul class="middle">
                <li class="condensed">
                    {if="$contactr->rostersubscription == 'to'"}
                        <span class="icon gray">
                            <i class="zmdi zmdi-arrow-in"></i>
                        </span>
                        <span>{$c->__('subscription.to')}</span>
                        <p>{$c->__('subscription.to_text')}</p>
                        <a class="button flat" onclick="Notifs_ajaxAccept('{$contactr->jid}')">
                            {$c->__('subscription.to_button')}
                        </a>
                    {/if}
                    {if="$contactr->rostersubscription == 'from'"}
                        <span class="icon gray">
                            <i class="zmdi zmdi-arrow-out"></i>
                        </span>
                        <span>{$c->__('subscription.from')}</span>
                        <p>{$c->__('subscription.from_text')}</p>
                        <a class="button flat" onclick="Notifs_ajaxAsk('{$contactr->jid}')">
                            {$c->__('subscription.from_button')}
                        </a>
                    {/if}
                    {if="$contactr->rostersubscription == 'none'"}
                        <span class="icon gray">
                            <i class="zmdi zmdi-block"></i>
                        </span>

                        <span>{$c->__('subscription.nil')}</span>
                        <p>{$c->__('subscription.nil_text')}</p>
                        <a class="button flat" onclick="Notifs_ajaxAsk('{$contactr->jid}')">
                            {$c->__('subscription.nil_button')}
                        </a>
                    {/if}
                </li>
            </ul>
        </div>
    {/if}
{else}
    <ul class="thick">
        <li>
            <span class="icon bubble"><img src="{$contactr->getPhoto('l')}"></span>
            <h2>{$contactr->getTrueName()}</h2>
        </li>
    </ul>
</div>
{/if}
