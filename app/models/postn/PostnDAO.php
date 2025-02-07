<?php

namespace modl;

class PostnDAO extends SQL {
    function set(Postn $post) {
        $this->_sql = '
            update postn
                set aname           = :aname,
                    aid             = :aid,
                    aemail          = :aemail,

                    title           = :title,
                    content         = :content,
                    contentraw      = :contentraw,
                    contentcleaned  = :contentcleaned,

                    commentplace    = :commentplace,

                    published       = :published,
                    updated         = :updated,
                    delay           = :delay,

                    lat             = :lat,
                    lon             = :lon,

                    links           = :links,
                    picture         = :picture,
                    tags            = :tags,

                    hash            = :hash

                where origin = :origin
                    and node = :node
                    and nodeid = :nodeid';

        $this->prepare(
            'Postn',
            array(
                'aname'             => $post->aname,
                'aid'               => $post->aid,
                'aemail'            => $post->aemail,

                'title'             => $post->title,
                'content'           => $post->content,
                'contentraw'        => $post->contentraw,
                'contentcleaned'    => $post->contentcleaned,

                'commentplace'      => $post->commentplace,

                'published'         => $post->published,
                'updated'           => $post->updated,
                'delay'             => $post->delay,

                'lat'               => $post->lat,
                'lon'               => $post->lon,

                'links'             => $post->links,
                'picture'           => $post->picture,
                'tags'              => $post->tags,

                'hash'              => $post->hash,

                'origin'            => $post->origin,
                'node'              => $post->node,
                'nodeid'            => $post->nodeid
            )
        );

        $this->run('Postn');

        if(!$this->_effective) {
            $this->_sql ='
                insert into postn
                (
                origin,
                node,
                nodeid,

                aname,
                aid,
                aemail,

                title,
                content,
                contentraw,
                contentcleaned,

                commentplace,

                published,
                updated,
                delay,

                lat,
                lon,

                links,
                picture,
                tags,

                hash)
                values(
                    :origin,
                    :node,
                    :nodeid,

                    :aname,
                    :aid,
                    :aemail,

                    :title,
                    :content,
                    :contentraw,
                    :contentcleaned,

                    :commentplace,

                    :published,
                    :updated,
                    :delay,

                    :lat,
                    :lon,

                    :links,
                    :picture,
                    :tags,

                    :hash
                )';

            $this->prepare(
                'Postn',
                array(
                    'aname'             => $post->aname,
                    'aid'               => $post->aid,
                    'aemail'            => $post->aemail,

                    'title'             => $post->title,
                    'content'           => $post->content,
                    'contentraw'        => $post->contentraw,
                    'contentcleaned'    => $post->contentcleaned,

                    'commentplace'      => $post->commentplace,

                    'published'         => $post->published,
                    'updated'           => $post->updated,
                    'delay'             => $post->delay,

                    'lat'               => $post->lat,
                    'lon'               => $post->lon,

                    'links'             => $post->links,
                    'picture'           => $post->picture,
                    'tags'              => $post->tags,

                    'hash'              => $post->hash,

                    'origin'            => $post->origin,
                    'node'              => $post->node,
                    'nodeid'            => $post->nodeid
                )
            );

            $this->run('Postn');
        }
    }

    function delete($nodeid) {
        $this->_sql = '
            delete from postn
            where nodeid = :nodeid';

        $this->prepare(
            'Postn',
            array(
                'nodeid' => $nodeid
            )
        );

        return $this->run('Postn');
    }

    function deleteNode($origin, $node) {
        $this->_sql = '
            delete from postn
            where origin = :origin
                and node = :node';

        $this->prepare(
            'Postn',
            array(
                'origin' => $origin,
                'node' => $node
            )
        );

        return $this->run('Postn');
    }

    function getNode($from, $node, $limitf = false, $limitr = false) {
        $this->_sql = '
            select *, postn.aid, privacy.value as privacy from postn
            left outer join contact on postn.aid = contact.jid
            left outer join privacy on postn.nodeid = privacy.pkey
            where ((postn.origin, node) in (select server, node from subscription where jid = :aid))
                and postn.origin = :origin
                and postn.node = :node
                and postn.node != \'urn:xmpp:microblog:0\'
            order by postn.published desc';

        if($limitr)
            $this->_sql = $this->_sql.' limit '.$limitr.' offset '.$limitf;

        $this->prepare(
            'Postn',
            array(
                'aid' => $this->_user, // TODO: Little hack to bypass the check, need to fix it in Modl
                'origin' => $from,
                'node' => $node
            )
        );

        return $this->run('ContactPostn');
    }

    function getNodeUnfiltered($from, $node, $limitf = false, $limitr = false) {
        $this->_sql = '
            select *, postn.aid, privacy.value as privacy from postn
            left outer join contact on postn.aid = contact.jid
            left outer join privacy on postn.nodeid = privacy.pkey
            where postn.origin = :origin
                and postn.node = :node
            order by postn.published desc';

        if($limitr !== false)
            $this->_sql = $this->_sql.' limit '.(int)$limitr.' offset '.(int)$limitf;

        $this->prepare(
            'Postn',
            array(
                'origin' => $from,
                'node' => $node
            )
        );

        return $this->run('ContactPostn');
    }

    function getGallery($from, $limitf = false, $limitr = false) {
        $this->_sql = '
            select *, postn.aid, privacy.value as privacy from postn
            left outer join contact on postn.aid = contact.jid
            left outer join privacy on postn.nodeid = privacy.pkey
            where postn.aid = :aid
                and postn.picture = 1
            order by postn.published desc';

        if($limitr !== false)
            $this->_sql = $this->_sql.' limit '.(int)$limitr.' offset '.(int)$limitf;

        $this->prepare(
            'Postn',
            array(
                'aid' => $from // Another hack
            )
        );

        return $this->run('ContactPostn');
    }

    function getItem($id) {
        $this->_sql = '
            select *, postn.aid, privacy.value as privacy from postn
            left outer join contact on postn.aid = contact.jid
            left outer join privacy on postn.nodeid = privacy.pkey
            where postn.nodeid = :nodeid';

        $this->prepare(
            'Postn',
            array(
                'nodeid' => $id
            )
        );

        return $this->run('ContactPostn', 'item');
    }

    function getAllPosts($jid = false, $limitf = false, $limitr = false) {
        $this->_sql = '
            select *, postn.aid, privacy.value as privacy from postn
            left outer join contact on postn.aid = contact.jid
            left outer join privacy on postn.nodeid = privacy.pkey
            where (
                (postn.origin in (select jid from rosterlink where session = :origin and rostersubscription in (\'both\', \'to\')) and node = \'urn:xmpp:microblog:0\')
                or (postn.origin = :origin and node = \'urn:xmpp:microblog:0\')
                or ((postn.origin, node) in (select server, node from subscription where jid = :origin))
                )
                and postn.node not like \'urn:xmpp:microblog:0:comments/%\'
                and postn.node not like \'urn:xmpp:inbox\'
            order by postn.published desc
            ';

        if($limitr)
            $this->_sql = $this->_sql.' limit '.$limitr.' offset '.$limitf;

        if($jid == false)
            $jid = $this->_user;

        $this->prepare(
            'Postn',
            array(
                'origin' => $jid
            )
        );

        return $this->run('ContactPostn');
    }

    function getFeed($limitf = false, $limitr = false) {
        $this->_sql = '
            select *, postn.aid, privacy.value as privacy from postn
            left outer join contact on postn.aid = contact.jid
            left outer join privacy on postn.nodeid = privacy.pkey
            where ((postn.origin in (select jid from rosterlink where session = :origin and rostersubscription in (\'both\', \'to\')) and node = \'urn:xmpp:microblog:0\')
                or (postn.origin = :origin and node = \'urn:xmpp:microblog:0\'))
                and postn.node not like \'urn:xmpp:microblog:0:comments/%\'
                and postn.node not like \'urn:xmpp:inbox\'
            order by postn.published desc
            ';

        if($limitr)
            $this->_sql = $this->_sql.' limit '.$limitr.' offset '.$limitf;

        $this->prepare(
            'Postn',
            array(
                'origin' => $this->_user
            )
        );

        return $this->run('ContactPostn');
    }

    function getNews($limitf = false, $limitr = false) {
        $this->_sql = '
            select *, postn.aid, privacy.value as privacy from postn
            left outer join contact on postn.aid = contact.jid
            left outer join privacy on postn.nodeid = privacy.pkey
            where ((postn.origin, node) in (select server, node from subscription where jid = :origin))
            order by postn.published desc
            ';

        if($limitr)
            $this->_sql = $this->_sql.' limit '.$limitr.' offset '.$limitf;

        $this->prepare(
            'Postn',
            array(
                'origin' => $this->_user
            )
        );

        return $this->run('ContactPostn');
    }


    function getMe($limitf = false, $limitr = false) {
        $this->_sql = '
            select *, postn.aid, privacy.value as privacy from postn
            left outer join contact on postn.aid = contact.jid
            left outer join privacy on postn.nodeid = privacy.pkey
            where postn.origin = :origin and postn.node = \'urn:xmpp:microblog:0\'
            order by postn.published desc
            ';

        if($limitr)
            $this->_sql = $this->_sql.' limit '.$limitr.' offset '.$limitf;

        $this->prepare(
            'Postn',
            array(
                'origin' => $this->_user
            )
        );

        return $this->run('ContactPostn');
    }
    function getPublic($origin, $node, $limitf = false, $limitr = false) {
        $this->_sql = '
            select *, postn.aid, privacy.value as privacy from postn
            left outer join contact on postn.aid = contact.jid
            left outer join privacy on postn.nodeid = privacy.pkey
            where postn.origin = :origin
                and postn.node = :node
                and privacy.value = 1
            order by postn.published desc';

        if($limitr !== false)
            $this->_sql = $this->_sql.' limit '.(int)$limitr.' offset '.(int)$limitf;

        $this->prepare(
            'Postn',
            array(
                'origin' => $origin,
                'node' => $node
            )
        );

        return $this->run('ContactPostn');
    }

    function getPublicItem($origin, $node, $nodeid, $limitf = false, $limitr = false) {
        $this->_sql = '
            select *, postn.aid, privacy.value as privacy from postn
            left outer join contact on postn.aid = contact.jid
            left outer join privacy on postn.nodeid = privacy.pkey
            where postn.origin = :origin
                and postn.node = :node
                and privacy.value = 1
                and postn.nodeid = :nodeid
            order by postn.published desc';

        if($limitr)
            $this->_sql = $this->_sql.' limit '.$limitr.' offset '.$limitf;

        $this->prepare(
            'Postn',
            array(
                'origin' => $origin,
                'node' => $node,
                'nodeid' => $nodeid,
            )
        );

        return $this->run('ContactPostn');
    }

    // TODO: fixme
    function getComments($posts) {
        $commentsid = '';
        if(is_array($posts)) {
            $i = 0;
            foreach($posts as $post) {
                if($i == 0)
                    $commentsid = "'urn:xmpp:microblog:0:comments/".$post->nodeid."'";
                else
                    $commentsid .= ",'urn:xmpp:microblog:0:comments/".$post->nodeid."'";
                $i++;
            }
        } else {
            $commentsid = "'urn:xmpp:microblog:0:comments/".$posts->nodeid."'";
        }

        // We request all the comments relative to our messages
        $this->_sql = '
            select *, postn.aid as jid from postn
            left outer join contact on postn.aid = contact.jid
            where postn.node in ('.$commentsid.')
            order by postn.published';

        $this->prepare(
            'Postn',
            array(
            )
        );

        return $this->run('ContactPostn');
    }

    function clearPost() {
        $this->_sql = '
            delete from postn
            where session = :session';

        $this->prepare(
            'Postn',
            array(
                'session' => $this->_user
            )
        );

        return $this->run('Postn');
    }

    // TODO: fixme
    function getStatistics() {
        $this->_sql = '
            select count(*) as count, extract(month from published) as month, extract(year from published) as year
            from postn
            where session = :session
            group by month, year order by year desc, month desc';

        $this->prepare(
            'Postn',
            array(
                'session' => $this->_user
            )
        );

        return $this->run(null, 'array');
    }

    function getCountSince($date) {
        $this->_sql = '
            select count(*) from postn
            where (
                (postn.origin in (select jid from rosterlink where session = :origin and rostersubscription in (\'both\', \'to\')) and node = \'urn:xmpp:microblog:0\')
                or (postn.origin = :origin and node = \'urn:xmpp:microblog:0\')
                or ((postn.origin, node) in (select server, node from subscription where jid = :origin))
                )
                and postn.node not like \'urn:xmpp:microblog:0:comments/%\'
                and postn.node not like \'urn:xmpp:inbox\'
                and published > :published
                ';

        $this->prepare(
            'Postn',
            array(
                'origin' => $this->_user,
                'published' => $date
            )
        );

        $arr = $this->run(null, 'array');
        if(is_array($arr) && isset($arr[0])) {
            $arr = array_values($arr[0]);
            return (int)$arr[0];
        }
    }

    function getLastDate() {
        $this->_sql = '
            select published from postn
            where (
                (postn.origin in (select jid from rosterlink where session = :origin and rostersubscription in (\'both\', \'to\')) and node = \'urn:xmpp:microblog:0\')
                or (postn.origin = :origin and node = \'urn:xmpp:microblog:0\')
                or ((postn.origin, node) in (select server, node from subscription where jid = :origin))
                )
                and postn.node not like \'urn:xmpp:microblog:0:comments/%\'
                and postn.node not like \'urn:xmpp:inbox\'
            order by postn.published desc
            limit 1 offset 0';

        $this->prepare(
            'Postn',
            array(
                'origin' => $this->_user
            )
        );

        $arr = $this->run(null, 'array');
        if(is_array($arr) && isset($arr[0]))
            return $arr[0]['published'];
    }

    function getLastPublished($limitf = false, $limitr = false)
    {
        $this->_sql = '
            select * from postn
            where
                node != \'urn:xmpp:microblog:0\'
                and postn.node not like \'urn:xmpp:microblog:0:comments/%\'
                and postn.node not like \'urn:xmpp:inbox\'
                and postn.origin not like \'nsfw%\'
                and ((postn.origin, node) not in (select server, node from subscription where jid = :origin))
            order by published desc
            ';

        if($limitr)
            $this->_sql = $this->_sql.' limit '.$limitr.' offset '.$limitf;

        $this->prepare(
            'Postn',
            array(
                'origin' => $this->_user
            )
        );

        return $this->run('Postn');
    }

    function exist($id) {
        $this->_sql = '
            select count(*) from postn
            where postn.nodeid = :nodeid
            ';

        $this->prepare(
            'Postn',
            array(
                'nodeid'    => $id
            )
        );

        $arr = $this->run(null, 'array');
        if(is_array($arr) && isset($arr[0])) {
            $arr = array_values($arr[0]);
            return (bool)$arr[0];
        }
    }
}
