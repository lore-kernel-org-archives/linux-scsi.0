From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2 of 8] block: Export I/O topology for block devices and  partitions
Date: Thu, 23 Apr 2009 09:17:30 -0400
Message-ID: <yq1mya7bjbp.fsf@sermon.lab.mkp.net>
References: <patchbomb.1240464567@sermon.lab.mkp.net>
	<cbdae69a14895dab8ba7.1240464569@sermon.lab.mkp.net>
	<20090423105145.GW4593@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20090423105145.GW4593@kernel.dk> (Jens Axboe's message of "Thu,
	23 Apr 2009 12:51:45 +0200")
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, rwheeler@redhat.com, snitzer@redhat.com, jeff@garzik.org, neilb@suse.de, James.Bottomley@hansenpartnership.com, dgilbert@interlog.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Jens" == Jens Axboe <jens.axboe@oracle.com> writes:

>> + unsigned int alignment;
>> + unsigned int granularity;
>> + unsigned int min_io;
>> + unsigned int opt_io;
>> 
>> unsigned long seg_boundary_mask; void *dma_drain_buffer;

Jens> Patch looks fine, but can we group these by name please? alignment
Jens> could be anything.

Jens> + unsigned int io_alignment;
Jens> + unsigned int io_granularity;
Jens> + unsigned int io_min;
Jens> + unsigned int io_opt;

Sure, no problem.

-- 
Martin K. Petersen	Oracle Linux Engineering
