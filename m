From: Yi Zou <yi.zou@intel.com>
Subject: [PATCH 0/6] Open-FCoE.org libfc and fcoe updates for scsi-misc
Date: Tue, 27 Sep 2011 21:37:46 -0700
Message-ID: <20110928043601.13004.92207.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:33150 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719Ab1I1Eq7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Sep 2011 00:46:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This series consists of updates for the libfc and fcoe modules. There are no
features in this series and most patches are performance improvement related
bug fixes.

Thanks,
yi

---

Eric Dumazet (1):
      fcoe: use kthread_create_on_node

Vasu Dev (5):
      fcoe: setup default initial value for DDP threshold
      fcoe: use real dev in case of HW vlan acceleration
      libfc: cache align fc_exch_pool
      libfc: cache align struct fc_exch fields
      libfc: cache align struct fc_fcp_pkt fields


 drivers/scsi/fcoe/fcoe.c     |   16 +++++++--
 drivers/scsi/fcoe/fcoe.h     |    1 +
 drivers/scsi/libfc/fc_exch.c |   11 +++---
 drivers/scsi/libfc/fc_fcp.c  |    2 -
 include/scsi/libfc.h         |   76 ++++++++++++++++++------------------------
 5 files changed, 51 insertions(+), 55 deletions(-)

-- 
Signature: Yi Zou <yi.zou@intel.com>
