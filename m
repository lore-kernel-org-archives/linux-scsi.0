Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794333253;
	b=YzcSpm3HtJHFq0LSTIsDnCqf2x41IMMxEpC8y5I3yNevnvKE7fo0YwUqBAYH98+qqlSd
	 TTLglS8O9P81P8od1cf/qPKUoUTMYQbGK9KWvZrq8fTEOrg4fqCgKgZK5PZdVlB2ogO9u
	 OXsgSoho8sqvBGdmy8HUI3b2m18pN/VKDWYaQUgGfp7InQM+fmbYcfVBAOXy4p79kuDlu
	 yjiEOhkWq5oQQfdqoqcT1lEGgxTfSPlbiQufFLebdyf5F+dot/DEGvo5QMaBMdrUCZgwF
	 DOMNYpucT5ETzzwtRbgDACuS9SqNKAHjnHHkFzvhBLEwwJHVOpPQ/r0K9HI1ADWe0qQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794333253;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=ijpH6hj1nbOY9kXUzX5qrbRPqN3iAnkRI6aZvI9cOiw=;
	b=u/oZcnu/uZSABG0s0/2UkW+L0oZPLboT+ztefmuxnGI2FNaHD5sJlkb0YCnZRTCtpxNJ
	 SGbNOnG8AnobVo+j8O/P3uOHNC3ln/GyCFhzNJYvbpuuY0xlJvY9/sSAweGK9WpEVZiZF
	 sSrwE8zSMdBMhmb1Uk0HYygHDoLOwHuQnZM8Ab1iIS28otSaNqj1ijTR/npvgIKTw9cn2
	 bM152u1rhYRJK/yMpVbCx8K62XPiw1dHalUCdTiwmONNcrvNc6UXMzHcYbFgM3nIz75Qy
	 hoJGjhrM4D+fvDE/kF55e43gsGjdEe7ZwqWLMngMb/VvLelH7OKUEufphaMBQgs6c3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=IThrzYtU;
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A0A606A236;
	Tue, 10 Nov 2026 17:54:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A6A0A606A236
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=IThrzYtU
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4jPDmh1VW3z1XM6J7;
	Tue, 10 Nov 2026 17:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1794333249; x=1796925250; bh=ijpH6hj1nbOY9kXUzX5qrbRP
	qN3iAnkRI6aZvI9cOiw=; b=IThrzYtU4kn2dOlCFm6NU9jma5SYsLzGM9+pUOwA
	jJHnSyQHyG0m6xIE94WgtL1YeOpMlVJ55Eknd0MoMcaQ7Uz6qTGHjDSAwa18Dm2k
	DtsHtpTAblg+8rbxajBCAcBWoO6AUuQ4NHVZOKPbruKZ3H8qCFBdQZ+4gkAIOOYu
	dV02LgFWNyGdVKA6Mbz4PEUPICrm+1Zxsf1roQF9teP9F4cuXR7EmtfLcT1j7pK4
	h7CllyKaHjkun1DOnTGsV4DMIaa3mPZlbb9rnlUkCrOWKT3yfJBUoI/rSVXoo2eN
	8VwgWsnKChxGReCYd3bwoRmXgxZW1UfavIiBKEfwnluC0w==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id iE77TfUA1A5o; Tue, 10 Nov 2026 17:54:09 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4jPDmd0XVMz1XM6J6;
	Tue, 10 Nov 2026 17:54:09 +0000 (UTC)
Message-ID: <d3e3ee33-0324-40fb-bca9-137cab1a818d@acm.org>
Date: Tue, 10 Nov 2026 09:54:08 -0800
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
Subject: Re: [PATCH v9 3/3] scsi: ufs: core: Limit early link recovery in the
 error handler to runtime PM
To: HOYOUNG SEO <hy50.seo@samsung.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, mkp@kernel.org, martin.petersen@oracle.com,
 stanleyjhu@google.com, peter.wang@mediatek.com, alim.akhtar@samsung.com,
 kwangwon.min@samsung.com, kwmad.kim@samsung.com, cpgsproxy1@samsung.com,
 h10.kim@samsung.com
References: <cover.1794275305.git.hy50.seo@samsung.com>
 <CGME20261110020748epcas2p25076a34f183116ca4d8714dacf214958@epcas2p2.samsung.com>
 <2052256418.81794277203434.JavaMail.epsvc@epcpadp1new>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <2052256418.81794277203434.JavaMail.epsvc@epcpadp1new>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/9/26 6:03 PM, HOYOUNG SEO wrote:
 > +static inline bool ufshcd_rpm_transition_in_progress(struct ufs_hba 
*hba)
 > +{
 > +#ifdef CONFIG_PM
 > +	enum rpm_status status =
 > +		READ_ONCE(hba->ufs_device_wlun->sdev_gendev.power.runtime_status);
 > +
 > +	return hba->pm_op_in_progress &&
 > +	       (status == RPM_SUSPENDING || status == RPM_RESUMING);

hba->pm_op_in_progress is modified by __ufshcd_wl_suspend() and
__ufshcd_wl_resume() without holding any lock. Please use READ_ONCE()
here and WRITE_ONCE() in the functions that modify this member, or at
least make the patch description consistent with the code ("Both
values are read without locking" while only one of the two reads uses
READ_ONCE()).

Additionally, since this function has only one caller, please make it
a static function in ufshcd.c instead of adding it to ufshcd-priv.h. A
name that makes it clear that this function checks whether a runtime
PM callback of the WLUN is in progress, e.g.
ufshcd_in_wl_rpm_callback(), would be more accurate.

Otherwise this patch looks good to me. Please note that the
correctness of this patch depends on patch 2/3, which needs to be
revised.

Thanks,

Bart.
