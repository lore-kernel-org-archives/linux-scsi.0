From: Jens Axboe <axboe@suse.de>
Subject: Re: open write failure not predicted by blockdev getro
Date: Wed, 14 Jul 2004 07:36:38 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040714053638.GG3055@suse.de>
References: <1089754717.9125.11.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:39822 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S267291AbUGNFgn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jul 2004 01:36:43 -0400
Content-Disposition: inline
In-Reply-To: <1089754717.9125.11.camel@patibmrh9>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: linux-scsi@vger.kernel.org

On Tue, Jul 13 2004, Pat LaVarre wrote:
> > Subject: Re: [PATCH] fix cdrom mt rainier probe
> 
> Does the reverse inconsistency also interest you?
> 
> By inserting a read-only DVD disc into a USB drive, I get to see the
> paradoxical contradiction:
> 
> $ uname -msr
> Linux 2.6.8-rc1 i686
> $
> $ sudo blockdev --getro /dev/scd0
> 0
> $ sudo dd of=/dev/scd0 bs=64K count=1 if=/dev/zero
> dd: opening `/dev/scd0': Read-only file system
> $
> 
> I trust you'll tell me if I can help further.

It does interest me, please see if you can track this problem down. I
have no time myself these days.

-- 
Jens Axboe

