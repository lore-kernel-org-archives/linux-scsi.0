From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 10/10] aacraid: Update driver version
Date: Mon, 25 Apr 2016 23:32:44 -0700
Message-ID: <20160426063244.28402.79178.stgit@pmcuser-System-Product-Name>
References: <20160426062414.28402.69178.stgit@pmcuser-System-Product-Name>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0056.outbound.protection.outlook.com ([65.55.169.56]:17926
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752478AbcDZGfp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Apr 2016 02:35:45 -0400
In-Reply-To: <20160426062414.28402.69178.stgit@pmcuser-System-Product-Name>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc: aacraid@pmc-sierra.com, gana.sridaran@microsemi.com, scott.benesh@microsemi.com, vishal.josemannanal@microsemi.com, RaghavaAditya.Renukunta@microsemi.com

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
---
 drivers/scsi/aacraid/aacraid.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 0ba8f61..8f90d9e 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -63,7 +63,7 @@ enum {
 #define	PMC_GLOBAL_INT_BIT0		0x00000001
 
 #ifndef AAC_DRIVER_BUILD
-# define AAC_DRIVER_BUILD 41052
+# define AAC_DRIVER_BUILD 41066
 # define AAC_DRIVER_BRANCH "-ms"
 #endif
 #define MAXIMUM_NUM_CONTAINERS	32

