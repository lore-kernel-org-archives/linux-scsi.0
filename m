From: google@familycook1.net
Subject: Re: Is it possible to spin down idle SATA disks that use scsi drivers
Date: Sun,  9 Jan 2005 14:23:56 -0500
Message-ID: <1105298636.41e184cc1fbeb@familycook1.net>
References: <1105168894.41df89fe3a9cf@familycook1.net> <41E05DB4.8040704@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ace.securenet-server.net ([63.247.93.10]:26580 "EHLO
	ace.securenet-server.net") by vger.kernel.org with ESMTP
	id S261718AbVAITYJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 9 Jan 2005 14:24:09 -0500
In-Reply-To: <41E05DB4.8040704@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

Dougg,

Thank you for your replay.  I will check out the information you provid=
ed to me.

donald

Quoting Douglas Gilbert <dougg@torque.net>:

> google@familycook1.net wrote:
> > Is it possible to spin down idle SATA disks that are using the scsi
> drivers?
>
> There are some patches around that implement the proposed
> SCSI ATA pass-through command from the SCSI-ATA Translation
> (SAT) draft in libata. Also ioctls are defined so hdparm
> can work on SATA disks connected via libata. These patches
> allowed me to use smartmontools on a SATA disk.
>
> > I have searched the archives with =93spindown=94 and =93scsi-idle=94=
 and have found
> > nothing current.
>
> The SAT draft defines the SCSI START STOP UNIT command which
> controls the spin up and down of SCSI disks. Hopefully
> libata implements this command so SCSI utilities (e.g.
> sg_start) can control spin up and down. Control via
> SCSI commands is important since the SAT layer may be
> in an intermediate device (e.g. a SAS expander/enclosure)
> rather than in the OS (e.g. libata).
>
> Doug Gilbert
>



-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
