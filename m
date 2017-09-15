From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH V3 01/12] block: Fix declaration of blk-mq debugfs
        functions
Date: Fri, 15 Sep 2017 19:45:52 +0200
Message-ID: <20170915174552.GB8578@lst.de>
References: <20170915100645.17999-1-damien.lemoal@wdc.com> <20170915100645.17999-2-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170915100645.17999-2-damien.lemoal@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Sep 15, 2017 at 07:06:34PM +0900, Damien Le Moal wrote:
> __blk_mq_debugfs_rq_show() and blk_mq_debugfs_rq_show() are exported
> symbols but ar eonly declared in the block internal file
> block/blk-mq-debugfs.h. which is not cleanly accessible to files outside
> of the block directory.
> Move the declaration of these functions to the new file
> include/linux/blk-mq-debugfs.h file to make the declarations cleanly
> available to other modules.
> 
> While at it, also move the definition of the blk_mq_debugfs_attr
> structure to allow scheduler modules outside of the block directory to
> define debugfs attributes.

I think we should keep them local to block/ where all I/O schedulers
live, so: NAK.
