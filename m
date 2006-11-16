From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 0/8] target mode support
Date: Thu, 16 Nov 2006 19:23:58 +0900
Message-ID: <20061116192358C.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:38630 "EHLO
	tama5.ecl.ntt.co.jp") by vger.kernel.org with ESMTP
	id S1423642AbWKPKYM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Nov 2006 05:24:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jens.axboe@oracle.com

The following patchset adds the target mode support in
user-space. This has been living in the -mm tree for a while. Mike and
I think it's ready for mainline inclusion.

The user-space tools and documents are available at:

http://stgt.berlios.de/

This patchset can be applied to both scsi-misc-2.6 and linux-2.6
trees.


The first two patches are for the block layer. The second patch is the
following 'support larger block pc requests' patch in the bsg tree:

http://kernel.org/git/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=commitdiff;h=d872a1b22a09dffd7b48609f80f80dfa6e78227e

It's a slightly modified version since scsi_ioctl.c in the bsg tree
was cleaned up.
