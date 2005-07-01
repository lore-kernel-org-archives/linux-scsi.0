From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH 1/1] cciss per disk queue for 2.6
Date: Fri, 1 Jul 2005 20:21:12 +0200
Message-ID: <20050701182111.GA24146@suse.de>
References: <D4CFB69C345C394284E4B78B876C1CF107DC0869@cceexc23.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:1990 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S263420AbVGASTx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jul 2005 14:19:53 -0400
Content-Disposition: inline
In-Reply-To: <D4CFB69C345C394284E4B78B876C1CF107DC0869@cceexc23.americas.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Miller, Mike (OS Dev)" <mike.miller@hp.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Jul 01 2005, Miller, Mike (OS Dev) wrote:
> Jens Axboe wrote:
> > Different thing, I'm talking about single volume starvation, 
> > not volume-to-volume.
> > 
> > > elevator algoritm(s) may be causing writes to starve reads 
> > on the same 
> > > logical volume. We continue to investigate our other 
> > performance issues.
> > 
> > I completely disagree. Even with an intelligent io scheduler, 
> > starvation is seen on ciss that does not happen on other 
> > queueing hardware such as 'normal' scsi controllers/drives. 
> > So something else is going on, and the only 'fix' so far is 
> > to limit the ciss queue depth heavily.
> 
> We will investigate this further and come up with a solution. Could be
> the firmware, I suppose.

Unfortunately I don't have any hardware at hand for testing, so I cannot
do it myself. Would be appreciated!

-- 
Jens Axboe

