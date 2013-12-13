From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH 1/3] drivers: message: Mark function mpt_SoftResetHandler()
 as static in mptbase.c
Date: Fri, 13 Dec 2013 11:33:11 +0530
Message-ID: <0a6b017550306ed600769dbe4fac868aa88cd9d6.1386914148.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, support@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, josh@joshtriplett.org
List-Id: linux-scsi@vger.kernel.org

This patch marks the function mpt_SoftResetHandler() as static in mptba=
se.c
because it is not used outside this file.

Thus, it also eliminates the following warning in fusion/mptbase.c:
drivers/message/fusion/mptbase.c:7011:1: warning: no previous prototype=
 for =E2=80=98mpt_SoftResetHandler=E2=80=99 [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 drivers/message/fusion/mptbase.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/=
mptbase.c
index 767ff4d..c783a42 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -7007,7 +7007,7 @@ EXPORT_SYMBOL(mpt_halt_firmware);
  *	IOC doesn't reply to any outstanding request. This will transfer IO=
C
  *	to READY state.
  **/
-int
+static int
 mpt_SoftResetHandler(MPT_ADAPTER *ioc, int sleepFlag)
 {
 	int		 rc;
--=20
1.7.9.5
