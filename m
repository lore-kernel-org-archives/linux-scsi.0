From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 6/6] cciss: fix bug if scsi tape support is disabled
Date: Wed, 6 Aug 2008 12:32:38 +0200
Message-ID: <20080806103237.GL20055@kernel.dk>
References: <20080730211842.GF1758@roadking.ldev.net> <20080804095633.GA20055@kernel.dk> <20080805153012.0076396e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:8321 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285AbYHFKck (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Aug 2008 06:32:40 -0400
Content-Disposition: inline
In-Reply-To: <20080805153012.0076396e.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mike.miller@hp.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, Aug 05 2008, Andrew Morton wrote:
> On Mon, 4 Aug 2008 11:56:33 +0200
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Wed, Jul 30 2008, Mike Miller wrote:
> > > Patch 6 of 6
> > > 
> > > Bug fix. If SCSI tape support is turned off we get an implicit declaration
> > > of cciss_unregister_scsi error in cciss_remove_one.
> > > Please consider this for inclusion.
> > 
> > Applied 1-6, thanks.
> 
> I'm not seeing these changes in linux-next nor in
> master.kernel.org/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git#for-next
> nor in #for-akpm.

Both are fixed up now!

> Also, #for-next is empty, but #for-akpm has the single commit
> 
>     commit 7b87c0541a2d606c0b1a47fa8afbaeb32fad6d60
>     Author: Jens Axboe <jens.axboe@oracle.com>
>     Date:   Wed Jun 25 12:04:48 2008 +0200
> 
>         vmsplice: implement real vmsplice to userspace

Not sure what to do about that one, actually. It's relatively simple,
but... I'll probaly send it out for review soonish on linux-mm and
linux-kernel.

-- 
Jens Axboe

