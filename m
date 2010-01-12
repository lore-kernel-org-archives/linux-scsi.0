From: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
Subject: [PATCH] lpfc: fix typo of LOG_SECURITY
Date: Tue, 12 Jan 2010 19:57:09 +0900
Message-ID: <4B4C5585.9030603@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51050 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033Ab0ALK5b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2010 05:57:31 -0500
Received: from m2.gw.fujitsu.co.jp ([10.0.50.72])
	by fgwmail7.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id o0CAvT21022292
	for <linux-scsi@vger.kernel.org> (envelope-from tokunaga.keiich@jp.fujitsu.com);
	Tue, 12 Jan 2010 19:57:30 +0900
Received: from smail (m2 [127.0.0.1])
	by outgoing.m2.gw.fujitsu.co.jp (Postfix) with ESMTP id CC83345DE51
	for <linux-scsi@vger.kernel.org>; Tue, 12 Jan 2010 19:57:29 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by m2.gw.fujitsu.co.jp (Postfix) with ESMTP id A8B0B45DE4F
	for <linux-scsi@vger.kernel.org>; Tue, 12 Jan 2010 19:57:29 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 59B38E78001
	for <linux-scsi@vger.kernel.org>; Tue, 12 Jan 2010 19:57:29 +0900 (JST)
Received: from m021.s.css.fujitsu.com (m021.s.css.fujitsu.com [10.0.81.61])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 16C1D1DB8038
	for <linux-scsi@vger.kernel.org>; Tue, 12 Jan 2010 19:57:29 +0900 (JST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@suse.de>, James Smart <James.Smart@Emulex.Com>, Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>

Hi,

Fix a typo emerged at this commit:

  f4b4c68f74dcd5da03df851090cad28ad4e8d7cc

Obviously, no one is using it now, but someone probably will.

Signed-off-by: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
---
 drivers/scsi/lpfc/lpfc_logmsg.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_logmsg.h b/drivers/scsi/lpfc/lpfc_logmsg.h
index 954ba57..f8370cb 100644
--- a/drivers/scsi/lpfc/lpfc_logmsg.h
+++ b/drivers/scsi/lpfc/lpfc_logmsg.h
@@ -33,7 +33,7 @@
 #define LOG_FCP_ERROR	0x00001000	/* log errors, not underruns */
 #define LOG_LIBDFC	0x00002000	/* Libdfc events */
 #define LOG_VPORT	0x00004000	/* NPIV events */
-#define LOF_SECURITY	0x00008000	/* Security events */
+#define LOG_SECURITY	0x00008000	/* Security events */
 #define LOG_EVENT	0x00010000	/* CT,TEMP,DUMP, logging */
 #define LOG_ALL_MSG	0xffffffff	/* LOG all messages */



