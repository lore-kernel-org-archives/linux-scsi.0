From: Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH] SCSI: fix qla4xxx build on PPC
Date: Tue, 14 Sep 2010 14:12:54 +0200
Message-ID: <1284466375-9501-1-git-send-email-jslaby@suse.cz>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.pripojeni.net ([217.66.174.14]:42657 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab0INMNG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Sep 2010 08:13:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: iscsi-driver@qlogic.com, linux-scsi@vger.kernel.org, jirislaby@gmail.com, linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>, Ravi Anand <ravi.anand@qlogic.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>

We use read/write[bslq] but do not include linux/io.h. This causes
build failures on PPC. Include that file.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Ravi Anand <ravi.anand@qlogic.com>
Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_nx.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index 5d4a382..449256f 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -5,6 +5,7 @@
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
 #include <linux/delay.h>
+#include <linux/io.h>
 #include <linux/pci.h>
 #include "ql4_def.h"
 #include "ql4_glbl.h"
-- 
1.7.2.2


