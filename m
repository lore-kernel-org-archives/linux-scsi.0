Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792442741;
	b=OWZwtbAHNxOYaMncKBIXLH3TjiTv/TTzz18DAMDhtnl/HnzgNlEpxMUlunTeTYZUVpk+
	 Kl7lrggZeaW2a95r35AaNRrurIp6s6iPGih9mW0+12uyE8RxpLbi3aFbCZB2e511Q1O8p
	 zcT48HjkiU3GscPlyIXsnn16UchkbOs/ROOzBB6MJaFuapkhKtFrT5zdXjZPP+KXOGKnl
	 Eh/FihmvuE4+3ktVjyCyXcgu/oantNQfpHkmeSL2Z3rjeLTMV+A8hgbUN5zzSgVBW3st0
	 ff9YiCFYaDXqTTX8dmD18rN6h27eDjeNZKQ5BHmhNUwaI4Gxgu8ALUfEix5sN9ee8MA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792442741;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=oQzekqZ7QQZ886FQsbl24ntC2ncZi9SY8ECfn/mFYQY=;
	b=0opAcO0T44b+tRZzCi4kdAgqhL8vEuOCT4wnpljdFjcMf+ZsMV5M+/NMlQNpprkpgJ6R
	 A7kW+XH0JA7wabKp6cWUEEsLylmg3skpysSuEnuSdDaRcQFKTXn1V3ChrhPBf2njsZB8C
	 fHixSUaTLsbnjoVtH0CEPSwRiF9NsY214E5BFb9wsjk0eRn82EV0Zatem9wa6AigoS/tO
	 s9JNvk8ZCPQAfm+kHMJC+4I0sSYT4VHz2aqWIKPRptQ3hSAU9y4qaHpB/OFxLSLf6cSE7
	 iwZagKH7trOjdr1p9zquMBlB3w/LgtXvqMbZMipQD8sybzd5H6OzMAlgR33p1mkbsWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=woS0UVBa;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740C3606A31C;
	Mon, 19 Oct 2026 20:45:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 740C3606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=woS0UVBa
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4j7nch6TRtzlfvpT;
	Mon, 19 Oct 2026 20:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1792442737; x=1795034738; bh=oQzekqZ7QQZ886FQsbl24ntC
	2ncZi9SY8ECfn/mFYQY=; b=woS0UVBaVQxkuzlrsIWuEMi+p+FhHcWbZSmODBOC
	9E4+8L3D8NEZnK41d6twvrubvXiiBkPFVTgMNX6XGavrzAKtlehONPsiwOyg+o2p
	yK9TENPqykyOEJcTdoBD4ebrheyBYXY62KTaKh/+2DqMbVqXOvbkL2UicAgOSY1n
	5cp8m2xVVQCiy5bUVh2udwJoHeZ/oScpd6Ojn1yKh7ZOG6uq4fcIlqv1YqsH8Ggw
	TL2Jc2kgh2PPZBLTuD3rjai9h+R6OWnmkZw5q0tCOUgDihdGCT2naBHKpRVxc+CP
	xVVMwk0ERG6XkDTtGgFvlGxvPyLB3weG/i4/Jep24VN7Qg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id yHjlOeM5TSnk; Mon, 19 Oct 2026 20:45:37 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4j7ncc39BHzlfvpH;
	Mon, 19 Oct 2026 20:45:36 +0000 (UTC)
Message-ID: <6ef38c72-9288-4d33-9f42-439c9dbd01d4@acm.org>
Date: Mon, 19 Oct 2026 13:45:35 -0700
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
Subject: Re: [PATCH v2 4/4] scsi: ufs: core: Remove an always-false
 WARN_ONCE()
To: Stanley Jhu <stanleyjhu@google.com>, "Martin K . Petersen"
 <mkp@kernel.org>, linux-scsi@vger.kernel.org
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Bean Huo <beanhuo@micron.com>,
 Peter Wang <peter.wang@mediatek.com>, Can Guo <can.guo@oss.qualcomm.com>,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261017084403.875420-1-stanleyjhu@google.com>
 <20261017084403.875420-5-stanleyjhu@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261017084403.875420-5-stanleyjhu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/17/26 1:44 AM, Stanley Jhu wrote:
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 44e571757535..716dab2352e9 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -6059,9 +6059,6 @@ static unsigned long __ufshcd_clear_outstanding_reqs(struct ufs_hba *hba,
>   	unsigned long completed_reqs = mask & hba->outstanding_reqs;
>   
>   	lockdep_assert_held(&hba->outstanding_lock);
> -	WARN_ONCE(completed_reqs & ~hba->outstanding_reqs,
> -		  "completed: %#lx; outstanding: %#lx\n", completed_reqs,
> -		  hba->outstanding_reqs);
>   	if (from_irq) {
>   		/* Do not complete polled requests from interrupt context. */
>   		ufshcd_clear_polled(hba, &completed_reqs);

This patch should either be the first patch in this series or should be
squashed into patch 1/4 from this series.

Thanks,

Bart.
