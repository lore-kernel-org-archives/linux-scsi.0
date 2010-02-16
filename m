From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 8/9] fnic: Set fnic driver version
Date: Tue, 16 Feb 2010 12:15:55 -0800
Message-ID: <20100216201555.26581.56050.stgit@localhost.localdomain>
References: <20100216201513.26581.83756.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:7244 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933293Ab0BPUP4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Feb 2010 15:15:56 -0500
In-Reply-To: <20100216201513.26581.83756.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Venkata Siva Vijayendra Bhamidipati <vbhamidi@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Venkata Siva Vijayendra Bhamidipati <vbhamidi@cisco.com>

Update fnic driver version.

Signed-off-by: Venkata Siva Vijayendra Bhamidipati <vbhamidi@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fnic/fnic.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index bb208a6..3966c71 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -36,7 +36,7 @@
 
 #define DRV_NAME		"fnic"
 #define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
-#define DRV_VERSION		"1.0.0.1121"
+#define DRV_VERSION		"1.4.0.98"
 #define PFX			DRV_NAME ": "
 #define DFX                     DRV_NAME "%d: "
 

