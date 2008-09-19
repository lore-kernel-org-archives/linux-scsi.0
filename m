From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 0/2] Add lld-congestion bit for backing_dev_info
Date: Fri, 19 Sep 2008 10:47:56 -0400 (EDT)
Message-ID: <20080919.104756.41628866.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45193 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908AbYISOuT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Sep 2008 10:50:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com

Hi James,

The following patches exports busy-status of SCSI LLD to
request-based dm-multipath for proper I/O scheduling.
The patches are created on the following commit of scsi-misc-2.6.
---------------------------------------------------------------
commit 7d36ee8aefec15ab00ac08dc5611d6b5eab38d7f
Author: Andrew Vasquez <andrew.vasquez@qlogic.com>
Date:   Thu Sep 11 21:22:54 2008 -0700

    [SCSI] qla2xxx: Update version number to 8.02.01-k8.
---------------------------------------------------------------

No major changes since the last post (http://lkml.org/lkml/2008/9/12/100),
except for rebasing on top of scsi-misc-2.6 from 2.6.27-rc6.

Summary of the patches:
  1/2: lld busy status exporting interface
  2/2: scsi: exports busy status via bdi_lld_congested

Please review and apply.

The 1st patch changes generic part and not specific to scsi,
so I'm not sure whether it is appropriate to ask you about merging
this patch.
If I should push the 1st patch separately to other person,
please let me know.

Thanks,
Kiyoshi Ueda
