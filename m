From: <jayamohan.kallickal@emulex.com>
Subject: [PATCH 3/5]  be2iscsi: Set a timeout to FW
Date: Fri, 25 Mar 2011 14:23:59 -0700
Message-ID: <b6b1656c-1fdd-47a6-a6ab-f2097c6a9fa5@exht1.ad.emulex.com>
References: <1301088242-29477-1-git-send-email-jayamohan.kallickal@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:59774 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755221Ab1CYVZN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Mar 2011 17:25:13 -0400
In-Reply-To: <1301088242-29477-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

          Thi patch sets a timeout value within which the FW has
to respond

Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_cmds.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index 4ffcbf7..b8a82f2 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -458,6 +458,7 @@ void be_cmd_hdr_prepare(struct be_cmd_req_hdr *req_hdr,
 	req_hdr->opcode = opcode;
 	req_hdr->subsystem = subsystem;
 	req_hdr->request_length = cpu_to_le32(cmd_len - sizeof(*req_hdr));
+	req_hdr->timeout = 120;
 }
 
 static void be_cmd_page_addrs_prepare(struct phys_addr *pages, u32 max_pages,
-- 
1.7.4.1

