From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 05/13] block: Export I/O topology for block devices and
	partitions
Date: Fri, 22 May 2009 20:16:48 +0200
Message-ID: <20090522181648.GN11363@kernel.dk>
References: <1242362435-11953-1-git-send-email-martin.petersen@oracle.com> <1242362435-11953-6-git-send-email-martin.petersen@oracle.com> <20090518175741.GM4140@kernel.dk> <20090518181204.GC32085@redhat.com> <yq1fxf1gi3y.fsf@sermon.lab.mkp.net> <20090519181530.GH4140@kernel.dk> <yq1ws8bealr.fsf@sermon.lab.mkp.net> <20090522073050.GH11363@kernel.dk> <yq1ljopdzxn.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1ljopdzxn.fsf@sermon.lab.mkp.net>
Sender: linux-ide-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, May 22 2009, Martin K. Petersen wrote:
> >>>>> "Jens" == Jens Axboe <jens.axboe@oracle.com> writes:
> 
> Jens> I replaced the original patch and went to apply this, but it fails
> Jens> even at the first patch. What is this against? If you want it
> Jens> queued for 2.6.31, please post it against the for-2.6.31 branch of
> Jens> the block repo.
> 
> Weird.  It was cut against your for-2.6.31 branch as of a few days ago.
> I just updated to your latest and greatest and the patches still apply
> cleanly for me.

That is weird...

> Are you sure you got the patch order right?

Using git am, it seems to pick them up in the right order:

axboe@carl:~/git/linux-2.6-block$ git am -s mkp
Applying: block: Do away with the notion of hardsect_size
Applying: block: Use accessor functions for queue limits
error: patch failed: block/blk-map.c:291
error: block/blk-map.c: patch does not apply
Patch failed at 0002 block: Use accessor functions for queue limits
When you have resolved this problem run "git am --resolved".
If you would prefer to skip this patch, instead run "git am --skip".
To restore the original branch and stop patching run "git am --abort".

My for-2.6.31 branch is at b9ed7252d219c1c663944bf03846eabb515dbe75

-- 
Jens Axboe

