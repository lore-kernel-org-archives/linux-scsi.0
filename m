From: Ferenc Wagner <wferi@niif.hu>
Subject: [PATCH] [SCSI] qla2xxx: Fix documentation of ql2xfdmienable module parameter
Date: Wed, 20 May 2009 17:40:53 +0200
Message-ID: <87pre3ixyy.fsf@tac.ki.iif.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tac.ki.iif.hu ([193.6.222.43]:56967 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755250AbZETPky (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 May 2009 11:40:54 -0400
Received: from wferi by tac.ki.iif.hu with local (Exim 4.69)
	(envelope-from <wferi@niif.hu>)
	id 1M6nuX-0003SQ-Ol
	for linux-scsi@vger.kernel.org; Wed, 20 May 2009 17:40:53 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The default is enabled since 7e47e5ca184548341a82eeb2238ee3622c43cae1.

Signed-off-by: Ferenc Wagner <wferi@niif.hu>
---
 drivers/scsi/qla2xxx/qla_os.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index e4fdcda..8f76b07 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -68,8 +68,8 @@ static void qla2x00_free_device(scsi_qla_host_t *);
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

