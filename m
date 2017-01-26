From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 14/18] scsi: remove __scsi_alloc_queue
Date: Wed, 25 Jan 2017 22:25:05 -0500
Message-ID: <yq1bmuu8pv2.fsf@oracle.com>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
        <1485365126-23210-15-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18081 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752576AbdAZDZT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jan 2017 22:25:19 -0500
In-Reply-To: <1485365126-23210-15-git-send-email-hch@lst.de> (Christoph
        Hellwig's message of "Wed, 25 Jan 2017 18:25:22 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@fb.com>, Mike Snitzer <snitzer@redhat.com>, Junichi Nomura <j-nomura@ce.jp.nec.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> Instead do an internal export of __scsi_init_queue for the
Christoph> transport classes that export BSG nodes.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
