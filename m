From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0/3] remove scsi_req_map_sg
Date: Mon, 15 Dec 2008 08:28:17 +0100
Message-ID: <20081215072816.GP23742@kernel.dk>
References: <1229185427-4130-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:26555 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984AbYLOH2m (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Dec 2008 02:28:42 -0500
Content-Disposition: inline
In-Reply-To: <1229185427-4130-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, Kai.Makisara@kolumbus.fi, osst@riede.org

On Sun, Dec 14 2008, FUJITA Tomonori wrote:
> This patchset removes scsi_req_map_sg. IOW, this patchset removes
> 'SCSI-ml does something wrong' comment in the block layer :)
> 
> /*
>  * Temporary export, until SCSI gets fixed up.
>  */
> extern int blk_rq_append_bio(struct request_queue *q, struct request *rq,
>                             struct bio *bio);
> 
> This patchset also removes scsi_execute_async and struct
> scsi_io_context() and unexport bio_add_pc_page().
> 
> 
> This is against scsi-misc and depends on two patchsets:
> 
> 'removing scsi_execute_async in st' the second half patchset:
> 
> http://marc.info/?l=linux-scsi&m=122900494917385&w=2
> 
> 'removing scsi_execute_async in osst' the patchset:
> 
> http://marc.info/?l=linux-scsi&m=122918478521903&w=2

You can add my Acked-by to all three patches, nice work Tomo!

-- 
Jens Axboe

