Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63623C00140
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Aug 2022 15:29:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbiHUP3Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 21 Aug 2022 11:29:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiHUP3X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Aug 2022 11:29:23 -0400
Received: from bg5.exmail.qq.com (bg4.exmail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A49CDB9;
        Sun, 21 Aug 2022 08:29:19 -0700 (PDT)
X-QQ-mid: bizesmtp91t1661095751tz6ioar2
Received: from localhost.localdomain ( [182.148.14.124])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sun, 21 Aug 2022 23:29:10 +0800 (CST)
X-QQ-SSF: 0100000000200020B000B00A0000000
X-QQ-FEAT: 7jw2iSiCazrpwrDKwieX+ylC7fHYLkyOVKfHrhG80HAJ72BREx/kBd1JZ1t5s
        PPgCWS3e1f4tEcwu17GFNHeUaGTEuQIxdvyD+Hu/JqiguLv2BYZhw1QPhMk8AqEFyEgtqEu
        6Irars0FciqeKw5AFSeRpg5OIkQMrrkQt4eSUcDA1W7cJ0L/o0rTnvsaF9FiGkRP3KZwEPa
        weVpcKbts+GLkTKY3q3cyxKQ1foPWKAH1Xatz0dXBLl8ITuU+zb+GI//yraaqZfmXpgGjyR
        3mAStgrR74ljOrgdtn508MZo6hTwA88Om+Y7Scg89NFy3rFs+toITSESuXeC6b6rbMCEpTL
        Kty5ZN31Qz6NYWrl5RRYFTwEyU4q48xsgJR5Fou7aiJt2QP7mY=
X-QQ-GoodBg: 0
From:   wangjianli <wangjianli@cdjrlc.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        wangjianli <wangjianli@cdjrlc.com>
Subject: [PATCH] scsi/csiostor: fix repeated words in comments
Date:   Sun, 21 Aug 2022 23:28:53 +0800
Message-Id: <20220821152853.2018-1-wangjianli@cdjrlc.com>
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

