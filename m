From: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
Subject: Re: [Bug 7026] CD/DVD burning with USB writer doesn't work
Date: Wed, 06 Dec 2006 18:42:39 +0100
Message-ID: <4577010f.+D5E7od3HTHDmabn%Joerg.Schilling@fokus.fraunhofer.de>
References: <Pine.LNX.4.44L0.0612051546250.6667-100000@iolanthe.rowland.org>
 <1165355432.2785.20.camel@mulgrave.il.steeleye.com>
 <4575f6c6.RvoLkLFpmxoSf6pC%Joerg.Schilling@fokus.fraunhofer.de>
 <1165359506.2785.37.camel@mulgrave.il.steeleye.com>
 <4575fd53.ja06l7+Yx9/C/OYS%Joerg.Schilling@fokus.fraunhofer.de>
 <1165421548.2810.17.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.fokus.fraunhofer.de ([193.174.154.14]:38726 "EHLO
	mailhub.fokus.fraunhofer.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936957AbWLFRqI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Dec 2006 12:46:08 -0500
In-Reply-To: <1165421548.2810.17.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: stern@rowland.harvard.edu, schilling@fokus.fraunhofer.de, linux-scsi@vger.kernel.org, dgilbert@interlog.com

James Bottomley <James.Bottomley@SteelEye.com> wrote:

> On Wed, 2006-12-06 at 00:14 +0100, Joerg Schilling wrote:
> > Well, accept the patch if it works.
>
> It's not about work/not work: it's about correctness.
>
> >  And in case that you don't like it, make sure that the _parameter_=
 is
> > moved to where it belongs: to the low level transport layer.
>
> It's not a low level property; it's a property of the generic queue,
> namely the maximum request size.  It exists for devices independent o=
f
> SCSI (i.e. you'll want it for IDE and weirder transport attachment CD=
s
> as well).

It is a DMA property, so it is a low level property. The fact that the=20
parameter is held somewhere else does not change this.

BTW: I received a positive test result from a user, so the patch really=
=20
fixes the problems and we should use it.
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
