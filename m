From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [PATCH] get the kernel to warn about deprecated SCSI ioctls
Date: 19 Aug 2004 11:06:34 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1092935193.3373.5.camel@patlinux.iomegacorp.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:32152 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S266813AbUHSRHx
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Aug 2004 13:07:53 -0400
Received: from royntex01.iomegacorp.com (franklin [10.1.1.83])
	by email.iomega.com (Postfix) with ESMTP id ACC4522A3
	for <linux-scsi@vger.kernel.org>; Thu, 19 Aug 2004 11:07:52 -0600 (MDT)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Yes, please, which SCSI pass thru ioctl should I use in Linux.

> SCSI_IOCTL_SEND_COMMAND ...
> please convert ... to SG_IO

Ouch, I am instead choosing the mostly undocumented ioctl
CDROM_SEND_PACKET, opened O_NONBLOCK, because I can't see how else to
reach 2.4 Linux /dev/hd$v thru cdrom ide-cd.

> SCSI_IOCTL_SEND_COMMAND ... deprecated ...

Me the newbie, I missed and I still do not see how I should know this
SCSI pass thru ioctl is deprecated, unless we add the printk you
suggest.

Pat LaVarre
http://marc.theaimsgroup.com/?l=linux-scsi&m=109278095826988
http://linux-pel.blog-city.com/read/756175.htm
http://linux-pel.blog-city.com/read/771746.htm

P.S. I'm resorting to SCSI pass thru for such purposes as toggling the
invisible MMC PWP write protect switch found in DVD-RAM discs, Iomega
REV discs, etc.


