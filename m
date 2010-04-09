From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 06/12] fnic: Update version to 1.4.0.145
Date: Fri, 09 Apr 2010 14:22:44 -0700
Message-ID: <20100409212244.1968.8148.stgit@localhost.localdomain>
References: <20100409212212.1968.59251.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:53131 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757346Ab0DIVWo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Apr 2010 17:22:44 -0400
In-Reply-To: <20100409212212.1968.59251.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Brian Uchino <buchino@cisco.com>, Abhijeet Joglekar <abjoglek@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Brian Uchino <buchino@cisco.com>

New fnic version to mark inclusion of tx_flush bugfix.

Signed-off-by:  Brian Uchino <buchino@cisco.com>
Signed-off-by:  Abhijeet Joglekar <abjoglek@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fnic/fnic.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 3966c71..585cc9c 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -36,7 +36,7 @@
 
 #define DRV_NAME		"fnic"
 #define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
-#define DRV_VERSION		"1.4.0.98"
+#define DRV_VERSION		"1.4.0.145"
 #define PFX			DRV_NAME ": "
 #define DFX                     DRV_NAME "%d: "
 

