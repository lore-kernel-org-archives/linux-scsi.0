Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DB6AEB64DD
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jun 2023 01:31:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbjFVBbv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Jun 2023 21:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjFVBbu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jun 2023 21:31:50 -0400
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4C22122
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jun 2023 18:31:48 -0700 (PDT)
Received: from submission (posteo.de [185.67.36.169]) 
        by mout02.posteo.de (Postfix) with ESMTPS id 509EB240109
        for <linux-scsi@vger.kernel.org>; Thu, 22 Jun 2023 03:31:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
        t=1687397507; bh=PH1KTW93yxQOAMZiyGIfxED4MfP22HPHVIo76AOnWsE=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:
         Content-Transfer-Encoding:From;
        b=ZaGMfBO1YJLW8Sr8W75zXhOIWFQqgWxhgUwx3dVLxNirgYBOgEnx71Wf3xizT7rfO
         MS75mCaPfxV3qSm/zb+tvlF5E+YtiO6l6LrWJQsUqFDUXZYgR0c4pFgVYiKvcluMvo
         Zaj+w4xxY6j8P5ciaM49J4o9l9Xt1G2KcIFlnMZbGkVbzOcNB4yETjBuxR2ozg7U8S
         fhpedcdLW0BIFZkCJcDcyDI7TEUwqLL+BEoCHi2AWFQW716yvjoJkDo620NAPLomPH
         rDY79yhK+3ZRTUbN4j9iAuX2KNN9d8qxlzWNlmUlN69sbJPX884GZLWX2v3LvJBzDc
         b7lq8aX1eqnLA==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4QmjWw0Ntlz6twX;
        Thu, 22 Jun 2023 03:31:39 +0200 (CEST)
From:   Yueh-Shun Li <shamrocklee@posteo.net>
To:     Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@kernel.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andy Whitcroft <apw@canonical.com>,
        Joe Perches <joe@perches.com>
Cc:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-scsi@vger.kernel.org,
        mptcp@lists.linux.dev, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yueh-Shun Li <shamrocklee@posteo.net>
Subject: [PATCH 2/8] i40e, xsk: fix comment typo
Date:   Thu, 22 Jun 2023 01:26:25 +0000
Message-Id: <20230622012627.15050-3-shamrocklee@posteo.net>
In-Reply-To: <20230622012627.15050-1-shamrocklee@posteo.net>
References: <20230622012627.15050-1-shamrocklee@posteo.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Spell "transmission" properly.

Found by searching for keyword "tranm".

Signed-off-by: Yueh-Shun Li <shamrocklee@posteo.net>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index cd7b52fb6b46..05ec1181471e 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -582,7 +582,7 @@ static void i40e_clean_xdp_tx_buffer(struct i40e_ring *tx_ring,
  * @vsi: Current VSI
  * @tx_ring: XDP Tx ring
  *
- * Returns true if cleanup/tranmission is done.
+ * Returns true if cleanup/transmission is done.
  **/
 bool i40e_clean_xdp_tx_irq(struct i40e_vsi *vsi, struct i40e_ring *tx_ring)
 {
-- 
2.38.1

