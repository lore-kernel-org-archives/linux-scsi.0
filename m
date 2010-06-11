From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 06/17] fcoe: clean up TBD comments in FCoE prototype header
Date: Fri, 11 Jun 2010 16:43:59 -0700
Message-ID: <20100611234359.4616.1979.stgit@localhost.localdomain>
References: <20100611234328.4616.95199.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:9073 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757032Ab0FKXoA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jun 2010 19:44:00 -0400
In-Reply-To: <20100611234328.4616.95199.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>

From: Joe Eykholt <jeykholt@cisco.com>

Some old comments in fc_fcoe.h say TBD long after the
standard has been passed by T11.  Clean them up.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 include/scsi/fc/fc_fcoe.h |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/include/scsi/fc/fc_fcoe.h b/include/scsi/fc/fc_fcoe.h
index e6ad3d2..d5dcd60 100644
--- a/include/scsi/fc/fc_fcoe.h
+++ b/include/scsi/fc/fc_fcoe.h
@@ -22,23 +22,18 @@
 
 /*
  * FCoE - Fibre Channel over Ethernet.
+ * See T11 FC-BB-5 Rev 2.00 (09-056v5.pdf)
  */
 
 /*
- * FC_FCOE_OUI hasn't been standardized yet.   XXX TBD.
+ * Default FC_FCOE_OUI / FC-MAP value.
  */
-#ifndef FC_FCOE_OUI
-#define	FC_FCOE_OUI	0x0efc00	/* upper 24 bits of FCOE dest MAC TBD */
-#endif
+#define	FC_FCOE_OUI	0x0efc00	/* upper 24 bits of FCOE MAC */
 
 /*
- * The destination MAC address for the fabric login may get a different OUI.
- * This isn't standardized yet.
+ * Fabric Login (FLOGI) MAC for non-FIP use.  Non-FIP use is deprecated.
  */
-#ifndef FC_FCOE_FLOGI_MAC
-/* gateway MAC - TBD */
 #define	FC_FCOE_FLOGI_MAC { 0x0e, 0xfc, 0x00, 0xff, 0xff, 0xfe }
-#endif
 
 #define	FC_FCOE_VER	0			/* version */
 
@@ -51,8 +46,6 @@
 
 /*
  * FCoE frame header - 14 bytes
- *
- * This is the August 2007 version of the FCoE header as defined by T11.
  * This follows the VLAN header, which includes the ethertype.
  */
 struct fcoe_hdr {

