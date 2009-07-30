From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 04/22] libfc: remove extra semicolons from debug macros
Date: Wed, 29 Jul 2009 17:04:06 -0700
Message-ID: <20090730000406.24658.20870.stgit@localhost.localdomain>
References: <20090730000345.24658.24830.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:46487 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755313AbZG3AEG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jul 2009 20:04:06 -0400
In-Reply-To: <20090730000345.24658.24830.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

This is unlikely to cause any problems, but the libfc debug macros
introduce extra undesirable semicolons.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 include/scsi/libfc.h |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index b92584a..ef04a2c 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -51,22 +51,22 @@ do {								\
 		do {						\
 			CMD;					\
 		} while (0);					\
-} while (0);
+} while (0)
 
 #define FC_LIBFC_DBG(fmt, args...)					\
 	FC_CHECK_LOGGING(FC_LIBFC_LOGGING,				\
-			 printk(KERN_INFO "libfc: " fmt, ##args);)
+			 printk(KERN_INFO "libfc: " fmt, ##args))
 
 #define FC_LPORT_DBG(lport, fmt, args...)				\
 	FC_CHECK_LOGGING(FC_LPORT_LOGGING,				\
 			 printk(KERN_INFO "lport: %6x: " fmt,		\
-				fc_host_port_id(lport->host), ##args);)
+				fc_host_port_id(lport->host), ##args))
 
 #define FC_DISC_DBG(disc, fmt, args...)					\
 	FC_CHECK_LOGGING(FC_DISC_LOGGING,				\
 			 printk(KERN_INFO "disc: %6x: " fmt,		\
 				fc_host_port_id(disc->lport->host),	\
-				##args);)
+				##args))
 
 #define FC_RPORT_DBG(rport, fmt, args...)				\
 do {									\
@@ -75,31 +75,31 @@ do {									\
 	FC_CHECK_LOGGING(FC_RPORT_LOGGING,				\
 			 printk(KERN_INFO "rport: %6x: %6x: " fmt,	\
 				fc_host_port_id(lport->host),		\
-				rport->port_id, ##args);)		\
-} while (0);
+				rport->port_id, ##args));		\
+} while (0)
 
 #define FC_FCP_DBG(pkt, fmt, args...)					\
 	FC_CHECK_LOGGING(FC_FCP_LOGGING,				\
 			 printk(KERN_INFO "fcp: %6x: %6x: " fmt,	\
 				fc_host_port_id(pkt->lp->host),		\
-				pkt->rport->port_id, ##args);)
+				pkt->rport->port_id, ##args))
 
 #define FC_EM_DBG(em, fmt, args...)					\
 	FC_CHECK_LOGGING(FC_EM_LOGGING,					\
 			 printk(KERN_INFO "em: %6x: " fmt,		\
 				fc_host_port_id(em->lp->host),		\
-				##args);)
+				##args))
 
 #define FC_EXCH_DBG(exch, fmt, args...)					\
 	FC_CHECK_LOGGING(FC_EXCH_LOGGING,				\
 			 printk(KERN_INFO "exch: %6x: %4x: " fmt,	\
 				fc_host_port_id(exch->lp->host),	\
-				exch->xid, ##args);)
+				exch->xid, ##args))
 
 #define FC_SCSI_DBG(lport, fmt, args...)				\
 	FC_CHECK_LOGGING(FC_SCSI_LOGGING,                               \
 			 printk(KERN_INFO "scsi: %6x: " fmt,		\
-				fc_host_port_id(lport->host), ##args);)
+				fc_host_port_id(lport->host), ##args))
 
 /*
  * libfc error codes

