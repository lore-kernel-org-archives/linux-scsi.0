From: Christian Iversen <chrivers@iversen-net.dk>
Subject: Re: Is it possible to support a sector size 8192
Date: Fri, 22 Jul 2005 21:21:16 +0200
Message-ID: <200507222121.16685.chrivers@iversen-net.dk>
References: <E1Dw26Z-0005m7-JQ@sledge.mossbank.org.uk>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from port741.ds1-noe.adsl.cybercity.dk ([212.242.204.118]:59708 "EHLO
	boreas.iversen-net.dk") by vger.kernel.org with ESMTP
	id S262143AbVGVTVX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jul 2005 15:21:23 -0400
Received: from localhost (localhost [127.0.0.1])
	by boreas.iversen-net.dk (Postfix) with ESMTP id 24ED42B9504
	for <linux-scsi@vger.kernel.org>; Fri, 22 Jul 2005 21:21:22 +0200 (CEST)
Received: from boreas.iversen-net.dk ([127.0.0.1])
	by localhost (boreas.iversen-net.dk [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 14871-01 for <linux-scsi@vger.kernel.org>;
	Fri, 22 Jul 2005 21:21:17 +0200 (CEST)
Received: from zephyr.iversen-net.dk (zephyr.iversen-net.dk [10.0.0.2])
	by boreas.iversen-net.dk (Postfix) with ESMTP
	for <linux-scsi@vger.kernel.org>; Fri, 22 Jul 2005 21:21:17 +0200 (CEST)
In-Reply-To: <E1Dw26Z-0005m7-JQ@sledge.mossbank.org.uk>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

On Friday 22 July 2005 20:18, Steve McIntyre wrote:
> Johann wrote:
> >Hi everybody,
> >
> >i'm trying to access UDO/WORM mediums (which have a sector size of
> >8192) via a Plasmon UDO drive, but all I get is "unsupported sector
> >size 8192" when I try to access it via /dev/sdX. drivers/scsi/sd.c
> >suggests that the maximum sector size currently supported by Linux is
> >4096.
> >
> >How difficult will it get to support 8192? Maybe we can pay somebody
> >for doing it? (Kernel 2.4.21, RHEL 3.1).
>
> We (at Plasmon) investigated adding support in the kernel, but gave up
> quickly as it looked like it would need a huge amount of work in
> multiple areas. Instead, we've started shipping a userland filesystem
> driver for UDO based on FUSE. If you'd be interested in that, let me
> know...

Wouldn't it be possible to translate the sector size 2:1? For me, it doesn't 
seem that hard to do. But then again, I usually program other things than the 
kernel :)

-- 
Regards,
Christian Iversen
