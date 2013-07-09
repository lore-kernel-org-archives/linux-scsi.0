From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 0/8] libfc, libfcoe, fcoe updates for 3.11(+)
Date: Tue, 09 Jul 2013 12:47:05 -0700
Message-ID: <20130709194705.10724.64013.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:37343 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860Ab3GITr3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Jul 2013 15:47:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The following series implements a few random fixes. I know this series may be a bit
late for the merge window, but they're fairly simple fixes and I think they should be
fine for RC if I've missed the merge window.

---

Bart Van Assche (1):
      fcoe: Reduce number of sparse warnings

Mark Rustad (2):
      libfc: Reject PLOGI from nodes with incompatible role
      fcoe: Stop fc_rport_priv structure leak

Neerav Parikh (1):
      fcoe: Fix smatch warning in fcoe_fdmi_info function

Robert Love (3):
      libfc: Remove extra space in fc_exch_timer_cancel definition
      libfc: Differentiate echange timer cancellation debug statements
      libfcoe: Fix meaningless log statement

Yi Zou (1):
      fcoe: fix the link error status block sparse warnings


 drivers/scsi/fcoe/fcoe.c           |   26 +++++++++++++++-----------
 drivers/scsi/fcoe/fcoe_ctlr.c      |    4 ++++
 drivers/scsi/fcoe/fcoe_sysfs.c     |   24 ++++++++++++------------
 drivers/scsi/fcoe/fcoe_transport.c |   28 ++++++----------------------
 drivers/scsi/libfc/fc_exch.c       |    4 ++--
 drivers/scsi/libfc/fc_rport.c      |   27 +++++++++++++++++++++++++++
 6 files changed, 66 insertions(+), 47 deletions(-)

-- 
Thanks, //Rob
