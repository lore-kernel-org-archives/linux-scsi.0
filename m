From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: [PATCH 1/6] ibmvscsi: Correct values for several viosrp_crq_format enums
Date: Wed,  3 Feb 2016 17:28:29 -0600
Message-ID: <1454542114-1797-2-git-send-email-tyreld@linux.vnet.ibm.com>
References: <1454542114-1797-1-git-send-email-tyreld@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1454542114-1797-1-git-send-email-tyreld@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, nfont@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, hare@suse.de, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

The enum values for VIOSRP_LINUX_FORMAT and VIOSRP_INLINE_FORMAT are
off by one. They are currently defined as 0x06 and 0x07 respetively.
These values are defined in PAPR correctly as 0x05 and 0x06. This
inconsistency has gone unnoticed as neither enum is currently used.
The possible future support of PING messages between the VIOS and
client adapter relies on VIOSRP_INLINE_FORMAT crq messages.
Corrected these enum values to match PAPR definitions.

Signed-off-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/viosrp.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/viosrp.h b/drivers/scsi/ibmvscsi/viosrp.h
index 1162430..d1044e9 100644
--- a/drivers/scsi/ibmvscsi/viosrp.h
+++ b/drivers/scsi/ibmvscsi/viosrp.h
@@ -56,8 +56,8 @@ enum viosrp_crq_formats {
 	VIOSRP_MAD_FORMAT = 0x02,
 	VIOSRP_OS400_FORMAT = 0x03,
 	VIOSRP_AIX_FORMAT = 0x04,
-	VIOSRP_LINUX_FORMAT = 0x06,
-	VIOSRP_INLINE_FORMAT = 0x07
+	VIOSRP_LINUX_FORMAT = 0x05,
+	VIOSRP_INLINE_FORMAT = 0x06
 };
 
 enum viosrp_crq_status {
-- 
2.5.0
