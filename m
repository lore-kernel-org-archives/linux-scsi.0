From: Jesper Juhl <jj@chaosbits.net>
Subject: [PATCH] target: remove duplicate include of target/target_core_device.h
 from drivers/target/target_core_hba.c
Date: Mon, 17 Jan 2011 22:46:37 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1101172242510.27021@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from swampdragon.chaosbits.net ([90.184.90.115]:18816 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233Ab1AQVqg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Jan 2011 16:46:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: James Bottomley <James.Bottomley@suse.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "Nicholas A. Bellinger" <nab@kernel.org>, linux-scsi@vger.kernel.org

drivers/target/target_core_hba.c includes target/target_core_device.h 
twice - the two includes are even on two lines next to each other.
This patch removes the duplicate include.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 target_core_hba.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/target/target_core_hba.c b/drivers/target/target_core_hba.c
index 4bbe820..74d84f7 100644
--- a/drivers/target/target_core_hba.c
+++ b/drivers/target/target_core_hba.c
@@ -38,7 +38,6 @@
 
 #include <target/target_core_base.h>
 #include <target/target_core_device.h>
-#include <target/target_core_device.h>
 #include <target/target_core_tpg.h>
 #include <target/target_core_transport.h>
 

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

