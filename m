From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: cdparanoia not setting count and/or reply_len properly
Date: Sun, 08 Jul 2007 14:35:39 +0200
Message-ID: <4690DA1B.3010901@s5r6.in-berlin.de>
References: <20070708103928.GA20349@DervishD>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:37564 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbXGHMfn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Jul 2007 08:35:43 -0400
In-Reply-To: <20070708103928.GA20349@DervishD>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: DervishD <lkml@dervishd.net>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

DervishD wrote at lkml:
>     Hi all :)
>=20
>     I know, this has been treated on the list before (year 2005) but
> without any real solution I'm aware of.
>=20
>     I'm running kernel 2.6.20.14, and I have an ATAPI DVD writer that=
 I
> use with an IDE-to-USB adapter, so it appears as an SCSI drive to the
> kernel.
>=20
>     Anytime I rip anything with it, the log fills with the same messa=
ge:
> some numbers about a certain number of bytes and the old friend messa=
ge
> that I've put in the subject.
>=20
>     I assume that the warning makes sense, but the fact is that my lo=
g
> is full with the same message, the ripping is correct (so cdparanoia =
is
> working OK WRT ripping) and if weren't for the printk_ratelimit, the
> system will freeze.
>=20
>     I don't know if cdparanoia should be fixed, but certainly the
> warning could be issued only if CONFIG_SCSI_VERBOSE is set. This way =
you
> will have the message if something goes wrong and you want more info,
> but in cases where the warning is harmless your log will be clean...
>=20
>     Anyway, this message is not for make suggestions, but for asking =
for
> information: why is this warning happening? naugthy cdparanoia? naugh=
ty
> kernel? I'm a bit confused and I want to use my external DVD drive fo=
r
> ripping from time to time, to "exercise" it...
>=20
>     Thanks a lot in advance :)
>=20
>     Ra=FAl N=FA=F1ez de Arenas Coronado
>=20

This question is better asked at lsml.  (Therefore I'm quoting in full.=
)
--=20
Stefan Richter
-=3D=3D=3D=3D=3D-=3D-=3D=3D=3D -=3D=3D=3D -=3D---
http://arcgraph.de/sr/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
