From: Fabien Salvi <fabien@cri74.org>
Subject: Re: hot scsi disk resize
Date: Wed, 05 Mar 2003 11:18:09 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E65CEE1.9020307@cri74.org>
References: <m3bs0s9xij.fsf@lexa.home.net> <3E64727C.9040204@cri74.org> <m31y1n8o3p.fsf@lexa.home.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: alexey@technomagesinc.com
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>, Jens Axboe <axboe@suse.de>, Dennis Gerasimov <denis@technomagesinc.com>



alexey@technomagesinc.com a =E9crit:
>>>>>>Fabien Salvi (FS) writes:
>>>>>
>=20
>  FS> Well, I also think it's a very important and needed feature for
>  FS> HA systems.  I'm very interested in such things...
>=20
>  FS> But, I thought resize_reiserfs only resize *unmounted* filesyste=
m
>  FS> : http://www.reiserfs.org/resize_reiserfs.html
>=20
> citate from this URL: "The resize_reiserfs program allows to grow a
> reiserfs on-line if there is a free space on block device."

Yes, you're right !
I haven't seen this...
It's a bit strange, it contradicts what is said on the first line :)


>  FS> Will it work under IO load ?
>=20
> I tested it several times under different load (read-only, write-only=
,
> read-write, single-thread and multi-thread tests). I think reiserfs
> team may give comments.


>  FS> Reiserfs has a way to do it dynamically while using it, with
>  FS> mount option : http://www.reiserfs.org/mount-options.html
>=20
>  FS> I've tested this without a lot of success (I encounter a lot of
>  FS> problems).
>=20
> what kind of problem have you seen? what versions of kernel/reiserfs/=
tools?

Well, I made some tests one year ago, I will try this again, as you say=
=20
it seems to work well, it's interested...
I will let you know my new results.

>  FS> I'm afraid that even if scsi subsystem support the resize option=
,
>  FS> FileSystems won't support it correctly...  Maybe with LVM ?
>=20
>  FS> Did someone test it ?
>=20
>>From filesystem point of view, LVM and resizable SCSI HDD are the sam=
e
> think - just block device which may grow.
>=20
> I think this patch is just one more step in the right direction.

Yes, surely !

--=20
=46abien SALVI      Centre de Ressources Informatiques
                   Archamps, France -- http://www.cri74.org
                   PingOO GNU/linux distribution : http://www.pingoo.or=
g

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
