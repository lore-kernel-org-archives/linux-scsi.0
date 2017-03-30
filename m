From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: RFC: always use REQ_OP_WRITE_ZEROES for zeroing offload
Date: Thu, 30 Mar 2017 11:22:21 -0400
Message-ID: <yq1lgrm3i36.fsf@oracle.com>
References: <20170323143341.31549-1-hch@lst.de>
        <20170330151257.GA910@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170330151257.GA910@redhat.com> (Mike Snitzer's message of
        "Thu, 30 Mar 2017 11:12:58 -0400")
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, martin.petersen@oracle.com, agk@redhat.com, shli@kernel.org, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com
List-Id: linux-scsi@vger.kernel.org

Mike Snitzer <snitzer@redhat.com> writes:

> Would be very useful, particularly for testing, if
> drivers/scsi/scsi_debug.c were updated to support WRITE ZEROES.

There is no WRITE ZEROES in SCSI. You should be able to get the right
behavior with lbpws=1 lbprz=1.

-- 
Martin K. Petersen	Oracle Linux Engineering
