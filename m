From: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
Subject: Re: [Bug 7026] CD/DVD burning with USB writer doesn't work
Date: Wed, 06 Dec 2006 00:08:46 +0100
Message-ID: <4575fbfe.pc5NALkDYijOb4Eu%Joerg.Schilling@fokus.fraunhofer.de>
References: <Pine.LNX.4.44L0.0612051546250.6667-100000@iolanthe.rowland.org>
 <4575EAE8.7040303@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.fokus.fraunhofer.de ([193.174.154.14]:47524 "EHLO
	mailhub.fokus.fraunhofer.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966995AbWLEXJt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Dec 2006 18:09:49 -0500
In-Reply-To: <4575EAE8.7040303@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stern@rowland.harvard.edu, dgilbert@interlog.com
Cc: schilling@fokus.fraunhofer.de, linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com

Douglas Gilbert <dgilbert@interlog.com> wrote:

> BTW Joerg: SG_SET_RESERVED_SIZE simply makes it extremely
> unlikely that the sg driver will not be able to fetch
> enough memory from the kernel to move data associated with
> a SCSI command. The block layer SG_IO just fudges that.
> While a major concern in lk 2.0, memory starvation is typically
> not a major concern in lk 2.6 assuming modern hardware.
> The sg driver's reserved buffer has other uses as
> FUJITA Tomonori pointed out yesterday on the linux-scsi list.

If it is documented, no problem. The information I had said that=20
SG_SET_RESERVED_SIZE would be limited in case that the HW does not allo=
w=20
bigger sizes.

Let us try out whether the proposed interface works as expected.

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
