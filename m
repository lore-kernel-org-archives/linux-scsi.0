From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 0/4] Fixes for libfc, libfcoe and fcoe
Date: Fri, 13 Jan 2012 17:26:10 -0800
Message-ID: <20120114012609.19185.66603.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:63932 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753645Ab2ANB0K (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2012 20:26:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Here are a few fixes to libfc, libfcoe and fcoe. If possible,
please apply them for the 3.3 merge. If they cannot make the
merge window I think that the "fcoe: fix regression on offload
em matching function for initiator/target" patch would need
to go in scsi-rc-fixes since it fixes a regression and it seems
to block the use of offloads. The others I believe are less
necessary. I will re-mail the regression patch, targeting it
for scsi-rc-fixes, if these patches don't make the merge window.

---

Bart Van Assche (2):
      libfc: Declare local functions static
      fcoe: Move fcoe_debug_logging from fcoe.h to fcoe.c

Yi Zou (2):
      fcoe: fix regression on offload em matching function for initiator/target
      libfc: remove redundant timer init for fcp


 drivers/scsi/fcoe/fcoe.c      |   43 +++++++++++++++++++++++------------------
 drivers/scsi/fcoe/fcoe.h      |    4 +---
 drivers/scsi/libfc/fc_disc.c  |    6 +++---
 drivers/scsi/libfc/fc_elsct.c |    1 +
 drivers/scsi/libfc/fc_exch.c  |    2 +-
 drivers/scsi/libfc/fc_fcp.c   |    4 +---
 drivers/scsi/libfc/fc_lport.c |    5 +++--
 drivers/scsi/libfc/fc_rport.c |   10 +++++-----
 include/scsi/libfc.h          |    2 +-
 9 files changed, 40 insertions(+), 37 deletions(-)

-- 
Thanks, //Rob
