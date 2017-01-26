From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 04/18] block: simplify blk_init_allocated_queue
Date: Wed, 25 Jan 2017 22:02:54 -0500
Message-ID: <yq1a8aea5gh.fsf@oracle.com>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
        <1485365126-23210-5-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18700 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752646AbdAZDDG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jan 2017 22:03:06 -0500
In-Reply-To: <1485365126-23210-5-git-send-email-hch@lst.de> (Christoph
        Hellwig's message of "Wed, 25 Jan 2017 18:25:12 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@fb.com>, Mike Snitzer <snitzer@redhat.com>, Junichi Nomura <j-nomura@ce.jp.nec.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> Return an errno value instead of the passed in queue so that
Christoph> the callers don't have to keep track of two queues, and move
Christoph> the assignment of the request_fn and lock to the caller as
Christoph> passing them as argument doesn't simplify anything.  While
Christoph> we're at it also remove two pointless NULL assignments, given
Christoph> that the request structure is zeroed on allocation.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
