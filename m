From: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
Subject: Re: [Bug 7026] CD/DVD burning with USB writer doesn't work
Date: Tue, 05 Dec 2006 23:35:39 +0100
Message-ID: <4575f43b.Fqqu0sjVVj/8Tub8%Joerg.Schilling@fokus.fraunhofer.de>
References: <Pine.LNX.4.44L0.0612051546250.6667-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.fokus.fraunhofer.de ([193.174.154.14]:44941 "EHLO
	mailhub.fokus.fraunhofer.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936812AbWLEWgr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Dec 2006 17:36:47 -0500
In-Reply-To: <Pine.LNX.4.44L0.0612051546250.6667-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stern@rowland.harvard.edu, schilling@fokus.fraunhofer.de
Cc: linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com, dgilbert@interlog.com

Alan Stern <stern@rowland.harvard.edu> wrote:

> I decided to do this by email instead of bugzilla so that it would be=
=20
> visible to everyone on the linux-scsi mailing list.

Thank you, this is a more convenient way of having a discussion.

> Re: http://bugzilla.kernel.org/show_bug.cgi?id=3D7026
>
> To recap: Joerg Schilling needs to be able to retrieve the max_sector=
s=20
> value for a SCSI device's request queue.  Doing it via sysfs is rathe=
r=20
> clumsy, especially when only a file descriptor is available and not t=
he=20
> device name.  He has asked for an ioctl interface to provide the=20
> information.
>
> Is the patch below acceptable?

If the number in "sectors" is not a value in sectors but a value in 512=
 byte=20
units, it looks OK.

Is this value correct for all "host adaptors"?

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
