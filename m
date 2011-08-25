From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 0/4] libfc and fcoe updates for scsi-misc
Date: Thu, 25 Aug 2011 12:40:42 -0700
Message-ID: <20110825194042.9599.50292.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:50250 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470Ab1HYTlX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Aug 2011 15:41:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: yi.zou@intel.com

This series consists of updates for the libfc and
fcoe modules. There are no features in this series,
only bug fixes.

---

Robert Love (1):
      fcoe: Fix deadlock between fip's recv_work and rtnl

Vasu Dev (2):
      libfc: fix fc_eh_host_reset
      libfc: block SCSI eh thread for blocked rports

Yi Zou (1):
      libfc: fix referencing to fc_fcp_pkt from the frame pointer via fr_fsp()


 drivers/scsi/fcoe/fcoe.c      |   13 ++++++---
 drivers/scsi/libfc/fc_exch.c  |   59 ++++++++++++++++++++++++++++-------------
 drivers/scsi/libfc/fc_fcp.c   |   11 ++++++--
 drivers/scsi/libfc/fc_lport.c |   11 +++++++-
 4 files changed, 68 insertions(+), 26 deletions(-)

-- 
Thanks, //Rob
