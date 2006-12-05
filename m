From: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
Subject: Re: [Bug 7026] CD/DVD burning with USB writer doesn't work
Date: Wed, 06 Dec 2006 00:03:11 +0100
Message-ID: <4575faaf.mLqmSNVeb+AwZXGB%Joerg.Schilling@fokus.fraunhofer.de>
References: <Pine.LNX.4.44L0.0612051546250.6667-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.fokus.fraunhofer.de ([193.174.154.14]:47007 "EHLO
	mailhub.fokus.fraunhofer.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965914AbWLEXET (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Dec 2006 18:04:19 -0500
In-Reply-To: <Pine.LNX.4.44L0.0612051546250.6667-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stern@rowland.harvard.edu, schilling@fokus.fraunhofer.de
Cc: linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com, dgilbert@interlog.com

Alan Stern <stern@rowland.harvard.edu> wrote:

> I decided to do this by email instead of bugzilla so that it would be=
=20
> visible to everyone on the linux-scsi mailing list.
>
> Re: http://bugzilla.kernel.org/show_bug.cgi?id=3D7026

I just put out preliminary support for this ioctl.

Please check:

ftp://ftp.berlios.de/pub/cdrecord/alpha/cdrtools-2.01.01a23-pre.tar.bz2

and try out whether the problems are now gone.

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
