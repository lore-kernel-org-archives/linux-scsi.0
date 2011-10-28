From: Yi Zou <yi.zou@intel.com>
Subject: [PATCH 0/4] Open-FCoE.org libfc and fcoe updates for scsi-misc
Date: Fri, 28 Oct 2011 11:34:02 -0700
Message-ID: <20111028183305.15165.96974.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39651 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933062Ab1J1SpY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Oct 2011 14:45:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: robert.w.love@intel.com

This series consists of updates for the libfc and fcoe modules. These patches
are directly applicable to latest tip of Linus's tree and I expect to be
applied cleanly on scsi-misc as well. 

thanks,
yi

---

Michael Chan (1):
      drivers/firmware/edd: Treat "XPRS" host bus type the same as "PCI"

Vasu Dev (3):
      libfc: improve flogi retries to avoid lport stuck
      libfc: avoid exchanges collision during lport reset
      libfc: fix checking FC_TYPE_BLS


 drivers/firmware/edd.c        |    6 +-
 drivers/scsi/fcoe/fcoe.c      |   13 ++---
 drivers/scsi/libfc/fc_exch.c  |    7 ++-
 drivers/scsi/libfc/fc_lport.c |  100 +++++++++++++++++++++--------------------
 4 files changed, 64 insertions(+), 62 deletions(-)

-- 
Signature: Yi Zou <yi.zou@intel.com>
