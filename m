From: "emmanuel\.fuste" <emmanuel.fuste@laposte.net>
Subject: Re: [PATCH 0/4] [Resend] update aic79xx sequencer
Date: Thu, 12 Jan 2006 14:53:11 +0100
Message-ID: <ISZFWN$934A4722B2BE467FD27840A059023B1E@laposte.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx.laposte.net ([81.255.54.11]:50202 "EHLO mx.laposte.net")
	by vger.kernel.org with ESMTP id S932220AbWALNxx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jan 2006 08:53:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare <hare@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "James.Bottomley" <James.Bottomley@SteelEye.com>, bunk <bunk@stusta.de>

I checked the latest adaptec souces and the aic7xxx part
seemed to be in sync with the kernel with the big difference
located in aic7xxx_osm.c.

I will try James Bottomley "aic7xxx timer handling bug" fix.

Emmanuel.

> emmanuel.fuste wrote:
> > Hello,
> >=20
> > Is there any similar updates available for aic7xxx ?
> >=20
> I could if James thinks it useful ...
>

Acc=E9dez au courrier =E9lectronique de La Poste : www.laposte.net ;=20
3615 LAPOSTENET (0,34 =80/mn) ; t=E9l : 08 92 68 13 50 (0,34=80/mn)



-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
