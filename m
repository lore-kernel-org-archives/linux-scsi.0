From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 0/3] libfc, libfcoe and fcoe updates for scsi-misc
Date: Mon, 24 Sep 2012 11:52:40 -0700
Message-ID: <20120924185240.521.22975.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:36440 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757710Ab2IXSw6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Sep 2012 14:52:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Here are a few bug fixes for libfc and fcoe.
Additionally there is a documentation fix for sysfs-bus-fcoe included.

---

Neerav Parikh (1):
      fcoe: Fix write errors on NPIV ports

Robert Love (1):
      Documentation: Add lesb/ to path for LESB attributes in FCoE bus documentation

Yi Zou (1):
      libfc: fix lun reset failure bugs in fc_fcp_resp handling of FCP_RSP_INFO


 Documentation/ABI/testing/sysfs-bus-fcoe |   12 ++++++------
 drivers/scsi/fcoe/fcoe.c                 |   14 +++++---------
 drivers/scsi/fcoe/fcoe.h                 |    2 ++
 drivers/scsi/libfc/fc_fcp.c              |    3 ++-
 include/scsi/fc/fc_fcp.h                 |    6 ++++++
 include/scsi/libfcoe.h                   |    2 --
 6 files changed, 21 insertions(+), 18 deletions(-)

-- 
Thanks, //Rob
