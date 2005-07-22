From: Steve McIntyre <steve@einval.com>
Subject: Re: Is it possible to support a sector size 8192
Date: Fri, 22 Jul 2005 19:18:39 +0100
Message-ID: <E1Dw26Z-0005m7-JQ@sledge.mossbank.org.uk>
References: <200507222126.36623.jhml@gmx.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lump.einval.com ([217.147.81.17]:47368 "EHLO mail.einval.com")
	by vger.kernel.org with ESMTP id S261369AbVGVSSo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jul 2005 14:18:44 -0400
In-Reply-To: <200507222126.36623.jhml@gmx.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jhml@gmx.net
Cc: linux-scsi@vger.kernel.org, smcintyre@software.plasmon.com

Johann wrote:
>Hi everybody,
>
>i'm trying to access UDO/WORM mediums (which have a sector size of
>8192) via a Plasmon UDO drive, but all I get is "unsupported sector
>size 8192" when I try to access it via /dev/sdX. drivers/scsi/sd.c
>suggests that the maximum sector size currently supported by Linux is
>4096.
>
>How difficult will it get to support 8192? Maybe we can pay somebody
>for doing it? (Kernel 2.4.21, RHEL 3.1).

We (at Plasmon) investigated adding support in the kernel, but gave up
quickly as it looked like it would need a huge amount of work in
multiple areas. Instead, we've started shipping a userland filesystem
driver for UDO based on FUSE. If you'd be interested in that, let me
know...

-- 
Steve McIntyre, Cambridge, UK.                                steve@einval.com
"Because heaters aren't purple!" -- Catherine Pitt
