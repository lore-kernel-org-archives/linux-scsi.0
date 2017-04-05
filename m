From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 02/25] block: renumber REQ_OP_WRITE_ZEROES
Date: Wed, 05 Apr 2017 07:43:11 -0400
Message-ID: <yq1mvbvt700.fsf@oracle.com>
References: <20170331163313.31821-1-hch@lst.de>
        <20170331163313.31821-3-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170331163313.31821-3-hch@lst.de> (Christoph Hellwig's message
        of "Fri, 31 Mar 2017 18:32:50 +0200")
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, martin.petersen@oracle.com, agk@redhat.com, snitzer@redhat.com, shli@kernel.org, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Christoph Hellwig <hch@lst.de> writes:

> Make life easy for implementations that needs to send a data buffer
> to the device (e.g. SCSI) by numbering it as a data out command.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
