Return-Path: <SRS0=0yur=EJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54CDBC2D0A3
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 13:28:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03EA1216C4
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 13:28:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="vu7urboF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729273AbgKCN2k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Nov 2020 08:28:40 -0500
Received: from z5.mailgun.us ([104.130.96.5]:41553 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729260AbgKCN2j (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 3 Nov 2020 08:28:39 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1604410119; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=sqwyhNLZtT91lsQd+XyBIalxVdR7yZ2gDZ/X4qFOhdM=;
 b=vu7urboFfu/lPeI7xEjZxIOVfgaAaoPOFUViDjlzef9a+QPaSgFg+ukdVnAFXDsv4lMN4SFq
 GYxFp8E8+rTj8Zi6QqAQ7V0M+DbfJVoR9x3okZ6BGLMp++Bxgnl5IoPi3Y6G7qyOmpJSrZW2
 wTGOVpFYbiS9ekNPYXyNbh3eWh0=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 5fa15af7d981633da35830f4 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 03 Nov 2020 13:28:23
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 08564C384EF; Tue,  3 Nov 2020 06:27:27 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D57E7C433B1;
        Tue,  3 Nov 2020 06:27:26 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 03 Nov 2020 14:27:26 +0800
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com, cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: Try to save power mode change and UIC cmd
 completion timeout
In-Reply-To: <1604384682-15837-4-git-send-email-cang@codeaurora.org>
References: <1604384682-15837-1-git-send-email-cang@codeaurora.org>
 <1604384682-15837-4-git-send-email-cang@codeaurora.org>
Message-ID: <ba1a544b827cd290d1a48e8307a8e2d0@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Sorry, please ignore this specific change, which is wrongly sent out.

On 2020-11-03 14:24, Can Guo wrote:
> Use the uic_cmd->cmd_active as a flag to track the lifecycle of an UIC 
> cmd.
> The flag is set before send the UIC cmd and cleared after the 
> completion is
> raised in IRQ handler. For a power mode change operation, including 
> hibern8
> enter/exit, the flag is cleared only after hba->uic_async_done 
> completion
> is raised. When completion timeout happens, if the flag is cleared, 
> instead
> of returning timeout error, simply ignore it.
> 
> Change-Id: Ie3cd6ae6221a44619925fb2cf78136a5617fdd5d
> Signed-off-by: Can Guo <cang@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 26 ++++++++++++++++++++++++--
>  1 file changed, 24 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 252e022..8b291c3 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -2131,10 +2131,20 @@ ufshcd_wait_for_uic_cmd(struct ufs_hba *hba,
> struct uic_command *uic_cmd)
>  	unsigned long flags;
> 
>  	if (wait_for_completion_timeout(&uic_cmd->done,
> -					msecs_to_jiffies(UIC_CMD_TIMEOUT)))
> +					msecs_to_jiffies(UIC_CMD_TIMEOUT))) {
>  		ret = uic_cmd->argument2 & MASK_UIC_COMMAND_RESULT;
> -	else
> +	} else {
>  		ret = -ETIMEDOUT;
> +		dev_err(hba->dev,
> +			"uic cmd 0x%x with arg3 0x%x completion timeout\n",
> +			uic_cmd->command, uic_cmd->argument3);
> +
> +		if (!uic_cmd->cmd_active) {
> +			dev_err(hba->dev, "%s: UIC cmd has been completed, return the 
> result\n",
> +				__func__);
> +			ret = uic_cmd->argument2 & MASK_UIC_COMMAND_RESULT;
> +		}
> +	}
> 
>  	spin_lock_irqsave(hba->host->host_lock, flags);
>  	hba->active_uic_cmd = NULL;
> @@ -2166,6 +2176,7 @@ __ufshcd_send_uic_cmd(struct ufs_hba *hba,
> struct uic_command *uic_cmd,
>  	if (completion)
>  		init_completion(&uic_cmd->done);
> 
> +	uic_cmd->cmd_active = 1;
>  	ufshcd_dispatch_uic_cmd(hba, uic_cmd);
> 
>  	return 0;
> @@ -3944,10 +3955,18 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba
> *hba, struct uic_command *cmd)
>  		dev_err(hba->dev,
>  			"pwr ctrl cmd 0x%x with mode 0x%x completion timeout\n",
>  			cmd->command, cmd->argument3);
> +
> +		if (!cmd->cmd_active) {
> +			dev_err(hba->dev, "%s: Power Mode Change operation has been
> completed, go check UPMCRS\n",
> +				__func__);
> +			goto check_upmcrs;
> +		}
> +
>  		ret = -ETIMEDOUT;
>  		goto out;
>  	}
> 
> +check_upmcrs:
>  	status = ufshcd_get_upmcrs(hba);
>  	if (status != PWR_LOCAL) {
>  		dev_err(hba->dev,
> @@ -5060,11 +5079,14 @@ static irqreturn_t ufshcd_uic_cmd_compl(struct
> ufs_hba *hba, u32 intr_status)
>  		hba->active_uic_cmd->argument3 =
>  			ufshcd_get_dme_attr_val(hba);
>  		complete(&hba->active_uic_cmd->done);
> +		if (!hba->uic_async_done)
> +			hba->active_uic_cmd->cmd_active = 0;
>  		retval = IRQ_HANDLED;
>  	}
> 
>  	if ((intr_status & UFSHCD_UIC_PWR_MASK) && hba->uic_async_done) {
>  		complete(hba->uic_async_done);
> +		hba->active_uic_cmd->cmd_active = 0;
>  		retval = IRQ_HANDLED;
>  	}
>  	return retval;
