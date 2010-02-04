From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 24/30] hpsa: print all the bytes of the CDB,
	not just the first one.
Date: Thu, 04 Feb 2010 08:43:26 -0600
Message-ID: <20100204144326.10406.73539.stgit@beardog.cce.hp.com>
References: <20100204144012.10406.14868.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0027.austin.hp.com ([15.216.28.34]:20963 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933073Ab0BDOki (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2010 09:40:38 -0500
In-Reply-To: <20100204144012.10406.14868.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org
Cc: mikem@beardog.cce.hp.com, brace@beardog.cce.hp.com, matthew.gates@hp.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

From: Mike Miller <mikem@beardog.cce.hp.com>

hpsa: print all the bytes of the CDB, not just the first one.

Signed-off-by: Mike Miller <mikem@beardog.cce.hp.com>
Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index db12bc2..b91ccd4 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1061,6 +1061,7 @@ static void complete_scsi_command(struct CommandList *cp,
 					"Sense: 0x%x, ASC: 0x%x, ASCQ: 0x%x, "
 					"Returning result: 0x%x, "
 					"cmd=[%02x %02x %02x %02x %02x "
+					"%02x %02x %02x %02x %02x %02x "
 					"%02x %02x %02x %02x %02x]\n",
 					cp, sense_key, asc, ascq,
 					cmd->result,
@@ -1068,7 +1069,10 @@ static void complete_scsi_command(struct CommandList *cp,
 					cmd->cmnd[2], cmd->cmnd[3],
 					cmd->cmnd[4], cmd->cmnd[5],
 					cmd->cmnd[6], cmd->cmnd[7],
-					cmd->cmnd[8], cmd->cmnd[9]);
+					cmd->cmnd[8], cmd->cmnd[9],
+					cmd->cmnd[10], cmd->cmnd[11],
+					cmd->cmnd[12], cmd->cmnd[13],
+					cmd->cmnd[14], cmd->cmnd[15]);
 			break;
 		}
 

