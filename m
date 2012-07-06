From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 0/6] libfc, libfcoe and fcoe updates for scsi-misc
Date: Fri, 06 Jul 2012 10:39:59 -0700
Message-ID: <20120706173959.4102.12091.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:32270 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757652Ab2GFRkA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Jul 2012 13:40:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Here are a few bug fixes across libfc, libfcoe and fcoe.

---

Neil Horman (1):
      fcoe: Cleanup locking on fcoe_percpu_receive_thread

Robert Love (1):
      fcoe: Remove redundant 'less than zero' check

Vasu Dev (2):
      libfc: add exch timer debug info
      libfc: fix retries with FDMI lport states

Yi Zou (2):
      libfc: don't exch_done() on invalid sequence ptr
      libfc: fix sending REC after FCP_RESP is received


 drivers/scsi/fcoe/fcoe.c       |   18 ++++----
 drivers/scsi/fcoe/fcoe_sysfs.c |    2 -
 drivers/scsi/libfc/fc_exch.c   |   96 ++++++++++++++++++++++------------------
 drivers/scsi/libfc/fc_fcp.c    |    6 +--
 drivers/scsi/libfc/fc_lport.c  |    8 ++-
 5 files changed, 72 insertions(+), 58 deletions(-)

-- 
Thanks, //Rob
