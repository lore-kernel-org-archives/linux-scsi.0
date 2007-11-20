From: Joe Perches <joe@perches.com>
Subject: [PATCH 44/59] drivers/scsi: Add missing "space"
Date: Mon, 19 Nov 2007 17:53:31 -0800
Message-ID: <1195523627-15389-2-git-send-email-joe@perches.com>
References: 1234567
 <1195523627-15389-1-git-send-email-joe@perches.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from DSL022.labridge.com ([206.117.136.22]:2195 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759496AbXKTBxs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Nov 2007 20:53:48 -0500
In-Reply-To: <1195523627-15389-1-git-send-email-joe@perches.com>
Message-Id: <adb8f5a3245d3e618c861f99db3acd43362c92c7.1195454436.git.joe@perches.com>
In-Reply-To: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
References: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Ali Akcaagac <aliakc@web.de>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Jamie Lenehan <lenehan@twibble.org>, Oliver Neukum <oliver@neukum.name>, dc395x@twibble.org, linux-scsi@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/NCR_D700.c    |    2 +-
 drivers/scsi/aic7xxx_old.c |    2 +-
 drivers/scsi/dc395x.c      |    2 +-
 drivers/scsi/hosts.c       |    2 +-
 drivers/scsi/iscsi_tcp.c   |    6 +++---
 drivers/scsi/scsi_proc.c   |    2 +-
 drivers/scsi/scsi_scan.c   |    2 +-
 7 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/NCR_D700.c b/drivers/scsi/NCR_D700.c
index 9e64b21..99403a6 100644
--- a/drivers/scsi/NCR_D700.c
+++ b/drivers/scsi/NCR_D700.c
@@ -182,7 +182,7 @@ NCR_D700_probe_one(struct NCR_D700_private *p, int siop, int irq,
 
 	hostdata = kzalloc(sizeof(*hostdata), GFP_KERNEL);
 	if (!hostdata) {
-		printk(KERN_ERR "NCR D700: SIOP%d: Failed to allocate host"
+		printk(KERN_ERR "NCR D700: SIOP%d: Failed to allocate host "
 		       "data, detatching\n", siop);
 		return -ENOMEM;
 	}
diff --git a/drivers/scsi/aic7xxx_old.c b/drivers/scsi/aic7xxx_old.c
index 8f8db5f..c79a452 100644
--- a/drivers/scsi/aic7xxx_old.c
+++ b/drivers/scsi/aic7xxx_old.c
@@ -3716,7 +3716,7 @@ aic7xxx_pci_intr(struct aic7xxx_host *p)
   pci_read_config_byte(p->pdev, PCI_STATUS + 1, &status1);
 
   if ( (status1 & DPE) && (aic7xxx_verbose & VERBOSE_MINOR_ERROR) )
-    printk(WARN_LEAD "Data Parity Error during PCI address or PCI write"
+    printk(WARN_LEAD "Data Parity Error during PCI address or PCI write "
       "phase.\n", p->host_no, -1, -1, -1);
   if ( (status1 & SSE) && (aic7xxx_verbose & VERBOSE_MINOR_ERROR) )
     printk(WARN_LEAD "Signal System Error Detected\n", p->host_no,
diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index a9def6e..f98747c 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -1520,7 +1520,7 @@ static u8 start_scsi(struct AdapterCtlBlk* acb, struct DeviceCtlBlk* dcb,
 	}
 #endif
 	if (acb->active_dcb) {
-		dprintkl(KERN_DEBUG, "start_scsi: (pid#%li) Attempt to start a"
+		dprintkl(KERN_DEBUG, "start_scsi: (pid#%li) Attempt to start a "
 			"command while another command (pid#%li) is active.",
 			srb->cmd->serial_number,
 			acb->active_dcb->active_srb ?
diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 24271a8..b53f681 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -141,7 +141,7 @@ int scsi_host_set_state(struct Scsi_Host *shost, enum scsi_host_state state)
  illegal:
 	SCSI_LOG_ERROR_RECOVERY(1,
 				shost_printk(KERN_ERR, shost,
-					     "Illegal host state transition"
+					     "Invalid host state transition "
 					     "%s->%s\n",
 					     scsi_host_state_name(oldstate),
 					     scsi_host_state_name(state)));
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 4bcf916..2e0d9a1 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -389,7 +389,7 @@ iscsi_r2t_rsp(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 	}
 
 	if (r2t->data_length > session->max_burst)
-		debug_scsi("invalid R2T with data len %u and max burst %u."
+		debug_scsi("invalid R2T with data len %u and max burst %u. "
 			   "Attempting to execute request.\n",
 			    r2t->data_length, session->max_burst);
 
@@ -900,13 +900,13 @@ more:
 
 		memcpy(&recv_digest, conn->data, sizeof(uint32_t));
 		if (recv_digest != tcp_conn->in.datadgst) {
-			debug_tcp("iscsi_tcp: data digest error!"
+			debug_tcp("iscsi_tcp: data digest error! "
 				  "0x%x != 0x%x\n", recv_digest,
 				  tcp_conn->in.datadgst);
 			iscsi_conn_failure(conn, ISCSI_ERR_DATA_DGST);
 			return 0;
 		} else {
-			debug_tcp("iscsi_tcp: data digest match!"
+			debug_tcp("iscsi_tcp: data digest match! "
 				  "0x%x == 0x%x\n", recv_digest,
 				  tcp_conn->in.datadgst);
 			tcp_conn->in_progress = IN_PROGRESS_WAIT_HEADER;
diff --git a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
index bb6f051..781dc85 100644
--- a/drivers/scsi/scsi_proc.c
+++ b/drivers/scsi/scsi_proc.c
@@ -123,7 +123,7 @@ void scsi_proc_host_add(struct Scsi_Host *shost)
 	p = create_proc_read_entry(name, S_IFREG | S_IRUGO | S_IWUSR,
 			sht->proc_dir, proc_scsi_read, shost);
 	if (!p) {
-		printk(KERN_ERR "%s: Failed to register host %d in"
+		printk(KERN_ERR "%s: Failed to register host %d in "
 		       "%s\n", __FUNCTION__, shost->host_no,
 		       sht->proc_name);
 		return;
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 40ea71c..e0a47ed 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1124,7 +1124,7 @@ static void scsi_sequential_lun_scan(struct scsi_target *starget,
 	unsigned int sparse_lun, lun, max_dev_lun;
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 
-	SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: Sequential scan of"
+	SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: Sequential scan of "
 				    "%s\n", starget->dev.bus_id));
 
 	max_dev_lun = min(max_scsi_luns, shost->max_lun);
-- 
1.5.3.5.652.gf192c

