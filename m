From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 4/6] hpsa: remove unused struct request from CommandList
Date: Fri, 21 Feb 2014 16:25:10 -0600
Message-ID: <20140221222510.31344.59384.stgit@beardog.cce.hp.com>
References: <20140221222153.31344.99129.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:17900 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbaBUW0M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Feb 2014 17:26:12 -0500
Received: from g4t3427.houston.hp.com (g4t3427.houston.hp.com [15.201.208.55])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id 789D7CAB
	for <linux-scsi@vger.kernel.org>; Fri, 21 Feb 2014 22:26:05 +0000 (UTC)
In-Reply-To: <20140221222153.31344.99129.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa_cmd.h |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index 8026d2e..50388f1 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -386,7 +386,6 @@ struct CommandList {
 	int			   cmd_type;
 	long			   cmdindex;
 	struct list_head list;
-	struct request *rq;
 	struct completion *waiting;
 	void   *scsi_cmd;
 
@@ -399,8 +398,8 @@ struct CommandList {
  */
 #define IS_32_BIT ((8 - sizeof(long))/4)
 #define IS_64_BIT (!IS_32_BIT)
-#define PAD_32 (36)
-#define PAD_64 (4)
+#define PAD_32 (40)
+#define PAD_64 (12)
 #define COMMANDLIST_PAD (IS_32_BIT * PAD_32 + IS_64_BIT * PAD_64)
 	u8 pad[COMMANDLIST_PAD];
 };

