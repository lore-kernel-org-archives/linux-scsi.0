From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 0/3] remove scsi_req_map_sg
Date: Thu, 18 Dec 2008 17:14:31 +0900
Message-ID: <20081218171529W.fujita.tomonori@lab.ntt.co.jp>
References: <1229185427-4130-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<20081215072816.GP23742@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:52718 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038AbYLRIOt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Dec 2008 03:14:49 -0500
In-Reply-To: <20081215072816.GP23742@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, Kai.Makisara@kolumbus.fi, osst@riede.org

On Mon, 15 Dec 2008 08:28:17 +0100
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Sun, Dec 14 2008, FUJITA Tomonori wrote:
> > This patchset removes scsi_req_map_sg. IOW, this patchset removes
> > 'SCSI-ml does something wrong' comment in the block layer :)
> > 
> > /*
> >  * Temporary export, until SCSI gets fixed up.
> >  */
> > extern int blk_rq_append_bio(struct request_queue *q, struct request *rq,
> >                             struct bio *bio);
> > 
> > This patchset also removes scsi_execute_async and struct
> > scsi_io_context() and unexport bio_add_pc_page().
> > 
> > 
> > This is against scsi-misc and depends on two patchsets:
> > 
> > 'removing scsi_execute_async in st' the second half patchset:
> > 
> > http://marc.info/?l=linux-scsi&m=122900494917385&w=2
> > 
> > 'removing scsi_execute_async in osst' the patchset:
> > 
> > http://marc.info/?l=linux-scsi&m=122918478521903&w=2
> 
> You can add my Acked-by to all three patches, nice work Tomo!

Thanks,

I also need your ACKs on the #1-3 patches in the following patchset to
push the nice work. :)

http://marc.info/?l=linux-scsi&m=122958057719487&w=2
