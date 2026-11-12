Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794496789;
	b=OC9Zz7WiXDCnW2n8e200JqjbfW9NcmOSQtuvmmemVHgxjUUjIj+1rZgGrkdNrO3BSHGq
	 qu7sj1Ub611/6GtHf5AevQTdbuJEzPL/z+KMYDaxEwTLBbTgNmUU9d5EhYXJyAVglmWbe
	 /MRCLXgHJddH6fDhnDe+IG2ooL+M392MjHbvXc9qsvJ0gNQrwectq+Ns7kMw1fEQ0bfQ4
	 76wyHXdtoTHmzgIBmpcZ4uFigzDGRs1ycyX+odCoTFq3g0n3TElZD5vST59z3B3p8235H
	 Y6AwbhkSH0lwH29rTrHJ49wHHXMlMyC8ojsHaY8Le+WFATIK9Z1qEfbuMVHAnl7UeYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794496789;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=xn95LSz/4Q5qOXQfaKWapMI61xXf4O/U8M/B4PFFbzA=;
	b=jLjaOiidvZm4cXPLxjOR9MJYJblDAMTEN8xNfqrD2MO2AutdPyWROHRV9+BqrSgEo9gn
	 vhF7qTAuJxCPk83TtcM+gvWW3+xUZYH4ISThzqMhkH/dh9mMkx2O0bYhL0P3HwUugYjex
	 5hCuUstb6uwt/boCG3XOaXzCYVTEbBCwtnfy4ne1t7gUONAMs3WGZUfy0tMXqU9TvHIp+
	 kA7cfk4ArB78UTdGLAoxdEofoDWW/pBHgwyQXBsW97/dUoehafPdnwwMp6z7g/O7UOeqk
	 9q7/kzOVipNtr6TWa6Tv0uKzuv8nPOzKXHqKdWXTtXATRCVfGXJbcTwW2y8ERH9oVhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b="S/BbsfO3";
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7485560A382F;
	Thu, 12 Nov 2026 15:19:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7485560A382F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=S/BbsfO3
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4jQPFV4m8Zz1XMYJJ;
	Thu, 12 Nov 2026 15:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1794496774; x=1797088775; bh=xn95LSz/4Q5qOXQfaKWapMI6
	1xXf4O/U8M/B4PFFbzA=; b=S/BbsfO3FeItgOuBI37Uqh6YgB43xAjP7vLfwcOw
	tOdpXF6IUcb7/3xM/VYA89QOCxBwIiDPft2TWylPgf6LO6x3QPz/boHznIz1gMmh
	acf4skQNpmrGoHwgxcRnwelRmQmndg3rNg1Z/W6KtWGGwmfHqtA3ePyOaDVB69ty
	zU+lUgSKHQuTgF4Rt6y1VvZRCJM904vi7JJWtEEUPQRsrinDz+4kIkEAmKFLxKXF
	DulL/503kTzLYXSQPYa7d5tcV7rfWspI7iVSxG2Moq6gDnfqmNGzr2/c02Tw/R2+
	mI772A4I0Dt5iC3DE3u+WhlgmkOu5oc+C0cQzExzPqzGcQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id RvWb9nU2z54j; Thu, 12 Nov 2026 15:19:34 +0000 (UTC)
Received: from [192.168.51.14] (c-24-6-239-25.hsd1.ca.comcast.net [24.6.239.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4jQPFK49bPz1XMYJV;
	Thu, 12 Nov 2026 15:19:33 +0000 (UTC)
Message-ID: <59c577b6-4749-4edc-9dd9-a83f2a124adb@acm.org>
Date: Thu, 12 Nov 2026 07:19:32 -0800
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/9] scsi: ufs: core: Defer link recovery on reserved PM
 command timeout
To: Stanley Jhu <stanleyjhu@google.com>, linux-scsi@vger.kernel.org,
 "Martin K. Petersen" <mkp@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman
 <avri.altman@sandisk.com>, Bean Huo <beanhuo@micron.com>,
 Peter Wang <peter.wang@mediatek.com>, Stanley Chu
 <stanley.chu@mediatek.com>, Can Guo <quic_cang@quicinc.com>,
 "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 Asutosh Das <quic_asutoshd@quicinc.com>,
 Hongjie Fang <hongjiefang@asrmicro.com>,
 Praveen Talari <praveen.talari@oss.qualcomm.com>,
 HOYOUNG SEO <hy50.seo@samsung.com>, Brian Kao <powenkao@google.com>,
 Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki"
 <rafael.j.wysocki@intel.com>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261112051542.1539779-1-stanleyjhu@google.com>
 <20261112051542.1539779-3-stanleyjhu@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261112051542.1539779-3-stanleyjhu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/11/26 9:15 PM, Stanley Jhu wrote:
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index e9dcab35a4cd..6a5f5fa732d9 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -7147,7 +7147,7 @@ static void ufshcd_err_handler(struct work_struct *work)
>   	spin_unlock_irqrestore(&hba->host->host_lock, flags);
>   
>   	/* Complete requests that have door-bell cleared by h/w */
> -	if (!stop)
> +	if (!stop && ufshcd_is_hba_active(hba))
>   		ufshcd_complete_requests(hba, false);
>   	spin_lock_irqsave(&hba->host->host_lock, flags);
>   again:
> @@ -9689,6 +9689,50 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
>   		dev_err(hba->dev, "%s failed: %d\n", __func__, ret);
>   }
>   
> +/*
> + * Claim @scmd before stopping the HBA in case normal completion raced with
> + * scsi_timeout(), then complete @scmd so the PM caller releases
> + * hba->dev_cmd.lock and the reserved tag before error recovery runs.
> + */
> +static void ufshcd_eh_pm_cmd_timed_out(struct ufs_hba *hba,
> +				       struct scsi_cmnd *scmd)
> +{
> +	struct request *rq = scsi_cmd_to_rq(scmd);
> +	struct ufs_hw_queue *hwq;
> +
> +	if (!hba->mcq_enabled) {
> +		if (!ufshcd_clear_outstanding_reqs(hba, BIT(rq->tag)))
> +			return;
> +		ufshcd_hba_stop(hba);
> +		ufshcd_force_error_recovery(hba);
> +		set_host_byte(scmd, DID_TIME_OUT);
> +		scsi_done(scmd);
> +		return;
> +	}
> +
> +	hwq = ufshcd_mcq_req_to_hwq(hba, rq);
> +	if (ufshcd_is_hba_active(hba))
> +		ufshcd_mcq_poll_cqe_lock(hba, hwq);
> +	scoped_guard(spinlock_irqsave, &hwq->cq_lock) {
> +		if (test_bit(SCMD_STATE_COMPLETE, &scmd->state))
> +			return;
> +	}
> +	spin_lock_irq(&hba->host->host_lock);
> +	hba->force_reset = true;
> +	if (hba->ufshcd_state != UFSHCD_STATE_ERROR)
> +		hba->ufshcd_state = UFSHCD_STATE_EH_SCHEDULED_FATAL;
> +	spin_unlock_irq(&hba->host->host_lock);
> +	ufshcd_hba_stop(hba);
> +	ufshcd_mcq_compl_all_cqes_lock(hba, hwq);
> +	ufshcd_force_error_recovery(hba);
> +	scoped_guard(spinlock_irqsave, &hwq->cq_lock) {
> +		if (!test_bit(SCMD_STATE_COMPLETE, &scmd->state)) {
> +			set_host_byte(scmd, DID_TIME_OUT);
> +			scsi_done(scmd);
> +		}
> +	}
> +}
> +
>   static enum scsi_timeout_action ufshcd_eh_timed_out(struct scsi_cmnd *scmd)
>   {
>   	struct ufs_hba *hba = shost_priv(scmd->device->host);
> @@ -9698,6 +9742,11 @@ static enum scsi_timeout_action ufshcd_eh_timed_out(struct scsi_cmnd *scmd)
>   		return SCSI_EH_NOT_HANDLED;
>   	}
>   
> +	if (!ufshcd_is_scsi_cmd(scmd)) {
> +		ufshcd_eh_pm_cmd_timed_out(hba, scmd);
> +		return SCSI_EH_DONE;
> +	}
> +
>   	/*
>   	 * Handle the timeout directly to prevent a deadlock between
>   	 * ufshcd_set_dev_pwr_mode() and ufshcd_err_handler().

I don't like the approach of this patch series. I think this series 
changes much more code than what is necessary. There is a much simpler
way to fix the issue reported in the cover letter: instead of calling
ufshcd_link_recovery(hba) from ufshcd_eh_timed_out(), remove that call
from ufshcd_eh_timed_out() and instead call ufshcd_link_recovery(hba)
from ufshcd_set_dev_pwr_mode() if the SCSI error code returned by
ufshcd_execute_start_stop() indicates that the SCSI START STOP UNIT
command has timed out.

Thanks,

Bart.

