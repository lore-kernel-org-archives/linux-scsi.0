From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH V7 6/8] scsi: sd_zbc: Initialize device request queue
        zoned data
Date: Wed, 8 Nov 2017 19:25:45 +0100
Message-ID: <20171108182545.GE579@lst.de>
References: <20171108081118.7632-1-damien.lemoal@wdc.com> <20171108081118.7632-7-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171108081118.7632-7-damien.lemoal@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

A bit of duplication vs the existing ZBC code here, but it seems the
old code is going away later in the series, so:

Reviewed-by: Christoph Hellwig <hch@lst.de>
