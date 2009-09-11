From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 02/35] fcoe: Increase FCOE_MAX_LUN to 0xFFFF (65535)
Date: Fri, 11 Sep 2009 16:57:06 -0700
Message-ID: <20090911235706.27223.67029.stgit@localhost.localdomain>
References: <20090911235655.27223.69728.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:4380 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757184AbZIKX5E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Sep 2009 19:57:04 -0400
In-Reply-To: <20090911235655.27223.69728.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Robert Love <robert.w.love@intel.com>

The maximum number of LUNs was far too low. This value is
what most other FC HBAs are using.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.h b/drivers/scsi/fcoe/fcoe.h
index ce7f60f..aa9c2d0 100644
--- a/drivers/scsi/fcoe/fcoe.h
+++ b/drivers/scsi/fcoe/fcoe.h
@@ -32,7 +32,7 @@
 #define FCOE_NAME	"fcoe"
 #define FCOE_VENDOR	"Open-FCoE.org"
 
-#define FCOE_MAX_LUN		255
+#define FCOE_MAX_LUN		0xFFFF
 #define FCOE_MAX_FCP_TARGET	256
 
 #define FCOE_MAX_OUTSTANDING_COMMANDS	1024

