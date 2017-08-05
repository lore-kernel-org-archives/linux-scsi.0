From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/4] scsi: add Mylex RAID controller
Date: Sat, 5 Aug 2017 13:39:32 +0200
Message-ID: <20170805113932.GF16313@lst.de>
References: <1501683208-5240-1-git-send-email-hare@suse.de> <1501683208-5240-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1501683208-5240-4-git-send-email-hare@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jth@kernel.org>, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

Can you use normal linux style for the code instead of copy and
pasting the weird naming and capitalization from the DAC960 driver?

Also please use the driver name as prefix for the functions.

Maybe myraid instead of mylex?

I'll take a more detailed look at the actual driver in a bit.
