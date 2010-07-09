From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 0/3] convert flush to REQ_TYPE_FS instead of REQ_TYPE_BLOCK_PC
Date: Fri,  9 Jul 2010 09:38:23 +0900
Message-ID: <1278635906-16400-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:49698 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754425Ab0GIAjQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jul 2010 20:39:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: axboe@kernel.dk, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

This is the second version of flush REQ_TYPE_FS conversion:

http://marc.info/?l=linux-scsi&m=127730591527424&w=2

There is no major changes since the first version. Just minor
adjustment for the discard changes.

This can be applied to block's for-2.6.36.

The git tree is also available:

git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git fs-flush

=
 block/blk-barrier.c       |    3 ++-
 drivers/scsi/scsi_error.c |   19 ++++---------------
 drivers/scsi/sd.c         |    2 --
 3 files changed, 6 insertions(+), 18 deletions(-)
