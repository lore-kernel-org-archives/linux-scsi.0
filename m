Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792443067;
	b=4MWZb/0/dPKOTJeTAOJHmtN1mZVFIr/HzEgX7gn0cjbKIfBDk1OOn4QXcDUyDozD30Ph
	 mLeuvBBg2ewHdteyWVHGELKOmUHzCZfpmFWM1NAe5EvOG1mlMqSW/h/jAVTr1aVu3Wi8O
	 z+TydbaJjz+4gp+4xemckLnJ8Ysb+9yi2cVzSjlT7N4ofHDHWZ4giyDvGvpLnUIWL6VOU
	 oL1EllfO5HbPbDScbnKKu+MzFHMfDPuJaJgIIDkwIqZy4tehZByeo+/XBRo/AWNAVLfAT
	 pC9VdsIDTTpzbLoPhCJGsm9TvGmFZuNWPTQu9VHRCp0S4Zie0+teTFAEJl2Ulqp6e2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792443067;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=cMxHhu55q/o95RP1vvVzg1JkTp2m0fLATx6ROeGb19c=;
	b=RVVQVMjLq0kDpQHn5YpmnUmle5KMr1H1b8xVIq8jk/Aj/0Y3Vgojy4etRaUopnQIsfgP
	 NVKCqJTH3G/qCtv7B2kX3Q217YCHqeuYc4SYsvGrDApFl4Ln3HzWi6v9DdKFSfrzRthUl
	 20FC3u6/zASCQ/HtSi8YxRo3A3PNIVNdrmOhdNJwuLsYMFPwofiaMjTSgaUFRlBo2Hubp
	 f+iuFYsatFQjRV4a/1W+v/ogc3NDDLlSaP9vxFADQuOAa2GpX8N9unufWcukEoNJ9OCpr
	 YA2foZGUN93XgJxkKXmKqMJTo/ISfnqF4p/HW9IaTp3+gvns3Fqy1cKZda4cRCjWC+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=k+JQPBeT;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0315F606A33A;
	Mon, 19 Oct 2026 20:51:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0315F606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=k+JQPBeT
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4j7nks3X1HzlfvpT;
	Mon, 19 Oct 2026 20:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1792443056; x=1795035057; bh=cMxHhu55q/o95RP1vvVzg1Jk
	Tp2m0fLATx6ROeGb19c=; b=k+JQPBeTRUxeqqN9jH5ZJQoGjYg/besJgX5fF3Hh
	b72+P2nTnuqfe5MyzuP2O8/K7jHD5qWHiAx/gfkYI6rM4goKZsD0q/u4YsRdQ5xh
	1SQhOqWKzXTBMTiAiNfsSROdO0GZNF/P40VVRTrV1gybxGjvf6wLJ0i5evDNkmdQ
	KQMG8RxbTCNsCRUrWTfrh1eKbg3uRI42KAH9EG53xB/PrZRsKyufHY2usxoXeNX7
	yiGSPtwWP8hxJGE9HuUnjrYmWWHFVxdGeuDToM81izB4h9Y/H3SpQ33T6dX0V9oQ
	dXh/bscpKHI/rhUeOLCvBAoNffg5ZvZOVLtJBAjgs+/g9Q==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id IT6NnXxwkQPt; Mon, 19 Oct 2026 20:50:56 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4j7nkl4QtDzlfvpH;
	Mon, 19 Oct 2026 20:50:55 +0000 (UTC)
Message-ID: <0da98f23-274d-4279-85ce-94cbe650de30@acm.org>
Date: Mon, 19 Oct 2026 13:50:54 -0700
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
Subject: Re: [PATCH v2 1/4] scsi: ufs: core: Add a helper for clearing
 hba->outstanding_reqs
To: Stanley Jhu <stanleyjhu@google.com>, "Martin K . Petersen"
 <mkp@kernel.org>, linux-scsi@vger.kernel.org
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Bean Huo <beanhuo@micron.com>,
 Peter Wang <peter.wang@mediatek.com>, Can Guo <can.guo@oss.qualcomm.com>,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261017084403.875420-1-stanleyjhu@google.com>
 <20261017084403.875420-2-stanleyjhu@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261017084403.875420-2-stanleyjhu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/17/26 1:44 AM, Stanley Jhu wrote:
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index bcc2512bf34b..71f4b9d0a850 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -6052,6 +6052,37 @@ static void ufshcd_clear_polled(struct ufs_hba *hba,
>   	}
>   }
>   
> +static unsigned long __ufshcd_clear_outstanding_reqs(struct ufs_hba *hba,
> +						     unsigned long mask,
> +						     bool from_irq)
> +{
> +	unsigned long completed_reqs = mask & hba->outstanding_reqs;
> +
> +	lockdep_assert_held(&hba->outstanding_lock);
> +	WARN_ONCE(completed_reqs & ~hba->outstanding_reqs,
> +		  "completed: %#lx; outstanding: %#lx\n", completed_reqs,
> +		  hba->outstanding_reqs);
> +	if (from_irq) {
> +		/* Do not complete polled requests from interrupt context. */
> +		ufshcd_clear_polled(hba, &completed_reqs);
> +	}
> +	hba->outstanding_reqs &= ~completed_reqs;
> +
> +	return completed_reqs;
> +}

Please use __must_hold() instead of lockdep_assert_held(). __must_hold()
is evaluated at compile time (by Clang) while lockdep_assert_held() is
evaluated at run-time. If you don't want to depend on Clang, feel free
to use both.

> +static unsigned long ufshcd_clear_outstanding_reqs(struct ufs_hba *hba,
> +						   unsigned long mask)
> +{
> +	unsigned long completed_reqs, flags;
> +
> +	spin_lock_irqsave(&hba->outstanding_lock, flags);
> +	completed_reqs = __ufshcd_clear_outstanding_reqs(hba, mask, false);
> +	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
> +
> +	return completed_reqs;
> +}

The seven-line body of the above function can be reduced to two lines by
using guard():

static unsigned long ufshcd_clear_outstanding_reqs(struct ufs_hba *hba,
						   unsigned long mask)
{
	guard(spinlock_irqsave)(&hba->outstanding_lock);
	return __ufshcd_clear_outstanding_reqs(hba, mask, false);
}

Otherwise this patch looks good to me.

Thanks,

Bart.
