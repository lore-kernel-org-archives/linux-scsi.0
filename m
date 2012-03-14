From: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
Subject: RE: [PATCH] mpt2sas: Corrected the constant in comparison to a
 hexadecimal.
Date: Wed, 14 Mar 2012 09:51:30 +0530
Message-ID: <A6888A6805518E4EA4AF7072A28264A6067E731D0E@inbmail02.lsi.com>
References: <1331665168-22561-1-git-send-email-sathisha.nanjappa@hp.com>
 <1331665168-22561-2-git-send-email-sathisha.nanjappa@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1331665168-22561-2-git-send-email-sathisha.nanjappa@hp.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Sathisha Nanjappa <sathisha.nanjappa@hp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, James Bottomley <jejb@kernel.org>
List-Id: linux-scsi@vger.kernel.org

This patch seem to be fine. Please consider this patch as Acked-by: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>

Regards,
Nagalakshmi


-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Sathisha Nanjappa
Sent: Wednesday, March 14, 2012 12:29 AM
To: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
Cc: Sathisha Nanjappa
Subject: [PATCH] mpt2sas: Corrected the constant in comparison to a hexadecimal.

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

