From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH] libfc fix for scsi-rc-fixes
Date: Fri, 06 Apr 2012 15:52:46 -0700
Message-ID: <20120406225246.4950.80747.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:5778 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754658Ab2DFWwq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Apr 2012 18:52:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Here's just one patch that fixes a regression introduced in the merge window.
This is critical for BRDCM, so I would like to see it merged before v3.4 is
released.

Thanks, //Rob

---

Vasu Dev (1):
      libfc: update mfs boundry checking


 drivers/scsi/libfc/fc_lport.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

-- 
