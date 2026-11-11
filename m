Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794407534;
	b=G7nL7b3zQVf/uui2/OShWiRaMr44KkhlTVx8GTaCehHOAs1mpZzPGPnS7i95MAOcb/hP
	 gVKt6UtV8olq5z8DRXLWruFYMKFPFtDN/sbTUUUfcfQoEHVLyhqVu6z6+nVF+CDQrJevr
	 NpqHlyHokpIknDSbmmnfQP0HcFEfimncUUnUQSFav+JQkfaWbgx3fk7cY6XqUXNecE6la
	 ZnPMa/cI8mYchI2R7YMATHM7T0JYbXf9rDVAf8qCOVnt5Z2thVJPSEEdqyExuo2a6Eiw1
	 mdlXUpYRv6ZPlGwdcZ9juA30h5SF/q7TVlXZYQvYDf7SjC/QP+lDXB+B3Qp5cRtEKaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794407534;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=pj2CCbT3jVjwPBOQvghJx+O3/vL8gLAVneV2ZUZ6KeA=;
	b=PuJ4ZCpuFovZaMbJD6FfG3xWrVD0DUBCAraMpBtIajWSwc22odkpdl+RuHgizD1Ipl/R
	 xGBVuImlSKBR+b+R75hvj/R6+hPwTvjutNvwHyGdq9rzJEIJgGUldkB6KS/n6xE7bNVAj
	 /ivjvB47vWAnashKH7dER9YWzVF3mGWIVbz8ZEt0Aaw9yyDYb5c6k5h6rQHIKl+ccv4C4
	 XNXLFIQPimtTAaQj+7qH6gCIh9C7XbcgAN6ufw2dw6tc1i12Krb877omTX/LnLUirjdMP
	 fhDB8kdYSaStVMMjRR9pKB8HV50+sTi6mz15l3H6ob+uABako5C8jHqM1nY45DUw0yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=v6tMadH+;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC76A606A8A8;
	Wed, 11 Nov 2026 14:32:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DC76A606A8A8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=v6tMadH+
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4jPmF92CY6zllB6W;
	Wed, 11 Nov 2026 14:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1794407531; x=1796999532; bh=pj2CCbT3jVjwPBOQvghJx+O3
	/vL8gLAVneV2ZUZ6KeA=; b=v6tMadH+UkimGfgL+UqkpR6ZHk3HTaJ4wYBbXGiS
	QPwe3Sanfr0XaNr9r2s0TFxH9uTvG8WSf4D68XdBW9yb+IGLONghVzHcZ8jRM3nk
	XB4U3idHE5FqEkDnu0LGidgISKxCfYRvLS74/YdUR/45iBXJfIjIKFSjKtgcbTwQ
	ID7m5rNrK3aRcBBKRfCtLez8xlj1fKG0EVpFNqU2IluYqJeJt/U9xCsk60kQmIpG
	3Qe1vORKk2JRhx8E2nD7Yj7qMdkia+4R7HKZbdQGw22M0RJZiLA0twGADu7Znquo
	SNipts2o5qZro/3itp8ikPFXbdDw3mf3OQtauVgZuK04CQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id BDiUiwxb5Jn1; Wed, 11 Nov 2026 14:32:11 +0000 (UTC)
Received: from [192.168.51.14] (c-24-6-239-25.hsd1.ca.comcast.net [24.6.239.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4jPmF63gWKzllB7H;
	Wed, 11 Nov 2026 14:32:10 +0000 (UTC)
Message-ID: <bb9771c3-2056-4a26-abdc-1ef1306ffeda@acm.org>
Date: Wed, 11 Nov 2026 06:32:09 -0800
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
Subject: Re: [PATCH v10 1/4] scsi: ufs: core: Clear saved errors in
 ufshcd_link_recovery()
To: HOYOUNG SEO <hy50.seo@samsung.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, mkp@kernel.org, martin.petersen@oracle.com,
 stanleyjhu@google.com, peter.wang@mediatek.com, alim.akhtar@samsung.com,
 kwangwon.min@samsung.com, kwmad.kim@samsung.com, cpgsproxy1@samsung.com,
 h10.kim@samsung.com
Cc: Bean Huo <beanhuo@micron.com>
References: <cover.1794384665.git.hy50.seo@samsung.com>
 <CGME20261111082304epcas2p4887d72756d51a72b94729439d25dd3e8@epcas2p4.samsung.com>
 <1384010761.101794387787447.JavaMail.epsvc@epcpadp2new>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1384010761.101794387787447.JavaMail.epsvc@epcpadp2new>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/11/26 12:18 AM, HOYOUNG SEO wrote:
> ufshcd_link_recovery() resets both the device and the host and then
> re-establishes the link. Unlike ufshcd_reset_and_restore(), however, it
> does not clear hba->saved_err, hba->saved_uic_err and hba->force_reset,
> so the errors latched before the recovery remain pending after the link
> has already been recovered.

For the series:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
