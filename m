From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH 2/5] scsi: bfa: bfa_fcs_lport.c:  Cleaning up missing null-terminate by switching from strncpy to strzcpy
Date: Sun, 19 Oct 2014 00:13:10 +0200
Message-ID: <1413670390-6259-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, "James E.J. Bottomley" <JBottomley@parallels.com>, Andi Kleen <ak@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Dan Carpenter <dan.carpenter@oracle.com>, Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Ensures that the string is null-terminate in connection with the
use of strncpy, by switching from strncpy to strzcpy.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/bfa/bfa_fcs_lport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index ff75ef8..78af89e 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -2633,7 +2633,7 @@ bfa_fcs_fdmi_get_hbaattr(struct bfa_fcs_lport_fdmi_s *fdmi,
 	strncpy(hba_attr->driver_version, (char *)driver_info->version,
 		sizeof(hba_attr->driver_version));
 
-	strncpy(hba_attr->os_name, driver_info->host_os_name,
+	strzcpy(hba_attr->os_name, driver_info->host_os_name,
 		sizeof(hba_attr->os_name));
 
 	/*
-- 
1.7.10.4
