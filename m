From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH 0/6] SG v4 support
Date: Wed, 20 Dec 2006 14:42:54 +0900
Message-ID: <20061220144254Z.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:56871 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932981AbWLTFm7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Dec 2006 00:42:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jens.axboe@oracle.com, dougg@torque.net

The following patches add SG v4 support to bsg.

They are over Jens' bsg branch (HEAD of the tree is
fc68dbc4630ffef6dce5198fd90bdec37a9bbf44).

I just replaced bsg's SG v3 support with SG v4 and haven't added
anything new yet. So it can only handle SCSI commands.

Changes from the previous submission:

- adds sg_io_v4 structure to bsg.h instead of sg.h
- adds SG_IO support

User-space programs can send sg_io_v4 structure via SG_IO or the
read/write interface (might be replaced by something like ring buffer
later on). Non SG_IO ioctl commands simply go to scsi_cmd_ioctl.


I also updated programs (SG_IO support was added):

http://www.kernel.org/pub/linux/kernel/people/tomo/sg4/

# but they've not showed up yet, as expected.


The 1 and 2 patches are minor fixes (doesn't include SG v4 stuff).
