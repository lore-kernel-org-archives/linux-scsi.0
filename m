Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A4A6C4360C
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Dec 2020 02:47:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4494B22D73
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Dec 2020 02:47:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730976AbgLWCq5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Dec 2020 21:46:57 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:55064 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729691AbgLWCWb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Dec 2020 21:22:31 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1608690126; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=qxXxIQFDgNqs7K4WCzNIbU7cKbT7cPDQvy88szv1zbg=;
 b=xjo9OeL3Je9D2crUQU6MGpkc95ERoiTZHHuljcYUebBx4A0Xl5hrzD9hGrihUNgQutRnBQ7f
 VeDuo7L90pKgw6fDMcceak4yfSsMLe9emrtibGzVGSG3wrczrugajHWlwC3SnjL2USq922mP
 XJ1P7lEju97g2nxP8QR5c8dH5/k=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n08.prod.us-west-2.postgun.com with SMTP id
 5fe2a9b2cfe5dd67db29238a (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 23 Dec 2020 02:21:38
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7500CC5515F; Wed, 23 Dec 2020 02:21:38 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A0A6CC48B1D;
        Wed, 23 Dec 2020 02:21:36 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 23 Dec 2020 10:21:36 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Kiwoong Kim <kwmad.kim@samsung.com>
Cc:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com
Subject: Re: [PATCH v4 1/2] ufs: add a vops to configure block parameter
In-Reply-To: <d937b2a64d597ce969ad3e36419f9814e5e202ae.1608689016.git.kwmad.kim@samsung.com>
References: <cover.1608689016.git.kwmad.kim@samsung.com>
 <CGME20201223021601epcas2p1311bd2ee57014e3b536de5a5ca286f85@epcas2p1.samsung.com>
 <d937b2a64d597ce969ad3e36419f9814e5e202ae.1608689016.git.kwmad.kim@samsung.com>
Message-ID: <b179a682b82118f09919db886ff71eb5@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-12-23 10:05, Kiwoong Kim wrote:
> There could be some cases to set block parameters
> per host, because of its own dma structure or whatever.
> 
> Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>

You missed my reviewed-by tag... Again, here it is

Reviewed-by: Can Guo <cang@codeaurora.org>

> ---
>  drivers/scsi/ufs/ufshcd.c | 2 ++
>  drivers/scsi/ufs/ufshcd.h | 8 ++++++++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 92d433d..5f89b0e 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -4758,6 +4758,8 @@ static int ufshcd_slave_configure(struct
> scsi_device *sdev)
> 
>  	ufshcd_crypto_setup_rq_keyslot_manager(hba, q);
> 
> +	ufshcd_vops_slave_configure(hba, sdev);
> +
>  	return 0;
>  }
> 
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 61344c4..4bf4fed 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -329,6 +329,7 @@ struct ufs_hba_variant_ops {
>  					void *data);
>  	int	(*program_key)(struct ufs_hba *hba,
>  			       const union ufs_crypto_cfg_entry *cfg, int slot);
> +	void	(*slave_configure)(struct scsi_device *sdev);
>  };
> 
>  /* clock gating state  */
> @@ -1228,6 +1229,13 @@ static inline void
> ufshcd_vops_config_scaling_param(struct ufs_hba *hba,
>  		hba->vops->config_scaling_param(hba, profile, data);
>  }
> 
> +static inline void ufshcd_vops_slave_configure(struct ufs_hba *hba,
> +						    struct scsi_device *sdev)
> +{
> +	if (hba->vops && hba->vops->slave_configure)
> +		hba->vops->slave_configure(sdev);
> +}
> +
>  extern struct ufs_pm_lvl_states ufs_pm_lvl_states[];
> 
>  /*
