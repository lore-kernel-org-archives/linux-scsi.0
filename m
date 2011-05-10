From: madhu.iyengar@qlogic.com
Subject: [PATCH 03/11] qla2xxx: Use passed in host to initialize local scsi_qla_host in queuecommand function
Date: Tue, 10 May 2011 11:30:08 -0700
Message-ID: <1305052216-17347-4-git-send-email-madhu.iyengar@qlogic.com>
References: <1305052216-17347-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:39921 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1751659Ab1EJSgd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 May 2011 14:36:33 -0400
In-Reply-To: <1305052216-17347-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>

From: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>

Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 010f560..8401a6f 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -536,7 +536,7 @@ qla2x00_get_new_sp(scsi_qla_host_t *vha, fc_port_t *fcport,
 static int
 qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 {
-	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
+	scsi_qla_host_t *vha = shost_priv(host);
 	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
 	struct fc_rport *rport = starget_to_rport(scsi_target(cmd->device));
 	struct qla_hw_data *ha = vha->hw;
-- 
1.6.0.2

