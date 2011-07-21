From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 071/103] target: remove the unused SCF_EMULATE_SYNC_CACHE flag
Date: Thu, 21 Jul 2011 00:11:54 -0700
Message-ID: <1311232346-6674-72-git-send-email-nab@linux-iscsi.org>
References: <1311232346-6674-63-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm2.bullet.mail.bf1.yahoo.com ([98.139.212.161]:23234 "HELO
	nm2.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752297Ab1GUHHS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:07:18 -0400
In-Reply-To: <1311232346-6674-63-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

From: Christoph Hellwig <hch@infradead.org>

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 include/target/target_core_base.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 72ef4b8..71abc4c 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -124,7 +124,6 @@ enum se_cmd_flags_table {
 	SCF_UNUSED			= 0x00100000,
 	SCF_PASSTHROUGH_CONTIG_TO_SG	= 0x00200000,
 	SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC = 0x00400000,
-	SCF_EMULATE_SYNC_CACHE		= 0x00800000,
 	SCF_EMULATE_CDB_ASYNC		= 0x01000000,
 };
 
-- 
1.7.6

