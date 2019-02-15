From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] scsi: aacraid: Fix missing break in switch statement
Date: Fri, 15 Feb 2019 15:42:42 -0600
Message-ID: <20190215214242.GA8393@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@microsemi.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Kees Cook <keescook@chromium.org>
List-Id: linux-scsi@vger.kernel.org

Add missing break statement and fix identation issue.

This bug was found thanks to the ongoing efforts to enable
-Wimplicit-fallthrough.

Fixes: 9cb62fa24e0d ("aacraid: Log firmware AIF messages")
Cc: stable@vger.kernel.org
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/scsi/aacraid/commsup.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 0bdc6b0f725f..e67e032936ef 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1303,8 +1303,9 @@ static void aac_handle_aif(struct aac_dev * dev, struct fib * fibptr)
 				  ADD : DELETE;
 				break;
 			}
-			case AifBuManagerEvent:
-				aac_handle_aif_bu(dev, aifcmd);
+			break;
+		case AifBuManagerEvent:
+			aac_handle_aif_bu(dev, aifcmd);
 			break;
 		}
 
-- 
2.20.1
