From: Hariprasad S <hariprasad@chelsio.com>
Subject: RE: [PATCH] csiostor:Make the function csio_ln_prep_ecwr have a
 return type of void
Date: Mon, 6 Jul 2015 13:41:09 +0000
Message-ID: <26E3F92EC670BD429DB5CB319D773C13CC89A4@nice.asicdesigners.com>
References: <1436141180-12872-1-git-send-email-xerofoify@gmail.com>
 <525DB349B3FB5444AE057A887CB2A8D8E9913C@nice.asicdesigners.com>,<559A7AD9.4080907@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <559A7AD9.4080907@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: nick <xerofoify@gmail.com>, Anish Bhatt <anish@chelsio.com>, "JBottomley@odin.com" <JBottomley@odin.com>
Cc: "davem@davemloft.net" <davem@davemloft.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Nick,

Its been pushed a while ago to net-next tree.

commit 661b689bbd2e9392c3d9935e791af75ddbc455dc
Author: Hariprasad Shenai <hariprasad@chelsio.com>
Date:   Mon Jun 1 20:07:41 2015 +0530

    cxgb4: remove unused fn to enable/disable db coalescing
    
    Remove unused function cxgb4_enable_db_coalescing() and
    cxgb4_disable_db_coalescing()
    
    Signed-off-by: Hariprasad Shenai <hariprasad@chelsio.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

Thanks,
Hari

________________________________________
From: nick [xerofoify@gmail.com]
Sent: Monday, July 06, 2015 6:25 PM
To: Anish Bhatt; JBottomley@odin.com
Cc: davem@davemloft.net; Hariprasad S; linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] csiostor:Make the function csio_ln_prep_ecwr have a return type of void

On 2015-07-05 09:39 PM, Anish Bhatt wrote:
> Acked-by: Anish Bhatt <anish@chelsio.com>
>
Anish,
I also have this patch for your networking drivers lying around and was unable to get in
merged by the maintainer:
>From 1201c4b502ec8faef8cd4c3a6ee9dbd7d386d9cf Mon Sep 17 00:00:00 2001
From: Nicholas Krause <xerofoify@gmail.com>
Date: Sun, 7 Jun 2015 20:50:43 -0400
Subject: [RESEND PATCH] chelsio:Remove unused functions from the file, cxgb4_main.c

This removes the no longer used functions, cxgb4_enable_db_coalescing
and cxgb4_disable_db_coalescing plus the exporting of them as symbols
due to having no more users/callers of these particular functions.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 803d91b..f996443 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -2042,25 +2042,6 @@ out:
 }
 EXPORT_SYMBOL(cxgb4_sync_txq_pidx);

-void cxgb4_disable_db_coalescing(struct net_device *dev)
-{
-       struct adapter *adap;
-
-       adap = netdev2adap(dev);
-       t4_set_reg_field(adap, SGE_DOORBELL_CONTROL_A, NOCOALESCE_F,
-                        NOCOALESCE_F);
-}
-EXPORT_SYMBOL(cxgb4_disable_db_coalescing);
-
-void cxgb4_enable_db_coalescing(struct net_device *dev)
-{
-       struct adapter *adap;
-
-       adap = netdev2adap(dev);
-       t4_set_reg_field(adap, SGE_DOORBELL_CONTROL_A, NOCOALESCE_F, 0);
-}
-EXPORT_SYMBOL(cxgb4_enable_db_coalescing);
-
 int cxgb4_read_tpte(struct net_device *dev, u32 stag, __be32 *tpte)
 {
        struct adapter *adap;
--
2.1.4
If you can merge it or get in contact with the maintainer to apply in to their tree that would be
great.
Thanks,
Nick
