From: "Miller, Mike (OS Dev)" <mike.miller@hp.com>
Subject: RE: [PATCH 1/1] cciss per disk queue for 2.6
Date: Fri, 1 Jul 2005 11:53:33 -0500
Message-ID: <D4CFB69C345C394284E4B78B876C1CF107DC0869@cceexc23.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ccerelbas04.cce.hp.com ([161.114.21.107]:40682 "EHLO
	ccerelbas04.cce.hp.com") by vger.kernel.org with ESMTP
	id S263389AbVGAQyS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jul 2005 12:54:18 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Jens Axboe wrote:
> Different thing, I'm talking about single volume starvation, 
> not volume-to-volume.
> 
> > elevator algoritm(s) may be causing writes to starve reads 
> on the same 
> > logical volume. We continue to investigate our other 
> performance issues.
> 
> I completely disagree. Even with an intelligent io scheduler, 
> starvation is seen on ciss that does not happen on other 
> queueing hardware such as 'normal' scsi controllers/drives. 
> So something else is going on, and the only 'fix' so far is 
> to limit the ciss queue depth heavily.

We will investigate this further and come up with a solution. Could be
the firmware, I suppose.

mikem

> 
> --
> Jens Axboe
> 
> 
