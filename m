From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: message: fusion: remove redundant assignment to variable ret
Date: Thu,  4 Jul 2019 14:36:24 +0100
Message-ID: <20190704133624.31081-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable ret is being initialized with a value that is never
read and it is being updated later with a new value. The
initialization is redundant and can be removed.  Also move { brace
to the conventional coding style location.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/message/fusion/mptbase.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index c2dd322691d1..449916e062ce 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -7106,8 +7106,9 @@ mpt_SoftResetHandler(MPT_ADAPTER *ioc, int sleepFlag)
  *	HardReset.
  **/
 int
-mpt_Soft_Hard_ResetHandler(MPT_ADAPTER *ioc, int sleepFlag) {
-	int ret = -1;
+mpt_Soft_Hard_ResetHandler(MPT_ADAPTER *ioc, int sleepFlag)
+{
+	int ret;
 
 	ret = mpt_SoftResetHandler(ioc, sleepFlag);
 	if (ret == 0)
-- 
2.20.1
