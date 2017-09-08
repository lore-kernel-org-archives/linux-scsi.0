From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH V2 00/12] scsi-mq support for ZBC disks
Date: Fri, 8 Sep 2017 10:20:40 +0200
Message-ID: <20170908082040.GA25719@lst.de>
References: <20170907161640.30465-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170907161640.30465-1-damien.lemoal@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

I'm really worried about how this is tied into the sd driver.

>From a quick look it seems like the only thing you really need in
the scheduler that is done through struct scsi_disk is the
offset + len -> zone number lookup - I'd much rather expose this
from sd upwards and keep the scheduler in the block code.

Except for that this looks like a fine approach to me.
