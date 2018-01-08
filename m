From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V9 0/7] blk-mq support for ZBC disks
Date: Mon, 08 Jan 2018 10:52:38 -0500
Message-ID: <yq1vagcpcu1.fsf@oracle.com>
References: <20171221064344.6228-1-damien.lemoal@wdc.com>
        <20180105162150.GA16978@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180105162150.GA16978@kernel.dk> (Jens Axboe's message of "Fri,
        5 Jan 2018 09:21:52 -0700")
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <damien.lemoal@wdc.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org


Jens,

> This looks OK for me for 4.16. I can grab all of them, or I can leave
> the last two for Martin to apply if he prefers that, though that will
> add a block tree dependency for SCSI.

I already have a block dependency for 4.16. But it doesn't matter much.

-- 
Martin K. Petersen	Oracle Linux Engineering
