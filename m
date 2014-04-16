From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 4/8] blk-mq: add blk_mq_delay_queue
Date: Wed, 16 Apr 2014 10:51:19 -0600
Message-ID: <534EB507.5030503@kernel.dk>
References: <1397634299-7466-1-git-send-email-hch@lst.de> <1397634299-7466-5-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1397634299-7466-5-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 04/16/2014 01:44 AM, Christoph Hellwig wrote:
> Add a blk-mq equivalent to blk_delay_queue so that the scsi layer can ask
> to be kicked again after a delay.

Applied with the preempts bits from the delayed work handler removed.

-- 
Jens Axboe
