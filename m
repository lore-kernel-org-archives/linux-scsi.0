Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F563C43217
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Mar 2022 12:21:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241399AbiCNMWh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Mar 2022 08:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243871AbiCNMVV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Mar 2022 08:21:21 -0400
Received: from mail2-relais-roc.national.inria.fr (mail2-relais-roc.national.inria.fr [192.134.164.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF8A1E63;
        Mon, 14 Mar 2022 05:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=p+CikC4X47ZG7b8MRH9xWwSSqybVMgqq5WbmVhupRyE=;
  b=mFjBt77DK8FJmsGr2gkx0PLeVEaq7KSzeWXoSpQZS/+fKLbCsM0a9woJ
   vvm29KaiFbwkCsvyLPiPtC3D4fH3n+DvCyL3tRtiD9w957x3GjlJxnYHD
   pBLOyNfG0ExaYV15uWdg0LIt5O7xv48qADyMyUsdNJm6+3Ck3+vH6iq0G
   I=;
Authentication-Results: mail2-relais-roc.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=Julia.Lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="5.90,180,1643670000"; 
   d="scan'208";a="25997358"
Received: from i80.paris.inria.fr (HELO i80.paris.inria.fr.) ([128.93.90.48])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2022 12:54:00 +0100
From:   Julia Lawall <Julia.Lawall@inria.fr>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     kernel-janitors@vger.kernel.org,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 24/30] scsi: qla2xxx: fix typos in comments
Date:   Mon, 14 Mar 2022 12:53:48 +0100
Message-Id: <20220314115354.144023-25-Julia.Lawall@inria.fr>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220314115354.144023-1-Julia.Lawall@inria.fr>
References: <20220314115354.144023-1-Julia.Lawall@inria.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Various spelling mistakes in comments.
Detected with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

---
 drivers/scsi/qla2xxx/qla_gs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index a812f4a45232..717141afb439 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1767,7 +1767,7 @@ qla2x00_hba_attributes(scsi_qla_host_t *vha, void *entries,
 	size += alen;
 	ql_dbg(ql_dbg_disc, vha, 0x20aa,
 	    "CT PAYLOAD LENGTH = 0x%x.\n", be32_to_cpu(eiter->a.max_ct_len));
-	/* Node Sybolic Name */
+	/* Node Symbolic Name */
 	eiter = entries + size;
 	eiter->type = cpu_to_be16(FDMI_HBA_NODE_SYMBOLIC_NAME);
 	alen = qla2x00_get_sym_node_name(vha, eiter->a.sym_name,

