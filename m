Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793288230;
	b=e3t2yVnIxK7i2sRFtnRW5gzKWK8Nu7GMvxE1sMdV8E820dRfRrjnuxVxH35BgKM4yu5T
	 yxosehRjMPR9reOaV/kcM5tF8fJOmyL4qNpw/CvgPXzwAUuSLn7HpGCxcr3LET5Qqbwmm
	 0stdnFl6/eqWAchD9swXNfwRYZyLyLh3MeFntv9H/AHzFbkXqOWWzZGXaAHzOdXbFeBB2
	 Pp9jvowvFIFqIT7w3rrYWy3pTY2lqYoD/KMMWrYYy6bV+Bi/iaj46j0b5SGo5/mL+dr8e
	 eTdFUblaro3KON85kjuF7yMEJTxZdO78fGOkrir4KCSKZW2eTEJfJss+DrQHlA15kgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793288230;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=7w8z6oU4/4x8U/rb5nvJuW4qpERxGYIwAjYcgMWl1C4=;
	b=2XDkiNpAszUsmq5d/oyGGLdd79m1/AyugdY+3iFbzyLXbXk4EDCvBt1W34mxeNy1YVpI
	 Yf/rUmQSQSOZ+6tnw5UQfYnQmiS3xxHZEJXkMQWbmFgCiTubwkKUIfNmLLuX1zuCJT4ut
	 3/idj+OZOnV+WVncMpXUtchojn9h7RteMx+Su7jP7y840OWS+6VYPDOwgjcGK5Crp3DLL
	 az3vBWr540XVyec2nA4f/e6MLftqcN5VSN7RfV8WdeHk0O1rDCtxTUHNWlgbMsWOAW7Pk
	 UfAJn6gLY5MiaAlSkhKyTquvSZ11HZ41b21tE3WR+uAGkrwBgeL0oiQDRgk5i/NjkNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=oLSWziy5;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE35606A320;
	Thu, 29 Oct 2026 15:37:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7FE35606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=oLSWziy5
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4jFpHz41c6zlfvpd;
	Thu, 29 Oct 2026 15:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1793288218; x=1795880219; bh=7w8z6oU4/4x8U/rb5nvJuW4q
	pERxGYIwAjYcgMWl1C4=; b=oLSWziy5PwNbh3pn9QWRWOe4vKaAAc8+f1NEd2l4
	Dn9GVo6ykR01ggc1sBoYV8uNSjkPbODJ75FXkCUhGtOW5SHilOy34bcxmN3OxLtk
	L0P2Ss26lzYVKxSCtl/YuOD/VKlLh9mf6q7eZ+lDUyi3zCsizBuyMa0YHFgfu6MG
	9tLxpeNosnrd6zo1/BayXqP6c2YRkHkccdWumN0S6+5W+VSA/uMMrceaO1PXne3l
	ARCY8Bbb2BdkqCeOc7HsV+Hiy+mtiO2ADT09TdoUMDeFIsXeGOdcKdp+J7h9pAOG
	ZU9Bvc6luAi3vNCRXACnDSJ87ENnMjBojQoViFCgZqdqlA==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id CZ0FcHmo7fqc; Thu, 29 Oct 2026 15:36:58 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4jFpHr6dVmzlfvpc;
	Thu, 29 Oct 2026 15:36:56 +0000 (UTC)
Message-ID: <3be5c9ac-44f3-46c0-bb81-6bde6edcba28@acm.org>
Date: Thu, 29 Oct 2026 08:36:56 -0700
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
Subject: Re: [PATCH] scsi: ufs: core: Skip completion of SCSI commands owned
 by the SCSI EH
To: Stanley Jhu <stanleyjhu@google.com>, "Martin K . Petersen"
 <mkp@kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Bean Huo <beanhuo@micron.com>
Cc: Peter Wang <peter.wang@mediatek.com>, Can Guo <can.guo@oss.qualcomm.com>,
 John Garry <john.garry@linux.dev>, "Bao D . Nguyen"
 <quic_nguyenb@quicinc.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261029040004.2100004-1-stanleyjhu@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261029040004.2100004-1-stanleyjhu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/29/26 12:09 AM, Stanley Jhu wrote:
> +static inline bool ufshcd_cmd_owned_by_scsi_eh(struct scsi_cmnd *cmd)
> +{
> +	return cmd->submitter == SUBMITTED_BY_BLOCK_LAYER &&
> +	       test_bit(SCMD_STATE_COMPLETE, &cmd->state);
> +}

This is a layering violation. The UFS driver has no business checking
these fields. cmd->submitter checks and cmd->state checks should happen
by the SCSI core and not by any SCSI LLD.

> @@ -6009,6 +6025,10 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int task_tag,
>   		lrbp->compl_time_stamp_local_clock = local_clock();
>   	}
>   	if (ufshcd_is_scsi_cmd(cmd)) {
> +		if (unlikely(ufshcd_cmd_owned_by_scsi_eh(cmd))) {
> +			ufshcd_release_scsi_cmd(hba, cmd);
> +			return;
> +		}
>   		if (unlikely(ufshcd_should_inform_monitor(hba, cmd)))
>   			ufshcd_update_monitor(hba, cmd);
>   		ufshcd_add_command_trace(hba, cmd, UFS_CMD_COMP);

The problem described in the patch description applies to all SCSI LLDs
and hence should be solved in a generic way instead of in the UFS driver
only.

Bart.
