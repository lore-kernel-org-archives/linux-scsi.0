From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH RESEND 33/35] qla2xxx: Move warning message to debug level.
Date: Thu, 25 Sep 2014 05:17:04 -0400
Message-ID: <1411636626-7566-34-git-send-email-saurav.kashyap@qlogic.com>
References: <1411636626-7566-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:19618 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753055AbaIYJvX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2014 05:51:23 -0400
In-Reply-To: <1411636626-7566-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Sawan Chandak <sawan.chandak@qlogic.com>

Signed-off-by: Sawan Chandak <sawan.chandak@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 2562600..54cb2ac 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -857,7 +857,7 @@ qla82xx_rom_lock(struct qla_hw_data *ha)
 			break;
 		if (timeout >= qla82xx_rom_lock_timeout) {
 			lock_owner = qla82xx_rd_32(ha, QLA82XX_ROM_LOCK_ID);
-			ql_log(ql_log_warn, vha, 0xb157,
+			ql_dbg(ql_dbg_p3p, vha, 0xb157,
 			    "%s: Simultaneous flash access by following ports, active port = %d: accessing port = %d",
 			    __func__, ha->portnum, lock_owner);
 			return -1;
-- 
1.7.7

