Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29F0EC00140
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Aug 2022 15:30:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbiHUPaT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 21 Aug 2022 11:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiHUPaS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Aug 2022 11:30:18 -0400
Received: from bg5.exmail.qq.com (bg4.exmail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB0F18B07;
        Sun, 21 Aug 2022 08:30:16 -0700 (PDT)
X-QQ-mid: bizesmtp90t1661095807twlq9kvv
Received: from localhost.localdomain ( [182.148.14.124])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sun, 21 Aug 2022 23:30:06 +0800 (CST)
X-QQ-SSF: 0100000000200020B000B00A0000000
X-QQ-FEAT: DWSCcwW/aQbg/0uL1BVZD34iDvIoDTznOfWLTduPAyIi1v6uwOqgp5WlF/ejt
        WgWNToNh+SYJxngi1c+3VDdWmiz73MPxEjWQJuy4BqE5t7P5GTigku3Kziuzr4rdOoOnF4J
        SuxdSKyZ8+/rGbpI/DgDbm0FLuGKjIhMz14EnEkMoCacdidRPLQrG/GVkBYLItE1Gyrb7Wv
        b7GF7tdZkMvMrK45M9NeH5YPRqho3IA+DLQJsztatTeMu3/mRJB8sgubU55v7tsy5X+t6fU
        O9orwh6zL86f7KspSi1LL65BswV40QIH97lymFJW0Bh03MdelQNHKHbSuxxo+q6XQ74gIHQ
        YTC+QVWqIUdXGYAXPhRv3HVIda/3R9SdBUr0jPn56IzN0tpG0M=
X-QQ-GoodBg: 0
From:   wangjianli <wangjianli@cdjrlc.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        wangjianli <wangjianli@cdjrlc.com>
Subject: [PATCH] scsi/csiostor: fix repeated words in comments
Date:   Sun, 21 Aug 2022 23:29:48 +0800
Message-Id: <20220821152948.3035-1-wangjianli@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

 Delete the redundant word 'of'.

Signed-off-by: wangjianli <wangjianli@cdjrlc.com>
---
 drivers/scsi/csiostor/csio_rnode.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/csiostor/csio_rnode.h b/drivers/scsi/csiostor/csio_rnode.h
index 433434221222..181c26fc0be0 100644
--- a/drivers/scsi/csiostor/csio_rnode.h
+++ b/drivers/scsi/csiostor/csio_rnode.h
@@ -66,7 +66,7 @@ struct csio_rnode_stats {
 	uint32_t	n_evt_fw[PROTO_ERR_IMPL_LOGO + 1];	/* fw events */
 	enum csio_rn_ev	n_evt_sm[CSIO_RNFE_MAX_EVENT];	/* State m/c events */
 	uint32_t	n_lun_rst;	/* Number of resets of
-					 * of LUNs under this
+					 * LUNs under this
 					 * target
 					 */
 	uint32_t	n_lun_rst_fail;	/* Number of LUN reset
-- 
2.36.1

