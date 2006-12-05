From: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
Subject: Re: [Bug 7026] CD/DVD burning with USB writer doesn't work
Date: Wed, 06 Dec 2006 00:14:27 +0100
Message-ID: <4575fd53.ja06l7+Yx9/C/OYS%Joerg.Schilling@fokus.fraunhofer.de>
References: <Pine.LNX.4.44L0.0612051546250.6667-100000@iolanthe.rowland.org>
 <1165355432.2785.20.camel@mulgrave.il.steeleye.com>
 <4575f6c6.RvoLkLFpmxoSf6pC%Joerg.Schilling@fokus.fraunhofer.de>
 <1165359506.2785.37.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.fokus.fraunhofer.de ([193.174.154.14]:48014 "EHLO
	mailhub.fokus.fraunhofer.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967454AbWLEXPf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Dec 2006 18:15:35 -0500
In-Reply-To: <1165359506.2785.37.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: stern@rowland.harvard.edu, schilling@fokus.fraunhofer.de, linux-scsi@vger.kernel.org, dgilbert@interlog.com

James Bottomley <James.Bottomley@SteelEye.com> wrote:

> On Tue, 2006-12-05 at 23:46 +0100, Joerg Schilling wrote:
> > I am afraid, you seem to missunderstand things.
> >=20
> > This parameter is not related to something you may call "block laye=
r", it is=20
> > rather related to the low level SCSI transport. If the value is sto=
red in a=20
> > higher layer, it is not stored in the layer where it belongs to.
> >=20
> > If you like to take care of clean interfaces, make sure that this p=
arameter is=20
> > moved to the right place in the code.
>
> The patch Alan posted is returning the max_sectors count from the blo=
ck
> layer, which is a block, not a SCSI parameter ... so what is it that =
you
> actually want?

Well, accept the patch if it works. And in case that you don't like it,=
 make=20
sure that the _parameter_ is moved to where it belongs: to the low leve=
l=20
transport layer.

J=F6rg

--=20
 EMail:joerg@schily.isdn.cs.tu-berlin.de (home) J=F6rg Schilling D-1335=
3 Berlin
       js@cs.tu-berlin.de                (uni) =20
       schilling@fokus.fraunhofer.de     (work) Blog: http://schily.blo=
gspot.com/
 URL:  http://cdrecord.berlios.de/old/private/ ftp://ftp.berlios.de/pub=
/schily
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
