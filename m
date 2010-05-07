From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 03/10] libfc: Remove unused fc_get_host_port_type
Date: Fri, 07 May 2010 15:18:24 -0700
Message-ID: <20100507221824.14971.67023.stgit@localhost.localdomain>
References: <20100507221804.14971.11739.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:10734 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170Ab0EGWSZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 May 2010 18:18:25 -0400
In-Reply-To: <20100507221804.14971.11739.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Robert Love <robert.w.love@intel.com>

Remove this unused routine.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_lport.c |   11 -----------
 include/scsi/libfc.h          |    1 -
 2 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index ef25e11..7159bcf 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -244,17 +244,6 @@ static void fc_lport_ptp_setup(struct fc_lport *lport,
 }
 
 /**
- * fc_get_host_port_type() - Return the port type of the given Scsi_Host
- * @shost: The SCSI host whose port type is to be determined
- */
-void fc_get_host_port_type(struct Scsi_Host *shost)
-{
-	/* TODO - currently just NPORT */
-	fc_host_port_type(shost) = FC_PORTTYPE_NPORT;
-}
-EXPORT_SYMBOL(fc_get_host_port_type);
-
-/**
  * fc_get_host_port_state() - Return the port state of the given Scsi_Host
  * @shost:  The SCSI host whose port state is to be determined
  */
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index a26bb50..1755fa7 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -1049,7 +1049,6 @@ void fc_exch_mgr_reset(struct fc_lport *, u32 s_id, u32 d_id);
  * Functions for fc_functions_template
  */
 void fc_get_host_speed(struct Scsi_Host *);
-void fc_get_host_port_type(struct Scsi_Host *);
 void fc_get_host_port_state(struct Scsi_Host *);
 void fc_set_rport_loss_tmo(struct fc_rport *, u32 timeout);
 struct fc_host_statistics *fc_get_host_stats(struct Scsi_Host *);

