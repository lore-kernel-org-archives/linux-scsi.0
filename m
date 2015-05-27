From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next] qla4xxx: add a missing include
Date: Tue, 26 May 2015 21:43:44 -0700
Message-ID: <1432701824.4060.346.camel@edumazet-glaptop2.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:33718 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbbE0Enr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 May 2015 00:43:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: netdev <netdev@vger.kernel.org>, linux-scsi@vger.kernel.org

From: Eric Dumazet <edumzet@google.com>

vmalloc.h used to be included from include/net/inet_hashtables.h
but it is no longer the case.

Fixes: 095dc8e0c368 ("tcp: fix/cleanup inet_ehash_locks_alloc()")
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Eric Dumazet <edumzet@google.com>
---
Given its broken in David net-next tree, its probably simpler
that David merges this fix directly ? Thanks !

 drivers/scsi/qla4xxx/ql4_def.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 8f6d0fb2cd807255a66e962c3cb7c4c8633d4d77..a7cfc270bd08a1f01867affc2dee0fc6b7611472 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -26,6 +26,7 @@
 #include <linux/mutex.h>
 #include <linux/aer.h>
 #include <linux/bsg-lib.h>
+#include <linux/vmalloc.h>
 
 #include <net/tcp.h>
 #include <scsi/scsi.h>


