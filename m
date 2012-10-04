From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH v2 0/3] libfc, libfcoe and fcoe updates for scsi-misc
Date: Thu, 04 Oct 2012 13:14:37 -0700
Message-ID: <20121004201436.29312.47930.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:30087 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162Ab2JDUOh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Oct 2012 16:14:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

v2:

Fixed typo in patch #2 and I've now provided a pull URL at:

git://open-fcoe.org/fcoe/linux-fcoe.git tags/for-james-2-tag

--

v1:

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
