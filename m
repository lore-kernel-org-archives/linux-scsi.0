From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH block/for-next] block: don't call blk_drain_queue() if
 elevator is not up
Date: Fri, 4 Nov 2011 07:26:27 -0700
Message-ID: <CAOS58YM-6v2nriMv8izhePD04YiJe0s7wqwWw=Dc9w-4er_McA@mail.gmail.com>
References: <4EB2BC88.3070105@suse.cz>
	<20111103161436.GJ4417@google.com>
	<20111103162634.GK4417@google.com>
	<4EB2D441.9040708@kernel.dk>
	<20111103211253.GO4417@google.com>
	<4EB39E63.9020804@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4EB39E63.9020804@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Jiri Slaby <jslaby@suse.cz>, "James E.J. Bottomley" <jejb@parisc-linux.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Hello,

On Fri, Nov 4, 2011 at 1:12 AM, Jens Axboe <axboe@kernel.dk> wrote:
>> Heh, yeah, definitely, and just to be paranoid, this whole thing is
>> for the next merge window.
>
> Ehm, what parts? If the bug is in for-next, things are queued up for
> _this_ merge window.

So, we had four patchsets - the original drain improvements, updates
to drain improvements, cfq locking cleanup, and cfq api cleanup.
Currently, the first one is in block tree but the other three are not.
I was thinking all four were going mainline in the next merge window.

Hmmm... yeah, the first and second patchsets kinda go together but
well the first one definitely is pretty good bug fix without others,
so I guess that split isn't too bad either. Alright, no objection.

Thanks.

-- 
tejun
