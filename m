From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH-v2] target/iblock: Convert WRITE_SAME to blkdev_issue_zeroout
Date: Fri, 02 Jun 2017 20:39:15 -0400
Message-ID: <yq1vaodhpl8.fsf@oracle.com>
References: <1496300702-21835-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1496300702-21835-1-git-send-email-nab@linux-iscsi.org> (Nicholas
        A. Bellinger's message of "Thu, 1 Jun 2017 07:05:02 +0000")
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Mike Christie <mchristi@redhat.com>, Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@fb.com>
List-Id: linux-scsi@vger.kernel.org


Nicholas,

> The people who are actively using iblock_execute_write_same_direct()
> are doing so in the context of ESX VAAI BlockZero, together with
> EXTENDED_COPY and COMPARE_AND_WRITE primitives.
>
> In practice though I've not seen any users of IBLOCK WRITE_SAME for
> anything other than VAAI BlockZero, so just using
> blkdev_issue_zeroout() when available, and falling back to
> iblock_execute_write_same() if the WRITE_SAME buffer contains anything
> other than zeros should be OK.
>
> (Hook up max_write_zeroes_sectors to signal LBPRZ feature bit in
>  target_configure_unmap_from_queue - nab)

Looks reasonable.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
