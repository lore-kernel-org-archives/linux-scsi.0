From: "jack wang" <jack_wang@usish.com>
Subject: RE: ATA / mvsas issue.
Date: Thu, 1 Apr 2010 08:57:49 +0800
Message-ID: <7BF8FE1BFB7440B29ECD3D15FB0A4E8C@usish.com.cn>
References: <53271.87.210.74.220.1270040583.squirrel@ketsers.dhs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:53765 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758066Ab0DAA5x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Mar 2010 20:57:53 -0400
In-Reply-To: <53271.87.210.74.220.1270040583.squirrel@ketsers.dhs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Caspar Smit' <c.smit@truebit.nl>, linux-scsi@vger.kernel.org

Hi all,

Today I installed 16 fresh Western Digital WD5000BEVT (2,5") drives in =
one
of our test servers.

I created a software raid5 with a hotspare on these 16 disks.

I noticed that the detection of the disks during boottime was very very
slow.
Creating the md superblocks went very very slow.

After that all seemed fine (speed of the raid5 init was normal).

I noticed many of these messages in the syslog (also attached):

Mar 31 14:34:17 test ata_id[3752]: main: HDIO_GET_IDENTITY failed for
'/dev/.tmp-8-112'
Mar 31 14:34:17 test ata_id[3765]: main: HDIO_GET_IDENTITY failed for
'/dev/.tmp-8-128'

This seems to correspond to the slow detection of the disks.

Is this an ATA problem, or a problem in the mvsas driver?

I use the mvsas driver from 2.6.32 with the latest patch from Srinivas.

Kind regards,
Caspar Smit


[Jack] It's normal behavior of SATA disk, SATA disk need more time than=
 SAS=20
disk to spin up to response command.

Best Regards

***********************************************************************=
*
Jack  Wang   =CD=F5=BD=F0=C6=D6                 Software Engineer



--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
