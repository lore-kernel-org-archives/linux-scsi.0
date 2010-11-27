From: Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH] [SCSI] megaraid_sas: Declare poll_aen_lock as static
Date: Sat, 27 Nov 2010 21:37:15 +0000
Message-ID: <1290893835.3292.44.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55129 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752954Ab0K0VhX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Nov 2010 16:37:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>, linux-scsi@vger.kernel.org

There is no reason for this to be extern.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/megaraid/megaraid_sas.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.c b/drivers/scsi/megaraid/megaraid_sas.c
index 7451bc0..7050a88 100644
--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -115,7 +115,7 @@ static u32 megasas_dbg_lvl;
 static u32 support_device_change;
 
 /* define lock for aen poll */
-spinlock_t poll_aen_lock;
+static spinlock_t poll_aen_lock;
 
 static void
 megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
-- 
1.7.2.3


-- 
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.
