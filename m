From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 5/5] target: remove the unused SCF_EMULATE_SYNC_CACHE flag
Date: Tue, 31 May 2011 17:06:46 -0400
Message-ID: <20110531210703.435251102@bombadil.infradead.org>
References: <20110531210641.032149131@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:42340
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932541Ab1EaVHE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 May 2011 17:07:04 -0400
Content-Disposition: inline; filename=lio-kill-SCF_EMULATE_SYNC_CACHE
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: lio-core/include/target/target_core_base.h
===================================================================
--- lio-core.orig/include/target/target_core_base.h	2011-06-01 05:59:16.046628596 +0900
+++ lio-core/include/target/target_core_base.h	2011-06-01 05:59:26.786629321 +0900
@@ -124,7 +124,6 @@ enum se_cmd_flags_table {
 	SCF_UNUSED			= 0x00100000,
 	SCF_PASSTHROUGH_CONTIG_TO_SG	= 0x00200000,
 	SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC = 0x00400000,
-	SCF_EMULATE_SYNC_CACHE		= 0x00800000,
 	SCF_EMULATE_CDB_ASYNC		= 0x01000000,
 };
 

