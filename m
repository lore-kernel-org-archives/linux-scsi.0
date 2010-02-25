From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 9/9] hpsa: remove unused members next, prev,
	and retry_count from command list structure.
Date: Thu, 25 Feb 2010 14:03:32 -0600
Message-ID: <20100225200332.7508.78534.stgit@beardog.cce.hp.com>
References: <20100225200125.7508.11486.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0029.austin.hp.com ([15.216.28.36]:11529 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933565Ab0BYUAX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2010 15:00:23 -0500
In-Reply-To: <20100225200125.7508.11486.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: james.bottomley@suse.de, mikem@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: remove unused members next, prev, and retry_count from command list structure.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa_cmd.h |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index cb0c238..56fb982 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -306,11 +306,8 @@ struct CommandList {
 	int			   cmd_type;
 	long			   cmdindex;
 	struct hlist_node list;
-	struct CommandList *prev;
-	struct CommandList *next;
 	struct request *rq;
 	struct completion *waiting;
-	int	 retry_count;
 	void   *scsi_cmd;
 
 /* on 64 bit architectures, to get this to be 32-byte-aligned
@@ -322,8 +319,8 @@ struct CommandList {
  */
 #define IS_32_BIT ((8 - sizeof(long))/4)
 #define IS_64_BIT (!IS_32_BIT)
-#define PAD_32 (24)
-#define PAD_64 (16)
+#define PAD_32 (4)
+#define PAD_64 (4)
 #define COMMANDLIST_PAD (IS_32_BIT * PAD_32 + IS_64_BIT * PAD_64)
 	u8 pad[COMMANDLIST_PAD];
 };

