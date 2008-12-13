From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 0/3] remove scsi_req_map_sg
Date: Sun, 14 Dec 2008 01:23:44 +0900
Message-ID: <1229185427-4130-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:41070 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819AbYLMQ20 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Dec 2008 11:28:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, Kai.Makisara@kolumbus.fi, osst@riede.org

This patchset removes scsi_req_map_sg. IOW, this patchset removes
'SCSI-ml does something wrong' comment in the block layer :)

/*
 * Temporary export, until SCSI gets fixed up.
 */
extern int blk_rq_append_bio(struct request_queue *q, struct request *rq,
                            struct bio *bio);

This patchset also removes scsi_execute_async and struct
scsi_io_context() and unexport bio_add_pc_page().


This is against scsi-misc and depends on two patchsets:

'removing scsi_execute_async in st' the second half patchset:

http://marc.info/?l=linux-scsi&m=122900494917385&w=2

'removing scsi_execute_async in osst' the patchset:

http://marc.info/?l=linux-scsi&m=122918478521903&w=2



