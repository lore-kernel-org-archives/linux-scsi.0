From: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
Subject: Re: [Bug 7026] CD/DVD burning with USB writer doesn't work
Date: Thu, 07 Dec 2006 11:34:19 +0100
Message-ID: <4577ee2b.YcNjPkzfKDfhAjUf%Joerg.Schilling@fokus.fraunhofer.de>
References: <Pine.LNX.4.44L0.0612061645280.5127-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.fokus.fraunhofer.de ([193.174.154.14]:43719 "EHLO
	mailhub.fokus.fraunhofer.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032003AbWLGKfw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Dec 2006 05:35:52 -0500
In-Reply-To: <Pine.LNX.4.44L0.0612061645280.5127-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stern@rowland.harvard.edu, michaelc@cs.wisc.edu
Cc: schilling@fokus.fraunhofer.de, linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com, dougg@torque.net, dgilbert@interlog.com

Alan Stern <stern@rowland.harvard.edu> wrote:

> On Wed, 6 Dec 2006, Mike Christie wrote:
>
> > Alternatively, if we do start not checking values like max sectors =
and
> > send requests down to the drivers, the block layer mapping function=
s can
> > be modified to not check certain values and LLDs/scsi-ml can return
> > these BLKERR values all the way up to sg/bsg/scsi_ioctl.c for value=
s
> > that they need to check.
>
> I bet in many cases the LLD depends on the higher layers to filter ou=
t=20
> transfers that are too large.  Duplicating all those tests in all the=
 LLDs=20
> seems like a waste.

Once you are done with the implementation details, could you tell me wh=
at you=20
decided to add for the final implementation?

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
