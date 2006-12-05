From: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
Subject: Re: [Bug 7026] CD/DVD burning with USB writer doesn't work
Date: Tue, 05 Dec 2006 23:46:30 +0100
Message-ID: <4575f6c6.RvoLkLFpmxoSf6pC%Joerg.Schilling@fokus.fraunhofer.de>
References: <Pine.LNX.4.44L0.0612051546250.6667-100000@iolanthe.rowland.org>
 <1165355432.2785.20.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.fokus.fraunhofer.de ([193.174.154.14]:45856 "EHLO
	mailhub.fokus.fraunhofer.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936954AbWLEWrd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Dec 2006 17:47:33 -0500
In-Reply-To: <1165355432.2785.20.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stern@rowland.harvard.edu, James.Bottomley@steeleye.com
Cc: schilling@fokus.fraunhofer.de, linux-scsi@vger.kernel.org, dgilbert@interlog.com

James Bottomley <James.Bottomley@SteelEye.com> wrote:

> > Is the patch below acceptable?
>
> Really, no.  The parameter you're fishing for is a block parameter, n=
ot
> a SCSI parameter ... it should really be a block ioctl if we have to
> have an ioctl at all.

I am afraid, you seem to missunderstand things.

This parameter is not related to something you may call "block layer", =
it is=20
rather related to the low level SCSI transport. If the value is stored =
in a=20
higher layer, it is not stored in the layer where it belongs to.

If you like to take care of clean interfaces, make sure that this param=
eter is=20
moved to the right place in the code.

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
