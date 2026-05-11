Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655D23BD62E;
	Mon, 11 May 2026 09:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778491856; cv=none; b=ZXW3XJndJYsjgBgdmWpKnelNK7hugrztEavCNU/oZTJX7jhjdp54x3VE2mM7NHy1HzqTspqa46T5ZOvO7j9z1LDi7fnpMJxBosJC8glhl7AxEtClXNUVQALb/93EaJi0gyRguUTr6DOT13lrkEMvwvy11uI+Sm6s959BTe6sCus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778491856; c=relaxed/simple;
	bh=dj4aT6QpHPSIaM17HPyJIvAPehLgsCjuFm22ZUOGVlY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=REl2BOm6a5vpp5Ab12r72omqiOOYTbzBT1gPQUaklS/gW9ZRoTYg/kt7IQzFY5VzinUg7I257sUsZI6JuAG/zqcG2Pv8u/XcGkskYgfqCCBC1tmjEYNuha/4GeIXyGFM+watdxKDMWRhiny1cUvhG9RDl75DiuTphNQghvBL5Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 1677c2d04d1c11f1aa26b74ffac11d73-20260511
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_DIGIT_LEN
	HR_FROM_NAME, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_UNTRUSTED
	SA_UNFAMILIAR, SN_UNTRUSTED, SN_UNFAMILIAR, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:d867f768-f4f4-4126-8e4e-a34331abccf8,IP:15,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:20
X-CID-INFO: VERSION:1.3.12,REQID:d867f768-f4f4-4126-8e4e-a34331abccf8,IP:15,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:20
X-CID-META: VersionHash:e7bac3a,CLOUDID:3a8de05712aef74353ddd8b23e325daf,BulkI
	D:260511172531NXW53NA9,BulkQuantity:1,Recheck:0,SF:19|38|66|72|78|102|127|
	850|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:40,
	QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
	,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1677c2d04d1c11f1aa26b74ffac11d73-20260511
X-User: wangyan01@kylinos.cn
Received: from localhost.localdomain [(116.128.244.171)] by mailgw.kylinos.cn
	(envelope-from <wangyan01@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 37717181; Mon, 11 May 2026 17:30:45 +0800
From: Wang Yan <wangyan01@kylinos.cn>
To: lduncan@suse.com,
	cleech@redhat.com,
	michael.christie@oracle.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: open-iscsi@googlegroups.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wang Yan <wangyan01@kylinos.cn>
Subject: [PATCH] scsi: libiscsi: fix spelling and format errors
Date: Mon, 11 May 2026 17:30:30 +0800
Message-Id: <20260511093030.63542-1-wangyan01@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix two issues in libiscsi.c:
- Correct typo "numer" to "number" in iscsi_session_setup() comment
- Fix format string "seconds\n." to "seconds.\n" in recv timeout warning

Signed-off-by: Wang Yan <wangyan01@kylinos.cn>
---
 drivers/scsi/libiscsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 25857d6ed6e8..160f02f2f51d 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -3012,7 +3012,7 @@ static void iscsi_host_dec_session_cnt(struct Scsi_Host *shost)
  * This can be used by software iscsi_transports that allocate
  * a session per scsi host.
  *
- * Callers should set cmds_max to the largest total numer (mgmt + scsi) of
+ * Callers should set cmds_max to the largest total number (mgmt + scsi) of
  * tasks they support. The iscsi layer reserves ISCSI_MGMT_CMDS_MAX tasks
  * for nop handling and login/logout requests.
  */
@@ -3307,7 +3307,7 @@ int iscsi_conn_start(struct iscsi_cls_conn *cls_conn)
 
 	if (conn->ping_timeout && !conn->recv_timeout) {
 		iscsi_conn_printk(KERN_ERR, conn, "invalid recv timeout of "
-				  "zero. Using 5 seconds\n.");
+				  "zero. Using 5 seconds.\n");
 		conn->recv_timeout = 5;
 	}
 
-- 
2.25.1

