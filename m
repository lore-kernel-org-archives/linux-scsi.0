Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793940377;
	b=R/Xs8GM0ilroJCazM4oPUPtVIqnesX3y4Gm3xwt01meqYC8mQ2+j6/3K2TpzAL1Q2cSa
	 ahMviERy3T/hhoGL//NJyneBX6SoCDP03oDZGLmJ7ZsyMmU07B0rbeRERHVjvD8ysUBrG
	 MVDXScQ9TX+96nC7tTn9zmWyRfY1XuTR3gPKwN+YFl0j2G+OiDt3o+4q3rXnUEcmA8Km+
	 ZAxKqZ0UnrFuuE302A6KgZPuuFr+1HnDPUtuxaz6ZnoC8nmJFD6OLgBdDPM+KYZ49B5dH
	 UW98yvO13CvRou+7S/7NZ91ywdaPky4iT8+jRek8WWOcCsNyo7MJYZMnko2atmoRRaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793940377;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=ujJweeX8qITox928eFn3cQoAcKyfkaVR0X9Gvjt0uRg=;
	b=Fi1EqMo1wUJ9qzRuxbS+QLtnMw+Ij74ehCZubhdbPvljEzerIzb7x8G14UK9KTO3VIZQ
	 EcMAgTprwUIfmNAu+Uc1u3UwZPBdTSh02PO2dCV2XsO1mLDcK/l0TBAgbfdOZoHB5lKwQ
	 Dz+dwvWJJOQB9sBLbc1JeD8ouY9BSvIGFu1zH4BkAIh3gyiFPQkg9NqCk5uCTgVLarhYZ
	 5OOISd/X7pEv7lx9RlRKWD20W2/+xTmFfLshPB/jiRvoIuYnEYvg2k+diVIJQm7NbMSi/
	 +L8p5mHpa63fdhMeMCFl7ckKD3qdlIiXeJ1oVWihL8X/ZnAxGSDDVs1u4dWgeWkmvfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=NwHCypQR;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996AF606A326;
	Fri,  6 Nov 2026 04:46:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 996AF606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=NwHCypQR
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4jLRTM7535zlfvq9;
	Fri,  6 Nov 2026 04:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1793940374; x=1796532375; bh=ujJweeX8qITox928eFn3cQoA
	cKyfkaVR0X9Gvjt0uRg=; b=NwHCypQR7B+SSbzm/pbMhzBKfErGLe/OqHsFYSBZ
	AUST1EA5iR6ayAeUUrtPd11eT7kGiRP1Q5X5nhId19fVpsLBwcfpwTPybuh57Viw
	NKvavvedu/C3MBdiVtBC6kVeHnNr8PPYf+XANnRBVrtimMnBJDZIaO3+JgzuBytw
	m7AxjeQNXGLT2qwToaFGnD5fg8zIcLaoACIH1k+XPLXtm1U5lptYz/N6LahDb8wz
	PF2zaZ87AiHbja7VDkvod1Vk3oRyCq74oZVbTU++IUIrExoPrV2WW7R/uGVTkkF/
	XflFC+ebI8+WyshH+5WoXPBCfDH1MeVMKYOuYK+//kYRYw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id yp3lZjR_c_Tc; Fri,  6 Nov 2026 04:46:14 +0000 (UTC)
Received: from [192.168.0.215] (c-24-6-239-25.hsd1.ca.comcast.net [24.6.239.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4jLRTK51Spzlfvq8;
	Fri,  6 Nov 2026 04:46:13 +0000 (UTC)
Message-ID: <788a942f-6c6c-487e-87c3-25eeb823ef95@acm.org>
Date: Thu, 5 Nov 2026 20:46:11 -0800
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
Subject: Re: [PATCH v6 1/3] scsi: ufs: core: Clear saved errors in
 ufshcd_link_recovery()
To: HOYOUNG SEO <hy50.seo@samsung.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, mkp@kernel.org, martin.petersen@oracle.com,
 stanleyjhu@google.com, alim.akhtar@samsung.com, kwangwon.min@samsung.com,
 kwmad.kim@samsung.com, cpgs@samsung.com, h10.kim@samsung.com
References: <cover.1793931113.git.hy50.seo@samsung.com>
 <CGME20261106022020epcas2p397f84c634df3397fcb1c98d1837bb83f@epcas2p3.samsung.com>
 <a0b59fb709e8c53a72e2839bb6b1635a4a20f395.1793931113.git.hy50.seo@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <a0b59fb709e8c53a72e2839bb6b1635a4a20f395.1793931113.git.hy50.seo@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/5/26 6:15 PM, HOYOUNG SEO wrote:
> ufshcd_link_recovery() resets both the device and the host and then
> re-establishes the link. Unlike ufshcd_reset_and_restore(), however, it
> does not clear hba->saved_err, hba->saved_uic_err and hba->force_reset,
> so the errors latched before the recovery remain pending after the link
> has already been recovered.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
