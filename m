From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Limit max concurrent sessions
Date: Wed, 23 Sep 2015 17:18:48 +0200
Message-ID: <20150923171848.3dd31edf@harpe.intellique.com>
References: <554A34F3.5080507@assyoma.it>
	<5602B511.8020502@assyoma.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:19745 "EHLO mail1.g1.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755343AbbIWP0q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Sep 2015 11:26:46 -0400
In-Reply-To: <5602B511.8020502@assyoma.it>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gionatan Danti <g.danti@assyoma.it>
Cc: linux-scsi@vger.kernel.org

Le Wed, 23 Sep 2015 16:20:01 +0200
Gionatan Danti <g.danti@assyoma.it> =C3=A9crivait:

> Hi all,
> anyone with some ideas / infos ?
>=20
> Thanks.
>=20
> On 06/05/15 17:36, Gionatan Danti wrote:
> > Hi all,
> > I would like to understand if, and how to, limit the maximum number
> > of simultaneous connections to a specific LUN, both with the old
> > iSCSI stack (tgtadmin and friends) and the new one (targetcli and
> > the likes).
> >
> > I am exporting a LUN with a general purpose filesystem (non cluster
> > aware) and I would be 100% sure that only a single machine at a
> > time can mount it.
> >
> > At the moment, I protected the iSCSI LUN with both an IP-based
> > access list and a username/password combo, but hard limiting the
> > maximum number of connections opened against it to 1 (one) would be
> > a nice thing...
> >
> > As I have mixed RHEL 6 and 7 environment, I am interested in how to
> > do that on both the old and new iSCSI stack.
> >

Use XFS. XFS won't let you mount it several time on different machines
without various "force" options.
Alternatively, use a cluster-aware FS like ocfs2. Ocfs2 is quite easy
to set up.

--=20
-----------------------------------------------------------------------=
-
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
-----------------------------------------------------------------------=
-
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
