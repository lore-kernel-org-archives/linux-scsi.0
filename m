From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: SG_IO open flags are which
Date: Thu, 20 May 2004 09:16:44 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B40AD650-AA70-11D8-88C0-003065635034@ieee.org>
Mime-Version: 1.0 (Apple Message framework v613)
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:16565 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S265118AbUETPQs
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 May 2004 11:16:48 -0400
Received: from royntex01.iomegacorp.com (edison [10.1.1.82])
	by email.iomega.com (Postfix) with ESMTP id 3403F1C38
	for <linux-scsi@vger.kernel.org>; Thu, 20 May 2004 09:16:48 -0600 (MDT)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Recently I saw yet another newbie trip over the ioctl 
CDROM_SEND_PACKET/ SG_IO dialectic that:

1) open /dev/scd$n /dev/hd$v maybe inflict less undesirable side 
effects if we open O_NONBLOCK

2) open /dev/sg$n maybe inflict less undesirable side effects if we 
open O_RDWR | O_NONBLOCK

I'm replying again in this thread only because I don't remember before 
now seeing that dialectic nutshelled so pointedly.

Looks like ioctl SCSI pass thru apps should string-compare the device 
name to decide default open flags.  Over the years, that's potentially 
insanely fragile, but I guess it will work out ok for Linux 2.6/ 2.4.

Pat LaVarre

