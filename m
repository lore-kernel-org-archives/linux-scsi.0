From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH block/for-next] block: don't call blk_drain_queue() if
 elevator is not up
Date: Thu, 3 Nov 2011 14:12:53 -0700
Message-ID: <20111103211253.GO4417@google.com>
References: <4EB2BC88.3070105@suse.cz>
 <20111103161436.GJ4417@google.com>
 <20111103162634.GK4417@google.com>
 <4EB2D441.9040708@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4EB2D441.9040708@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Jiri Slaby <jslaby@suse.cz>, "James E.J. Bottomley" <jejb@parisc-linux.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Nov 03, 2011 at 06:49:53PM +0100, Jens Axboe wrote:
> > Fix it by making blk_cleanup_queue() check whether q->elevator is set
> > up before invoking blk_drain_queue.
> 
> Thanks, glad this got caught before the merge...

Heh, yeah, definitely, and just to be paranoid, this whole thing is
for the next merge window.

Thanks.

-- 
tejun
