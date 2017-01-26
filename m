From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 03/18] block: fix elevator init check
Date: Wed, 25 Jan 2017 22:01:08 -0500
Message-ID: <yq1efzqa5jf.fsf@oracle.com>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
        <1485365126-23210-4-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18045 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752701AbdAZDB2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jan 2017 22:01:28 -0500
In-Reply-To: <1485365126-23210-4-git-send-email-hch@lst.de> (Christoph
        Hellwig's message of "Wed, 25 Jan 2017 18:25:11 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@fb.com>, Mike Snitzer <snitzer@redhat.com>, Junichi Nomura <j-nomura@ce.jp.nec.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> We can't initalize the elevator fields for flushes as flush
Christoph> share space in struct request with the elevator data.  But
Christoph> currently we can't commnicate that a request is a flush

communicate

Christoph> through blk_get_request as we can only pass READ or WRITE,
Christoph> and the low-level code looks at the possible NULL bio to
Christoph> check for a flush.

Christoph> Fix this by allowing to pass any block op and flags, and by
Christoph> checking for the flush flags in __get_request.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
