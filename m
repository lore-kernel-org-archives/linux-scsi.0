From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 02/54] fcoe: Increase FCOE_MAX_LUN to 0xFFFF (65535)
Date: Tue, 03 Nov 2009 11:45:42 -0800
Message-ID: <20091103194542.4085.37118.stgit@localhost.localdomain>
References: <20091103194530.4085.37963.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:57421 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754624AbZKCTph (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Nov 2009 14:45:37 -0500
In-Reply-To: <20091103194530.4085.37963.stgit@localhost.localdomain>
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
index c578082..a123552 100644
--- a/drivers/scsi/fcoe/fcoe.h
+++ b/drivers/scsi/fcoe/fcoe.h
@@ -32,7 +32,7 @@
 #define FCOE_NAME	"fcoe"
 #define FCOE_VENDOR	"Open-FCoE.org"
 
-#define FCOE_MAX_LUN		255
+#define FCOE_MAX_LUN		0xFFFF
 #define FCOE_MAX_FCP_TARGET	256
 
 #define FCOE_MAX_OUTSTANDING_COMMANDS	1024

