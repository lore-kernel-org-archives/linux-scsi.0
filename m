From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 01/25] =?utf-8?Q?=D1=95d=3A?= split
 sd_setup_discard_cmnd
Date: Wed, 05 Apr 2017 07:42:46 -0400
Message-ID: <yq1r317t70p.fsf@oracle.com>
References: <20170331163313.31821-1-hch@lst.de>
        <20170331163313.31821-2-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170331163313.31821-2-hch@lst.de> (Christoph Hellwig's message
        of "Fri, 31 Mar 2017 18:32:49 +0200")
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, martin.petersen@oracle.com, agk@redhat.com, snitzer@redhat.com, shli@kernel.org, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Christoph Hellwig <hch@lst.de> writes:

> Split sd_setup_discard_cmnd into one function per provisioning type.  While
> this creates some very slight duplication of boilerplate code it keeps the
> code modular for additions of new provisioning types, and for reusing the
> write same functions for the upcoming scsi implementation of the Write Zeroes
> operation.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

Minor nit: Patch header should be "sd: ..." instead of " d: ...".

-- 
Martin K. Petersen	Oracle Linux Engineering
