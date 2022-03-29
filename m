Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46E2AC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Mar 2022 04:18:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbiC2ESI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Mar 2022 00:18:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231919AbiC2ESG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Mar 2022 00:18:06 -0400
X-Greylist: delayed 1227 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 28 Mar 2022 21:16:23 PDT
Received: from gateway23.websitewelcome.com (gateway23.websitewelcome.com [192.185.49.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C741F2DF4
        for <linux-scsi@vger.kernel.org>; Mon, 28 Mar 2022 21:16:23 -0700 (PDT)
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id E9CCDA269
        for <linux-scsi@vger.kernel.org>; Mon, 28 Mar 2022 22:55:55 -0500 (CDT)
Received: from 162-215-252-75.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id Z2xXn6K5QRnrrZ2xXnIe0D; Mon, 28 Mar 2022 22:55:55 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=cU7mJiRaXgHEKVPsU3K2B0ICRwH/FmMyWAgkX3+b5hw=; b=uD/+5/9Gb9T5kOsqulVb3QVHLB
        B/FIfyjRMYhUAMO6gIrVuO0L9gsrFTQY0cP7VOPqGNEVvKlW9N0alGjpaDbSXSOLn3NAONq/RMAbY
        CLj84Yn7P/g/sVpsIZHyDmCRBOm+OrMf5gj6eLHBS1vGK5RU+yrJCkkjVXO8PwyAKoPvyaRajytl1
        trlQQ41dZ0S2CtMtDHx14nur6zH8apr5JEHhmPUxkllgf2u7l/bvVop0T4MDJg+VSCm9uQW1svT/9
        jlMz17offus32emvv8og1Xc+5BzCMvHYsTNnh3qhqi4TQeifFUjrTGDUkk23AJHXZ3JzyHYOobCPV
        O3TGkvPA==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:54536)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@roeck-us.net>)
        id 1nZ2xX-0004yI-IX; Tue, 29 Mar 2022 03:55:55 +0000
Message-ID: <8f68be0a-dde1-2a0f-e837-2ddca2135260@roeck-us.net>
Date:   Mon, 28 Mar 2022 20:55:54 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] scsi: core: sysfs: remove comments that conflict with the
 actual logic
Content-Language: en-US
To:     Jackie Liu <liu.yun@linux.dev>, martin.petersen@oracle.com
Cc:     hch@lst.de, linux-scsi@vger.kernel.org
References: <20220329021251.123805-1-liu.yun@linux.dev>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20220329021251.123805-1-liu.yun@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1nZ2xX-0004yI-IX
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net [108.223.40.66]:54536
X-Source-Auth: linux@roeck-us.net
X-Email-Count: 1
X-Source-Cap: cm9lY2s7YWN0aXZzdG07YmgtMjUud2ViaG9zdGJveC5uZXQ=
X-Local-Domain: yes
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/28/22 19:12, Jackie Liu wrote:
> From: Jackie Liu <liuyun01@kylinos.cn>
> 
> Christoph Hellwig Says:
> =======================
> I think we should just handle the error properly and remove the comment.
> There's no good reason to ignore bsg registration errors.
> 
> In fact, after commit 92c4b58b15c5 ("scsi: core: Register sysfs attributes
> earlier"), we are already forced to return errno.
> 
> We discuss this issue in [1].
> 
> [1] https://lore.kernel.org/all/20211022010201.426746-1-liu.yun@linux.dev/
> 
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> ---
>   drivers/scsi/scsi_sysfs.c | 4 ----
>   1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index f1e0c131b77c..322228faf8da 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -1392,10 +1392,6 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
>   	if (IS_ENABLED(CONFIG_BLK_DEV_BSG)) {
>   		sdev->bsg_dev = scsi_bsg_register_queue(sdev);
>   		if (IS_ERR(sdev->bsg_dev)) {
> -			/*
> -			 * We're treating error on bsg register as non-fatal, so
> -			 * pretend nothing went wrong.
> -			 */
>   			error = PTR_ERR(sdev->bsg_dev);
>   			sdev_printk(KERN_INFO, sdev,
>   				    "Failed to register bsg queue, errno=%d\n",

