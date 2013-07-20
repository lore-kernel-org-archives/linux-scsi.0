From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
Date: Sat, 20 Jul 2013 17:57:59 -0600
Message-ID: <20130720235759.GB28005@kernel.dk>
References: <1374173515.7397.948.camel@haakon3.risingtidesystems.com>
 <51E83E32.9050306@cs.wisc.edu>
 <1374193399.7397.973.camel@haakon3.risingtidesystems.com>
 <20130719003034.GG28005@kernel.dk>
 <1374195825.7397.997.camel@haakon3.risingtidesystems.com>
 <1374215660.7397.1041.camel@haakon3.risingtidesystems.com>
 <1374248000.2266.20.camel@dabdike>
 <1374267684.7397.1058.camel@haakon3.risingtidesystems.com>
 <1374296162.7397.1098.camel@haakon3.risingtidesystems.com>
 <51EAA33C.9010405@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <51EAA33C.9010405@fusionio.com>
Sender: linux-ide-owner@vger.kernel.org
To: Mike Christie <mchristie@fusionio.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Alexander Gordeev <agordeev@redhat.com>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, Jul 20 2013, Mike Christie wrote:
> blk-mq: blk-mq should free bios in pass through case
> 
> For non mq calls, the block layer will free the bios when
> blk_finish_request is called.
> 
> For mq calls, the blk mq code wants the caller to do this.
> 
> This patch has the blk mq code work like the non mq code
> and has the block layer free the bios.

Thanks Mike, looks good, applied.

-- 
Jens Axboe

