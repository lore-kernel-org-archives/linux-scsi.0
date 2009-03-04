From: Vasu Dev <vasu.dev@intel.com>
Subject: [PATCH 0/5] FIP feature for 2.6.30 merge window
Date: Wed, 04 Mar 2009 10:53:36 -0800
Message-ID: <20090304185025.22010.45242.stgit@vi2.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:30633 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755136AbZCDSxi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Mar 2009 13:53:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch set implements FCoE initialization protocol (FIP), see patch 2/5
for more details on FIP.

These patches are :

	1. built on top of most recently submitted open-fcoe.org patches by Rob
	   at http://marc.info/?l=linux-scsi&m=123576089125544&w=2 

	2. tested with open-fcoe.org fcoe-fixes git tree which is based on
	   Linus's 2.6.29-rc6 tree, thus should apply to scsi-misc also.

---

Joe Eykholt (3):
      fcoe: libfcoe: fix FIP link logic
      fcoe: Add support for the FIP discovery and keep-alive protocol.
      fcoe: Add a header file defining the FIP protocol for FCoE.

Vasu Dev (2):
      fcoe: removes sharing of fcoe_rx_list for both FCoE and FIP frames
      fcoe: removed kzalloc from fcoe_ctlr_parse_adv (v3)


 drivers/scsi/Kconfig             |   11 
 drivers/scsi/Makefile            |    1 
 drivers/scsi/fcoe/fcoe_sw.c      |   61 ++
 drivers/scsi/fcoe/libfcoe.c      |  167 ++---
 drivers/scsi/libfcoe/Makefile    |    6 
 drivers/scsi/libfcoe/fcoe_ctlr.c | 1238 ++++++++++++++++++++++++++++++++++++++
 include/scsi/fc/fc_fip.h         |  237 +++++++
 include/scsi/fcoe_ctlr.h         |  105 +++
 include/scsi/libfcoe.h           |   24 -
 9 files changed, 1716 insertions(+), 134 deletions(-)
 create mode 100644 drivers/scsi/libfcoe/Makefile
 create mode 100644 drivers/scsi/libfcoe/fcoe_ctlr.c
 create mode 100644 include/scsi/fc/fc_fip.h
 create mode 100644 include/scsi/fcoe_ctlr.h

-- 

	Vasu
