Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABF39C433E2
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 06:58:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93C82221ED
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 06:58:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbgGNG6L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 02:58:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:34884 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725945AbgGNG6J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Jul 2020 02:58:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 400D6AEAA;
        Tue, 14 Jul 2020 06:58:10 +0000 (UTC)
Subject: Re: [PATCH v2 04/29] scsi: fcoe: fcoe: Fix various kernel-doc
 infringements
To:     Lee Jones <lee.jones@linaro.org>, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20200713074645.126138-1-lee.jones@linaro.org>
 <20200713074645.126138-5-lee.jones@linaro.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <06bc5e03-04b0-7e09-18f4-d9fd536b714b@suse.de>
Date:   Tue, 14 Jul 2020 08:58:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200713074645.126138-5-lee.jones@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/13/20 9:46 AM, Lee Jones wrote:
> A couple of headers make no attempt to document their associated function
> parameters.  Others looks as if they are suffering with a little bitrot.
> 
> Fixes the following W=1 kernel build warning(s):
> 
>   drivers/scsi/fcoe/fcoe.c:654: warning: Function parameter or member 'lport' not described in 'fcoe_netdev_features_change'
>   drivers/scsi/fcoe/fcoe.c:654: warning: Function parameter or member 'netdev' not described in 'fcoe_netdev_features_change'
>   drivers/scsi/fcoe/fcoe.c:2039: warning: Function parameter or member 'ctlr_dev' not described in 'fcoe_ctlr_mode'
>   drivers/scsi/fcoe/fcoe.c:2039: warning: Excess function parameter 'cdev' description in 'fcoe_ctlr_mode'
>   drivers/scsi/fcoe/fcoe.c:2144: warning: Function parameter or member 'fcoe' not described in 'fcoe_dcb_create'
>   drivers/scsi/fcoe/fcoe.c:2144: warning: Excess function parameter 'netdev' description in 'fcoe_dcb_create'
>   drivers/scsi/fcoe/fcoe.c:2144: warning: Excess function parameter 'port' description in 'fcoe_dcb_create'
>   drivers/scsi/fcoe/fcoe.c:2627: warning: Function parameter or member 'lport' not described in 'fcoe_elsct_send'
>   drivers/scsi/fcoe/fcoe.c:2627: warning: Function parameter or member 'did' not described in 'fcoe_elsct_send'
>   drivers/scsi/fcoe/fcoe.c:2627: warning: Function parameter or member 'fp' not described in 'fcoe_elsct_send'
>   drivers/scsi/fcoe/fcoe.c:2627: warning: Function parameter or member 'op' not described in 'fcoe_elsct_send'
>   drivers/scsi/fcoe/fcoe.c:2627: warning: Function parameter or member 'resp' not described in 'fcoe_elsct_send'
>   drivers/scsi/fcoe/fcoe.c:2627: warning: Function parameter or member 'arg' not described in 'fcoe_elsct_send'
>   drivers/scsi/fcoe/fcoe.c:2627: warning: Function parameter or member 'timeout' not described in 'fcoe_elsct_send'
> 
> Cc: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>   drivers/scsi/fcoe/fcoe.c | 10 ++++------
>   1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
> index cb41d166e0c0f..0f9274960dc6b 100644
> --- a/drivers/scsi/fcoe/fcoe.c
> +++ b/drivers/scsi/fcoe/fcoe.c
> @@ -645,7 +645,7 @@ static int fcoe_lport_config(struct fc_lport *lport)
>   	return 0;
>   }
>   
> -/**
> +/*
>    * fcoe_netdev_features_change - Updates the lport's offload flags based
>    * on the LLD netdev's FCoE feature flags
>    */
> @@ -2029,7 +2029,7 @@ static int fcoe_ctlr_enabled(struct fcoe_ctlr_device *cdev)
>   
>   /**
>    * fcoe_ctlr_mode() - Switch FIP mode
> - * @cdev: The FCoE Controller that is being modified
> + * @ctlr_dev: The FCoE Controller that is being modified
>    *
>    * When the FIP mode has been changed we need to update
>    * the multicast addresses to ensure we get the correct
> @@ -2136,9 +2136,7 @@ static bool fcoe_match(struct net_device *netdev)
>   
>   /**
>    * fcoe_dcb_create() - Initialize DCB attributes and hooks
> - * @netdev: The net_device object of the L2 link that should be queried
> - * @port: The fcoe_port to bind FCoE APP priority with
> - * @
> + * @fcoe:   The new FCoE interface
>    */
>   static void fcoe_dcb_create(struct fcoe_interface *fcoe)
>   {
> @@ -2609,7 +2607,7 @@ static void fcoe_logo_resp(struct fc_seq *seq, struct fc_frame *fp, void *arg)
>   	fc_lport_logo_resp(seq, fp, lport);
>   }
>   
> -/**
> +/*
>    * fcoe_elsct_send - FCoE specific ELS handler
>    *
>    * This does special case handling of FIP encapsualted ELS exchanges for FCoE,
> 
I'd rather convert this and the fcoe_netdev_features_change to proper 
kerneldocs:

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index cb41d166e0c0..151fe4c53b07 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -646,8 +646,12 @@ static int fcoe_lport_config(struct fc_lport *lport)
  }

  /**
- * fcoe_netdev_features_change - Updates the lport's offload flags based
- * on the LLD netdev's FCoE feature flags
+ * fcoe_netdev_features_change - Updates the lport's offload flags
+ * @lport:  The local port that is associated with the net device
+ * @netdev: The associated net device
+ *
+ * Update the @lport offload flags based on the FCoE feature flags
+ * from the LLD @netdev.
   */
  static void fcoe_netdev_features_change(struct fc_lport *lport,
                                         struct net_device *netdev)
@@ -2611,6 +2615,13 @@ static void fcoe_logo_resp(struct fc_seq *seq, 
struct fc_frame *fp, void *arg)

  /**
   * fcoe_elsct_send - FCoE specific ELS handler
+ * @lport: Local port
+ * @did: Destination ID
+ * @fp: FCoE frame
+ * @op: ELS operation
+ * @resp: Response callback
+ * @arg: Argument for the response callback
+ * @timeout: Timeout for the ELS response
   *
   * This does special case handling of FIP encapsualted ELS exchanges 
for FCoE,
   * using FCoE specific response handlers and passing the FIP controller as


Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
