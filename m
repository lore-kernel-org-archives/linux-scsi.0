From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 02/13] block: Use accessor functions for queue limits
Date: Mon, 01 Jun 2009 01:08:51 -0400
Message-ID: <yq1ab4sa6cc.fsf@sermon.lab.mkp.net>
References: <1242362435-11953-1-git-send-email-martin.petersen@oracle.com>
	<1242362435-11953-3-git-send-email-martin.petersen@oracle.com>
	<200905311751.37898.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200905311751.37898.bzolnier@gmail.com> (Bartlomiej
	Zolnierkiewicz's message of "Sun, 31 May 2009 17:51:37 +0200")
Sender: linux-ide-owner@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, rwheeler@redhat.com, snitzer@redhat.com, jeff@garzik.org, neilb@suse.de, James.Bottomley@hansenpartnership.com, jens.axboe@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Bart" == Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> writes:

>> Convert all external users of queue limits to using wrapper functions
>> instead of poking the request queue variables directly.

Did bisect this?

The patch you mention didn't touch the bounce limits at all.  One of my
other patches moved portions of the queue limits to an embedded struct.
However, it was purely variable renaming.  I have not touched anything
related to memory allocations.

[...]

Bart>  init_emergency_isa_pool+0x22/0x42 [<c0221e26>]
Bart>  blk_queue_bounce_limit+0x2c/0x41 [<c0309813>]

[...]

-- 
Martin K. Petersen	Oracle Linux Engineering
