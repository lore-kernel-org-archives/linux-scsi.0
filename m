From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH V7 2/8] blokc: mq-deadline: Introduce dispatch helpers
Date: Wed, 8 Nov 2017 19:23:45 +0100
Message-ID: <20171108182345.GA579@lst.de>
References: <20171108081118.7632-1-damien.lemoal@wdc.com> <20171108081118.7632-3-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:60310 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751417AbdKHSXq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 8 Nov 2017 13:23:46 -0500
Content-Disposition: inline
In-Reply-To: <20171108081118.7632-3-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>

Except for a bit of mis-spelling in the Subject this looks fine
to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>

FYI, I would just simplify the subject to

mq-deadline: Introduce dispatch helpers

and similar in the other patches.
