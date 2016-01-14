From: Laurence Oberman <loberman@redhat.com>
Subject: Re: st driver doesn't seem to grok LTO partitioning
Date: Thu, 14 Jan 2016 15:12:53 -0500 (EST)
Message-ID: <1371374871.6203837.1452802373256.JavaMail.zimbra@redhat.com>
References: <20151218170644.24167419@harpe.intellique.com> <alpine.LSU.2.11.1601041219340.1615@xnv.znxvfnen.cevingr> <20160104124626.3112e8c0@harpe.intellique.com> <CAAzz28iCoG-rjnL7EsjHXA7UtRJSCEXuwL3+27ZBo7fckcBAfg@mail.gmail.com> <688812570.3359420.1452030904683.JavaMail.zimbra@redhat.com> <20160106161049.34f29973@harpe.intellique.com> <1993563395.3556606.1452093814452.JavaMail.zimbra@redhat.com> <20160106170720.61db9e86@harpe.intellique.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx5-phx2.redhat.com ([209.132.183.37]:36533 "EHLO
	mx5-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168AbcANUNG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jan 2016 15:13:06 -0500
In-Reply-To: <20160106170720.61db9e86@harpe.intellique.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Laurence Oberman <oberman.l@gmail.com>, Kai Makisara <Kai.Makisara@kolumbus.fi>, linux-scsi@vger.kernel.org

All attempts to get my drive and changer firmware updated have failed.
So I wont be able to add another "tested by" to this thread unless I ca=
n find another drive.

Even using Doug's method fails to actually update. Seems to suck up the=
 image and then do nothing.
Lands up in getting hung and needs a full power reset.

The image I have is the correct image.

I dont want to try to many convoluted methods because I dont want to br=
ick the changer.

Its the only one I have for doing all the st driver testing here at Red=
 Hat in the GSS team.

Thanks

Laurence Oberman
Principal Software Maintenance Engineer
Red Hat Global Support Services

----- Original Message -----
=46rom: "Emmanuel Florac" <eflorac@intellique.com>
To: "Laurence Oberman" <loberman@redhat.com>
Cc: "Laurence Oberman" <oberman.l@gmail.com>, "Kai Makisara" <Kai.Makis=
ara@kolumbus.fi>, linux-scsi@vger.kernel.org
Sent: Wednesday, January 6, 2016 11:07:20 AM
Subject: Re: st driver doesn't seem to grok LTO partitioning

Le Wed, 6 Jan 2016 10:23:34 -0500 (EST)
Laurence Oberman <loberman@redhat.com> =C3=A9crivait:

> MaxPartitions: 0
>=20
> Drive is working fine,
>=20
> # mt -f /dev/st0 status
> SCSI 2 tape drive:
> File number=3D0, block number=3D0, partition=3D0.
> Tape block size 512 bytes. Density code 0x58 (no translation).
> Soft error count since last status=3D0
> General status bits on (41010000):
>  BOT ONLINE IM_REP_EN
>=20
> This is what I get when I try and partition and I believe this may be
> a firmware issue for me.

Yes probably, it reports "MaxPartitions 0", should be 1 for an LTO-5
drive. Weird.=20

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
