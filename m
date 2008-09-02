From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 0/8] sg cleanup patches after the block conversion
Date: Tue,  2 Sep 2008 22:50:00 +0900
Message-ID: <1220363408-7134-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:56056 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465AbYIBNwq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Sep 2008 09:52:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, dougg@torque.net, michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp

Here's some cleanup patches, removing functions that became
unnecessary after the block conversion, functions used temporally
during the conversion, etc.

This is against the for-2.6.28 brach in the block tree:

commit 55befd9dce8c75748e02f7c733f5f5ba76be6ec7
Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date:   Tue Sep 2 16:20:20 2008 +0900

    sg: set dxferp to NULL for READ with the older SG interface


