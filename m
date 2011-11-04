From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH block/for-next] block: don't call blk_drain_queue() if
 elevator is not up
Date: Fri, 04 Nov 2011 15:28:16 +0100
Message-ID: <4EB3F680.1070309@kernel.dk>
References: <4EB2BC88.3070105@suse.cz> <20111103161436.GJ4417@google.com> <20111103162634.GK4417@google.com> <4EB2D441.9040708@kernel.dk> <20111103211253.GO4417@google.com> <4EB39E63.9020804@kernel.dk> <CAOS58YM-6v2nriMv8izhePD04YiJe0s7wqwWw=Dc9w-4er_McA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOS58YM-6v2nriMv8izhePD04YiJe0s7wqwWw=Dc9w-4er_McA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jiri Slaby <jslaby@suse.cz>, "James E.J. Bottomley" <jejb@parisc-linux.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On 2011-11-04 15:26, Tejun Heo wrote:
> Hello,
> 
> On Fri, Nov 4, 2011 at 1:12 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>> Heh, yeah, definitely, and just to be paranoid, this whole thing is
>>> for the next merge window.
>>
>> Ehm, what parts? If the bug is in for-next, things are queued up for
>> _this_ merge window.
> 
> So, we had four patchsets - the original drain improvements, updates
> to drain improvements, cfq locking cleanup, and cfq api cleanup.
> Currently, the first one is in block tree but the other three are not.
> I was thinking all four were going mainline in the next merge window.
> 
> Hmmm... yeah, the first and second patchsets kinda go together but
> well the first one definitely is pretty good bug fix without others,
> so I guess that split isn't too bad either. Alright, no objection.

OK, I'll push off what I have now and then we can queue #2 up shortly. I
would probably prefer pushing the cfq locking cleanup to 3.3 to get some
more testing time on that, but it all depends on what your level of
confidence in it is?

-- 
Jens Axboe
