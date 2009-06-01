From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 02/13] block: Use accessor functions for queue limits
Date: Mon, 01 Jun 2009 01:28:18 -0400
Message-ID: <yq11vq4a5fx.fsf@sermon.lab.mkp.net>
References: <1242362435-11953-1-git-send-email-martin.petersen@oracle.com>
	<1242362435-11953-3-git-send-email-martin.petersen@oracle.com>
	<200905311751.37898.bzolnier@gmail.com>
	<yq1ab4sa6cc.fsf@sermon.lab.mkp.net>
	<20090601051556.GU11363@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20090601051556.GU11363@kernel.dk> (Jens Axboe's message of "Mon,
	1 Jun 2009 07:15:57 +0200")
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, rwheeler@redhat.com, snitzer@redhat.com, jeff@garzik.org, neilb@suse.de, James.Bottomley@hansenpartnership.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Jens" == Jens Axboe <jens.axboe@oracle.com> writes:

Jens> It replaces

Jens> q-> bounce_pfn = t->limits.bounce_pfn;

Jens> with

Jens>         blk_queue_bounce_limit(q, t->limits.bounce_pfn);

Jens> which are definitely not a functionally equivalent change.

Ah, now I see it.  Yeah, that's a bug.  I must have thought
blk_queue_bounce_limit() was one of my wrapper functions when I made
that change.  It follows the same naming scheme.

Will fix.

-- 
Martin K. Petersen	Oracle Linux Engineering
