From: Joe Perches <joe@perches.com>
Subject: [PATCH 06/10] drivers/scsi/qla2xxx/qua_os.c: Fix continuation line formats
Date: Mon,  1 Feb 2010 23:22:12 -0800
Message-ID: <0a97686bba6798d01420fdd9536e25324242b3c8.1265095094.git.joe@perches.com>
References: <cover.1265095093.git.joe@perches.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:1773 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755530Ab0BBHWX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Feb 2010 02:22:23 -0500
In-Reply-To: <cover.1265095093.git.joe@perches.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-driver@qlogic.com, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

String constants that are continued on subsequent lines with \
are not good.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 8529eb1..134ed38 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -88,8 +88,8 @@ int ql2xmaxqueues = 1;
 module_param(ql2xmaxqueues, int, S_IRUGO|S_IRUSR);
 MODULE_PARM_DESC(ql2xmaxqueues,
 		"Enables MQ settings "
-		"Default is 1 for single queue. Set it to number \
-			of queues in MQ mode.");
+		"Default is 1 for single queue. Set it to number "
+		"of queues in MQ mode.");
 
 int ql2xmultique_tag;
 module_param(ql2xmultique_tag, int, S_IRUGO|S_IRUSR);
-- 
1.6.6.rc0.57.gad7a

