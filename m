From: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
Subject: Re: [Bug 7026] CD/DVD burning with USB writer doesn't work
Date: Wed, 06 Dec 2006 19:48:42 +0100
Message-ID: <4577108a.YA4uihJ9DhrgxnNY%Joerg.Schilling@fokus.fraunhofer.de>
References: <Pine.LNX.4.44L0.0612061105500.3298-100000@iolanthe.rowland.org>
 <1165423635.2810.33.camel@mulgrave.il.steeleye.com>
 <4577029f./DIiz5nuoOKd82Zo%Joerg.Schilling@fokus.fraunhofer.de>
 <1165427946.2810.46.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.fokus.fraunhofer.de ([193.174.154.14]:46856 "EHLO
	mailhub.fokus.fraunhofer.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937098AbWLFSt5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Dec 2006 13:49:57 -0500
In-Reply-To: <1165427946.2810.46.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: stern@rowland.harvard.edu, schilling@fokus.fraunhofer.de, linux-scsi@vger.kernel.org, dgilbert@interlog.com

James Bottomley <James.Bottomley@SteelEye.com> wrote:

> On Wed, 2006-12-06 at 18:49 +0100, Joerg Schilling wrote:
> > Please keep in mind: all CD/DVD burners are SCSI devices.
>
> This is probably semantics, but nowadays, SCSI means SPI (or parallel
> SCSI).  I think you're trying to say that they're all devices that ob=
ey
> the MMC standard?  Which is true, but not really relevant.
>
> > You cannot write or even retrieve special information without SCSI.

I am not sure if you did ever have a look at t10.org.

SCSI is a widely used protocol that is supported over many different tr=
ansports.
SPI is as dead as PATA and note that SAS controllers will transparently=
 handle
even SATA devices.

SCSI supports many more devices than MMC and SCSI runs on many differen=
t=20
transports.=20

The SCSI protocol layer has been separated from the transport layer in =
the=20
early 1990s. Please do not try to make asumptions based on outdated inf=
ormation.


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
