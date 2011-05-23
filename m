From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] MAINTAINERS: Add drivers/target/ entry
Date: Mon, 23 May 2011 13:56:26 -0700
Message-ID: <1306184186-11551-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm21-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.176]:20172
	"HELO nm21-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752532Ab1EWU5H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 May 2011 16:57:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-next <linux-next@vger.kernel.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Stephen Rothwell <sfr@canb.auug.org.au>, James Bottomley <James.Bottomley@HansenPartnership.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 MAINTAINERS |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 20be668..a831859 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6039,6 +6039,16 @@ F:	Documentation/accounting/taskstats*
 F:	include/linux/taskstats*
 F:	kernel/taskstats.c
 
+TARGET SUBSYSTEM
+M:	Nicholas A. Bellinger <nab@linux-iscsi.org>
+L:	linux-scsi@vger.kernel.org
+L:	http://groups.google.com/group/linux-iscsi-target-dev
+W:	http://www.linux-iscsi.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/nab/lio-core-2.6.git master
+S:	Supported
+F:	drivers/target/
+F:	include/target/
+
 TC CLASSIFIER
 M:	Jamal Hadi Salim <hadi@cyberus.ca>
 L:	netdev@vger.kernel.org
-- 
1.7.5.2

