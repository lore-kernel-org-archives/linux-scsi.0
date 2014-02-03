From: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] trivial: scsi: Fix warning on make htmldocs caused by scsi_transport_srp.c
Date: Mon,  3 Feb 2014 23:34:25 +0900
Message-ID: <1391438065-22267-1-git-send-email-standby24x7@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com, trivial@kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
List-Id: linux-scsi@vger.kernel.org

This patch fixed following warnings on make htmldocs.

Warning(/drivers/scsi/scsi_transport_srp.c:819):
No description found for parameter 'rport'

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/scsi/scsi_transport_srp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index d47ffc8..664eb38 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -811,6 +811,8 @@ EXPORT_SYMBOL_GPL(srp_remove_host);
 /**
  * srp_stop_rport_timers - stop the transport layer recovery timers
  *
+ * @rport: SRP remote port to be removed
+ *
  * Must be called after srp_remove_host() and scsi_remove_host(). The caller
  * must hold a reference on the rport (rport->dev) and on the SCSI host
  * (rport->dev.parent).
-- 
1.9.rc1
