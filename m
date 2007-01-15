From: <Patrick_Boyd@Dell.com>
Subject: RE: no disk drive detected at boot time
Date: Mon, 15 Jan 2007 09:56:41 -0600
Message-ID: <FCD01C3AA0ADFB498F9BB1A6173DFC5D011C16E5@ausx3mpc120.aus.amer.dell.com>
References: <45A61B53.1040700@ckr-solutions.com> <45AB5B19.1070901@ckr-solutions.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:22975 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbXAOQGU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jan 2007 11:06:20 -0500
Content-class: urn:content-classes:message
In-Reply-To: <45AB5B19.1070901@ckr-solutions.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jmreymond@ckr-solutions.com, linux-scsi@vger.kernel.org

You might want to take a look at this.

http://groups.google.com/group/linux.debian.bugs.dist/browse_thread/thr=
ead/54a1ca21b839ebf1/4a0cd669217f3c7d?lnk=3Dst&rnum=3D1#4a0cd669217f3c7=
d

According to that email you need firmware 6.61 or lower to use the curr=
ent megaraid-mm and mbox drivers, however apparently this firmware does=
n't support disks greater than 128GB in size.=20

-----Original Message-----
=46rom: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.=
kernel.org] On Behalf Of Jean-Max Reymond
Sent: Monday, January 15, 2007 4:45 AM
To: linux-scsi@vger.kernel.org
Subject: Re: no disk drive detected at boot time

Jean-Max Reymond a =E9crit :
> hi,
> The computer is an DELL 1600SC with SATA RAID.
> At boot time, no disk are detected.
> I have tried with Ubuntu Edgy and Fedora Core 6 and I have the same=20
> troubles. Fedora Core 2 is running on the computer.
> it seems that Dell CERC ATA100/4ch is not supported by any driver.
> see
> http://www.mail-archive.com/debian-kernel@lists.debian.org/msg20989.h=
t
> ml
>
>
no answers ?
here is the report of cat /proc/scsi/scsi :

Host: scsi3 Channel: 00 Id: 00 Lun: 00
  Vendor: MegaRAID Model: LD 0 RAID5  714G Rev: 6.62
  Type:   Direct-Access                    ANSI SCSI revision: 02

does it exist a recent patch ?
thanks for your tips
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
