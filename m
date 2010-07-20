From: akpm@linux-foundation.org
Subject: [patch 15/27] drivers/scsi/qla2xxx/qla_os.c: fix continuation line formats
Date: Tue, 20 Jul 2010 15:28:55 -0700
Message-ID: <201007202228.o6KMSts6021758@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34395 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932733Ab0GTWix (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2010 18:38:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, joe@perches.com, James.Bottomley@suse.de, anirban.chakraborty@qlogic.com, giridhar.malavali@qlogic.com

From: Joe Perches <joe@perches.com>

String constants that are continued on subsequent lines with \ will cause
spurious whitespace in the resulting output.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>
Cc: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/qla2xxx/qla_os.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/qla2xxx/qla_os.c~drivers-scsi-qla2xxx-qla_osc-fix-continuation-line-formats drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c~drivers-scsi-qla2xxx-qla_osc-fix-continuation-line-formats
+++ a/drivers/scsi/qla2xxx/qla_os.c
@@ -115,8 +115,8 @@ int ql2xmaxqueues = 1;
 module_param(ql2xmaxqueues, int, S_IRUGO|S_IRUSR);
 MODULE_PARM_DESC(ql2xmaxqueues,
 		"Enables MQ settings "
-		"Default is 1 for single queue. Set it to number \
-			of queues in MQ mode.");
+		"Default is 1 for single queue. Set it to number "
+		"of queues in MQ mode.");
 
 int ql2xmultique_tag;
 module_param(ql2xmultique_tag, int, S_IRUGO|S_IRUSR);
_
