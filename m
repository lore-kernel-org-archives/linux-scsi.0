From: Sathisha Nanjappa <sathisha.nanjappa@hp.com>
Subject: [PATCH] mpt2sas: Corrected the constant in comparison to a hexadecimal.
Date: Tue, 13 Mar 2012 11:59:28 -0700
Message-ID: <1331665168-22561-2-git-send-email-sathisha.nanjappa@hp.com>
References: <1331665168-22561-1-git-send-email-sathisha.nanjappa@hp.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1331665168-22561-1-git-send-email-sathisha.nanjappa@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sathisha Nanjappa <sathisha.nanjappa@hp.com>
List-Id: linux-scsi@vger.kernel.org

    Bugzilla 42142 - mpt2sas: Number specified in wrong base
    https://bugzilla.kernel.org/show_bug.cgi?id=42142

Signed-off-by: Sathisha Nanjappa <sathisha.nanjappa@hp.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 0b2c955..f9a1244 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -657,7 +657,7 @@ _base_sas_log_info(struct MPT2SAS_ADAPTER *ioc , u32 log_info)
 		return;
 
 	/* eat the loginfos associated with task aborts */
-	if (ioc->ignore_loginfos && (log_info == 30050000 || log_info ==
+	if (ioc->ignore_loginfos && (log_info == 0x30050000 || log_info ==
 	    0x31140000 || log_info == 0x31130000))
 		return;
 
-- 
1.7.7.6
