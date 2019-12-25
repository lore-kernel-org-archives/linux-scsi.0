Return-Path: <SRS0=On0Q=2P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF6A9C2D0DA
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Dec 2019 08:17:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95E1F20643
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Dec 2019 08:17:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="KzDjS1Z2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbfLYIRq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Dec 2019 03:17:46 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:39699 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726552AbfLYIRp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Dec 2019 03:17:45 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1577261865; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=3gPXu8HPh5fywBE1SXL8dS6OGavP7d8uzUucCNYJMMc=;
 b=KzDjS1Z2KQ2XHE1LDtGE5cdgRMaTikSEhJHpP3l8ZiB9k6F82i6W6PTmtuLBeR76OZPBTJdR
 A6VsuAs1w3EFRwCKlWjxZU6xmwzp/2oSKE6J9zlynv51ZWktkex6JgXuzO1ZH70gQAsFlIfL
 eRu0SioJA463WhhRPU9EEDh6Bp4=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e031b28.7f5b2c56bd88-smtp-out-n01;
 Wed, 25 Dec 2019 08:17:44 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 3C255C433CB; Wed, 25 Dec 2019 08:17:42 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1A5B1C433CB;
        Wed, 25 Dec 2019 08:17:41 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 25 Dec 2019 16:17:41 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: [PATCH 1/6] ufs: Fix indentation in ufshcd_query_attr_retry()
In-Reply-To: <20191224220248.30138-2-bvanassche@acm.org>
References: <20191224220248.30138-1-bvanassche@acm.org>
 <20191224220248.30138-2-bvanassche@acm.org>
Message-ID: <b9f708dd98297e309c1a9cd38877f6f5@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-12-25 06:02, Bart Van Assche wrote:
> Remove a space that occurs after a tab.
> 
> Cc: Bean Huo <beanhuo@micron.com>
> Cc: Can Guo <cang@codeaurora.org>
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> Cc: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Can Guo <cang@codeaurora.org>

> ---
>  drivers/scsi/ufs/ufshcd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index d6d0f83c9044..48f2f94d51bc 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -2869,7 +2869,7 @@ static int ufshcd_query_attr_retry(struct ufs_hba 
> *hba,
>  	int ret = 0;
>  	u32 retries;
> 
> -	 for (retries = QUERY_REQ_RETRIES; retries > 0; retries--) {
> +	for (retries = QUERY_REQ_RETRIES; retries > 0; retries--) {
>  		ret = ufshcd_query_attr(hba, opcode, idn, index,
>  						selector, attr_val);
>  		if (ret)
