From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 18/18] block: don't assign cmd_flags in __blk_rq_prep_clone
Date: Wed, 25 Jan 2017 22:31:09 -0500
Message-ID: <yq137g68pky.fsf@oracle.com>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
        <1485365126-23210-19-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24439 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752576AbdAZDb3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jan 2017 22:31:29 -0500
In-Reply-To: <1485365126-23210-19-git-send-email-hch@lst.de> (Christoph
        Hellwig's message of "Wed, 25 Jan 2017 18:25:26 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@fb.com>, Mike Snitzer <snitzer@redhat.com>, Junichi Nomura <j-nomura@ce.jp.nec.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> These days we have the proper flags set since request
Christoph> allocation time.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
