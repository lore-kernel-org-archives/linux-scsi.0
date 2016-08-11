From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 09/14] lpfc: Code cleanup for lpfc_max_scsicmpl_time
 parameter
Date: Thu, 11 Aug 2016 11:35:56 -0700
Message-ID: <57acc58c.Ov8VqcmTsa3qTBm7%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f181.google.com ([209.85.216.181]:34806 "EHLO
	mail-qt0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbcHKSf7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2016 14:35:59 -0400
Received: by mail-qt0-f181.google.com with SMTP id u25so2145067qtb.1
        for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2016 11:35:59 -0700 (PDT)
Received: from flash ([192.19.245.250])
        by smtp.gmail.com with ESMTPSA id p70sm978537qke.1.2016.08.11.11.35.57
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Aug 2016 11:35:58 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Code cleanup for lpfc_max_scsicmpl_time parameter

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
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

