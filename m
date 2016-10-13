From: james.smart@broadcom.com (James Smart)
Subject: [PATCH v3 10/17] lpfc: Code cleanup for lpfc_max_scsicmpl_time
 parameter
Date: Thu, 13 Oct 2016 15:06:11 -0700
Message-ID: <58000553.oeyaA6iuYm4JLdhm%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.avagotech.com ([199.3.246.86]:36364 "EHLO
        sgpsmtp2.avagotech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752883AbcJMWHT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Oct 2016 18:07:19 -0400
Received: from flash (fx9xs32.emulex.com [10.230.226.120])
        by sgpsmtp2.avagotech.com (Postfix) with SMTP id D2C001209D0
        for <linux-scsi@vger.kernel.org>; Thu, 13 Oct 2016 15:06:13 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Code cleanup for lpfc_max_scsicmpl_time parameter

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/lpfc/lpfc_attr.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 81b1faf..3051e66 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -4393,12 +4393,10 @@ LPFC_VPORT_ATTR_RW(first_burst_size, 0, 0, 65536,
 # to limit the I/O completion time to the parameter value.
 # The value is set in milliseconds.
 */
-static int lpfc_max_scsicmpl_time;
-module_param(lpfc_max_scsicmpl_time, int, S_IRUGO);
-MODULE_PARM_DESC(lpfc_max_scsicmpl_time,
+LPFC_VPORT_ATTR(max_scsicmpl_time, 0, 0, 60000,
 	"Use command completion time to control queue depth");
+
 lpfc_vport_param_show(max_scsicmpl_time);
-lpfc_vport_param_init(max_scsicmpl_time, 0, 0, 60000);
 static int
 lpfc_max_scsicmpl_time_set(struct lpfc_vport *vport, int val)
 {
-- 
2.5.0


