From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Limit max concurrent sessions
Date: Fri, 2 Oct 2015 18:37:38 +0200
Message-ID: <20151002183738.5bcb22ad@harpe.intellique.com>
References: <554A34F3.5080507@assyoma.it>
	<5602B511.8020502@assyoma.it>
	<20150923171848.3dd31edf@harpe.intellique.com>
	<c07f7ee2ae76d94eea580a60e3dacaa3@assyoma.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:31769 "EHLO mail1.g1.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534AbbJBQhf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Oct 2015 12:37:35 -0400
In-Reply-To: <c07f7ee2ae76d94eea580a60e3dacaa3@assyoma.it>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gionatan Danti <g.danti@assyoma.it>
Cc: linux-scsi@vger.kernel.org

Le Sun, 27 Sep 2015 12:28:41 +0200
Gionatan Danti <g.danti@assyoma.it> =C3=A9crivait:

> Il 23-09-2015 17:18 Emmanuel Florac ha scritto:
> >=20
> > Use XFS. XFS won't let you mount it several time on different
> > machines without various "force" options.
> > Alternatively, use a cluster-aware FS like ocfs2. Ocfs2 is quite
> > easy to set up.
>=20
> Thank you for the suggestion.
> Unfortunately, due to specific requirements I must use EXT4.
>=20
> So, there is no methods to limit concurrent connections?
> Thanks.

Not that I know of using LIO. However, using ietd you can use the
MaxSession parameter to limit the number of concurrent sessions.=20

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
