From: Vasu Dev <vasu.dev@intel.com>
Subject: [PATCH 0/3] libfc patches for kernel v4.2
Date: Fri, 05 Jun 2015 14:20:35 -0700
Message-ID: <20150605212003.6054.15351.stgit@lin-nd1-054.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20793 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753124AbbFEVU4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Jun 2015 17:20:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: fcoe-devel@open-fcoe.org, target-devel <target-devel@vger.kernel.org>

These libfc fixes are for kernel 4.2 and with two patches CCed for stable
kernel also, those two could be picked for current 4.1 cycle now but in case
too late for current 4.1 then anyway should get picked up by 4.1 stable
kernel later.

These patches were posted by Bart Van Assche at open-fcoe.org and then 
I updated them per discussion on original patches to pick revised patch
and add related comments at:

http://lists.open-fcoe.org/pipermail/fcoe-devel/2015-May/012467.html


Bart Van Assche (3):
      libfc: Fix fc_fcp_cleanup_each_cmd()
      libfc: Fix fc_exch_recv_req() error path
      libfc: Fix a typo in a source code comment


 drivers/scsi/libfc/fc_exch.c |    8 ++++----
 drivers/scsi/libfc/fc_fcp.c  |   21 ++++++++++++++++++---
 2 files changed, 22 insertions(+), 7 deletions(-)

-- 

//Vasu
