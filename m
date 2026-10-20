Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792527217;
	b=X3YgVtVB2sws0IRkosMEEk5d2CNNVEvHgtSsOq+1Pg8MJc3sQWzFYca3mvq8rTCVPuQe
	 x00SUjR3xgDkj/aFda4e3apmbOEgPTR1XUKm2mldu3jYvZPM5WIIr4/i3pdyjCadwA4SM
	 Jab23BuE6GbjD+pDul9F99A0chtd1zYKgR5PGYbLhj04L1cB8Fo3mgxE8yBmbzPdL7BlO
	 PcZ/bmorwpNI4eEBaQbaZp5Wpum3ZkUI9rLGEoEmHX1v2B2YkrjPpfgHADYrgxW4MUoW+
	 j463lJbmY9+R/KeOD0H/A30dRetucAHOFXRVtd97mFyJ9fqRNZS9ENnB8GFyHbTaD3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792527217;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=q+9Z6hl+nxcrMzEPus9QGxnkV2gDZWbNLi8m8/TVL8Q=;
	b=gvNuRp2XYBjeQOYPgm1a4u9saY5u3Am/4wt7SkdaGwUGdZlCb3qaLxEQf+w8I427uGt/
	 NZq9jn3s+e+uKLo7hZjagVd6AmZvkS/M0YnvjsjsaqlDNc1HmTt3jmtGeNn++BGygrCK3
	 AGEB6NRXOnrYMppjCDlPZQVf8iRiotX1Xxnoiwvh2DLN6wfMHGc8c8J6TOghASiw+Gwzh
	 I1wy6G3PMt5lCGjNV22y1rNAEsTzoHEMNtWgexuCkKlzzzA5tWOWXebVaAWvbHgYsz6AR
	 K1dAhzh1sal0hfDA9wH/bge2cvbyCxIydgTzjcb/JuaL5wkPVeMvMtF9dMVmT4DnpQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=T5nZ1p+F;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68FB8606A32F;
	Tue, 20 Oct 2026 20:13:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 68FB8606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=T5nZ1p+F
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4j8Ns705c6zlfvps;
	Tue, 20 Oct 2026 20:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1792527207; x=1795119208; bh=q+9Z6hl+nxcrMzEPus9QGxnk
	V2gDZWbNLi8m8/TVL8Q=; b=T5nZ1p+FU0NhwbOcYdkqIlRBQZWogjhSiWHagT1B
	7HJmh9fvi5fWiu+1FYvwgiCqhy6fuYUH/rsiicrSy7fUrck9s/HiFtDS/s5UwJzF
	Am9MVuBPjDItD2LzaehcfooRdsfY8ZeTNsBIxIMesZAFiJe3EsWIxo0o8HD23nu0
	knq4W0sThteKPrWBmThKzfwvPchWW2kGNwYDUAdIwAFr9a7IIYHq7lmVMicVRvgd
	djuKKL3HwPgBqG+ylqfNn8ONUI2O+WRJNW3/KjPPa6Zigxh9KjKW+IHgHvc4tFLT
	2tyNpi5S8NOnz0ZJTc4EzaTAWH22/kJd/oBpMgS4rRuUPg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id kV2mZTpX7pxK; Tue, 20 Oct 2026 20:13:27 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4j8Ns22jfWzlfvpr;
	Tue, 20 Oct 2026 20:13:26 +0000 (UTC)
Message-ID: <04957492-ed95-426c-a5e1-5491ec749c16@acm.org>
Date: Tue, 20 Oct 2026 13:13:23 -0700
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
Subject: Re: [PATCH v3 6/7] scsi: ufs: core: Fix double release in
 ufshcd_abort()
To: Stanley Jhu <stanleyjhu@google.com>, "Martin K . Petersen"
 <mkp@kernel.org>, linux-scsi@vger.kernel.org
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Bean Huo <beanhuo@micron.com>,
 Peter Wang <peter.wang@mediatek.com>, Can Guo <can.guo@oss.qualcomm.com>,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261020082110.3511797-1-stanleyjhu@google.com>
 <20261020082110.3511797-7-stanleyjhu@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261020082110.3511797-7-stanleyjhu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/20/26 1:21 AM, Stanley Jhu wrote:
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 111f5805f178..ee898f4a5bb1 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -8176,7 +8176,9 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>   		dev_err(hba->dev,
>   		"%s: cmd was completed, but without a notifying intr, tag = %d",
>   		__func__, tag);
> -		__ufshcd_transfer_req_compl(hba, 1UL << tag);
> +		if (ufshcd_clear_outstanding_reqs(hba, BIT(tag)) &&
> +		    ufshcd_is_scsi_cmd(cmd))
> +			ufshcd_release_scsi_cmd(hba, cmd);
>   		goto release;
>   	}

This change is incomplete. "err = SUCCESS" is missing above "goto
release". Without this change, the SCSI error handler will escalate
error handling unnecessarily to the next level.

Bart.




