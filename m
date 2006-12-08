From: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
Subject: Re: [Bug 7026] CD/DVD burning with USB writer doesn't work
Date: Fri, 08 Dec 2006 13:45:24 +0100
Message-ID: <45795e64.5YR0KEYlCvFrV8Ni%Joerg.Schilling@fokus.fraunhofer.de>
References: <Pine.LNX.4.44L0.0612071325050.3537-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.fokus.fraunhofer.de ([193.174.154.14]:46723 "EHLO
	mailhub.fokus.fraunhofer.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1425485AbWLHMtP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Dec 2006 07:49:15 -0500
In-Reply-To: <Pine.LNX.4.44L0.0612071325050.3537-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stern@rowland.harvard.edu
Cc: schilling@fokus.fraunhofer.de, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com, dougg@torque.net, dgilbert@interlog.com

Alan Stern <stern@rowland.harvard.edu> wrote:

> I will.  If everything goes well then BLKSECTGET will be made to work=
 with=20
> the SCSI-Generic interface as well as with the usual block device fil=
es,=20
> so you'll be able to use it with any file descriptor for a CD or DVD=20
> drive.

Coud you please inform me if this has been done?

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
