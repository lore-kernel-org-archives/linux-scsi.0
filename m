From: Ferenc Wagner <wferi@niif.hu>
Subject: [PATCH] [SCSI] qla2xxx: Fix documentation of ql2xfdmienable module parameter
Date: Sun, 26 Oct 2008 23:52:42 +0100
Message-ID: <874p2zq891.fsf@szonett.ki.iif.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tac.ki.iif.hu ([193.6.222.43]:42588 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752738AbYJZWws (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Oct 2008 18:52:48 -0400
Received: from [10.0.0.3] (helo=szonett.ki.iif.hu)
	by tac.ki.iif.hu with esmtpsa (TLS-1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.63)
	(envelope-from <wferi@niif.hu>)
	id 1KuETV-0007vp-Lx
	for linux-scsi@vger.kernel.org; Sun, 26 Oct 2008 23:52:46 +0100
Received: from wferi by szonett.ki.iif.hu with local (Exim 4.63)
	(envelope-from <wferi@szonett.ki.iif.hu>)
	id 1KuETS-0007tJ-Ad
	for linux-scsi@vger.kernel.org; Sun, 26 Oct 2008 23:52:42 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The default is enabled since 7e47e5ca184548341a82eeb2238ee3622c43cae1.

Signed-off-by: Ferenc Wagner <wferi@niif.hu>
---
 drivers/scsi/qla2xxx/qla_os.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 3433441..764ef8d 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -70,8 +70,8 @@ static void qla2x00_config_dma_addressing(scsi_qla_host_t *ha);
 int ql2xfdmienable=1;
 module_param(ql2xfdmienable, int, S_IRUGO|S_IRUSR);
 MODULE_PARM_DESC(ql2xfdmienable,
-		"Enables FDMI registratons "
-		"Default is 0 - no FDMI. 1 - perfom FDMI.");
+		"Enables FDMI registrations. "
+		"0 - no FDMI. Default is 1 - perform FDMI.");
 
 #define MAX_Q_DEPTH    32
 static int ql2xmaxqdepth = MAX_Q_DEPTH;
-- 
1.5.6.5
