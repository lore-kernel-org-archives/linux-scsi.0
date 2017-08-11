From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2 00/20] blk-mq-sched: improve SCSI-MQ performance
Date: Fri, 11 Aug 2017 01:11:35 -0700
Message-ID: <20170811081135.GA4260@infradead.org>
References: <20170805065705.12989-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:52440 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751370AbdHKILh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Aug 2017 04:11:37 -0400
Content-Disposition: inline
In-Reply-To: <20170805065705.12989-1-ming.lei@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

[+ Martin and linux-scsi]

Given that we need this big pile and a few bfq fixes to avoid
major regressesions I'm tempted to revert the default to scsi-mq
for 4.14, but bring it back a little later for 4.15.

What do you think?  Maybe for 4.15 we could also do it through the
block tree where all the fixes will be queued.
