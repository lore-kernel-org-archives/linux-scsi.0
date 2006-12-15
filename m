From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 0/3] SG v4 support
Date: Sat, 16 Dec 2006 00:18:22 +0900 (JST)
Message-ID: <20061216001753F.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:38939 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289AbWLOTf4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Dec 2006 14:35:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dougg@torque.net, jens.axboe@oracle.com

The following patches add SG v4 support to bsg. They are over Jens'
bsg branch.

I just replaced bsg's SG v3 support with SG v4 and haven't added
anything new yet. So it can only handle SCSI commands.

I've uploaded simple programs to just read/write by using SG v4:

http://www.kernel.org/pub/linux/kernel/people/tomo/sg4/

# They haven't showed up yet. kernel.org is very slow today. please
# wait for a while.

I've not heavily tested this but seems to work. We can begin to do fun
stuff like extending the current code paths for blk_pc (or creates new
paths) for non SCSI commands.

