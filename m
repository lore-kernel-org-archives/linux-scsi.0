Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C8C9C4167E
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Mar 2022 12:47:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235711AbiCNMtB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Mar 2022 08:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238740AbiCNMr5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Mar 2022 08:47:57 -0400
Received: from mail2-relais-roc.national.inria.fr (mail2-relais-roc.national.inria.fr [192.134.164.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4383D39819;
        Mon, 14 Mar 2022 05:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8mOJDVdwdSGZCFGEhAfw8ieBt5NQ/WrYJfTx+uv/2Yo=;
  b=P6zDPohhNOgVWb8eK2c2vfZqOV46Gdj57qZ32dK8svwy7rCQuAKbeq9K
   5irf5y2N6r8sOHuCtkFtuL72NsRXbedp5oYp7bahkVYTd4P+RhJ++uVDh
   5/hiTTacqPYq2jxs/sEv9Vq08CsY9UeEM3zN3jpeWt/QbbbtDehRf7dg6
   M=;
Authentication-Results: mail2-relais-roc.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=Julia.Lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="5.90,180,1643670000"; 
   d="scan'208";a="25997350"
Received: from i80.paris.inria.fr (HELO i80.paris.inria.fr.) ([128.93.90.48])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2022 12:54:00 +0100
From:   Julia Lawall <Julia.Lawall@inria.fr>
To:     James Smart <james.smart@broadcom.com>
Cc:     kernel-janitors@vger.kernel.org,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 17/30] scsi: elx: libefc_sli: fix typos in comments
Date:   Mon, 14 Mar 2022 12:53:41 +0100
Message-Id: <20220314115354.144023-18-Julia.Lawall@inria.fr>
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
 drivers/scsi/elx/libefc_sli/sli4.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/elx/libefc_sli/sli4.c b/drivers/scsi/elx/libefc_sli/sli4.c
index 3ea57bd6fb0a..b8c048cdb17f 100644
--- a/drivers/scsi/elx/libefc_sli/sli4.c
+++ b/drivers/scsi/elx/libefc_sli/sli4.c
@@ -4127,7 +4127,7 @@ sli_calc_max_qentries(struct sli4 *sli4)
 						  sli4->qinfo.count_mask[q]);
 	}
 
-	/* single, continguous DMA allocations will be called for each queue
+	/* single, contiguous DMA allocations will be called for each queue
 	 * of size (max_qentries * queue entry size); since these can be large,
 	 * check against the OS max DMA allocation size
 	 */

