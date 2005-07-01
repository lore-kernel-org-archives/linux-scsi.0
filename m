From: Jens Axboe <axboe@suse.de>
Subject: Re: Write cache on SATA drives?
Date: Fri, 1 Jul 2005 08:24:21 +0200
Message-ID: <20050701062416.GQ2243@suse.de>
References: <C664ABFF405D6A458806C03AA2E0FF6B0560E7CC@MKEMLVEM01.e2k.ad.ge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:57248 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S263225AbVGAGWx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jul 2005 02:22:53 -0400
Content-Disposition: inline
In-Reply-To: <C664ABFF405D6A458806C03AA2E0FF6B0560E7CC@MKEMLVEM01.e2k.ad.ge.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Edwards, Scott (GE Healthcare)" <J.Scott.Edwards@ge.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Jun 30 2005, Edwards, Scott (GE Healthcare) wrote:
> Hello,
> 
> Can anyone tell me if the write cache on SATA drives are handled such
> that journaling file systems work correctly?  Back in the 2.6.5 -
> 2.6.7 time frame I had to disable the write cache to get ext3 to not
> trash things when the power was lost.  With kernel 2.6.10 would I
> still need to disable the write cache?

With 2.6.12.x it should work, if you use ext3 or reiser and the
appropriate mount options (-o barrier=1 for ext3, barrier=flush for
reiserfs). 2.6.11 and earlier does not work on SATA.

-- 
Jens Axboe

