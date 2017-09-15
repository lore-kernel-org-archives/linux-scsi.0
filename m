From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH V3 02/12] block: Fix declaration of blk-mq scheduler
        functions
Date: Fri, 15 Sep 2017 19:46:20 +0200
Message-ID: <20170915174620.GC8578@lst.de>
References: <20170915100645.17999-1-damien.lemoal@wdc.com> <20170915100645.17999-3-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170915100645.17999-3-damien.lemoal@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

Same as for patch 1: this should stay local to block/ - we don't
want random drivers to grow I/O schedulers.
