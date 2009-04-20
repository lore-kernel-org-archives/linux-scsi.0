From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 1/2] ide: Stop disks on reboot for laptop which cuts power
Date: Mon, 20 Apr 2009 16:51:57 +0900
Message-ID: <49EC299D.5020102@gmail.com>
References: <20090418124415.1dc82273@neptune.home> <20090418124558.0426f74c@neptune.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.185]:57991 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbZDTHwG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Apr 2009 03:52:06 -0400
In-Reply-To: <20090418124558.0426f74c@neptune.home>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?QnJ1bm8gUHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
Cc: Linux IDE <linux-ide@vger.kernel.org>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Jeff Garzik <jeff@garzik.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Linux SCSI <linux-scsi@vger.kernel.org>

Bruno Pr=C3=A9mont wrote:
> My laptop (Acer Travelmate 660) always cuts the power when rebooting
> which causes the disk to emergency-park it's head.
>=20
> Add a dmi check to stop disk as for shutdown on this laptop.

Hmm... yeah, I also noticed this behavior on several machines I have
here.  Most were beta BIOSen.

Maybe it's worth to shutdown drives on reboot on all machines?

Thanks.

--=20
tejun
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
