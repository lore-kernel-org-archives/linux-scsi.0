Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793728296;
	b=fOhxYzMWvlnmh6BDz4VCqe/4YyKA/25JiFIexbs/+MePXM9SsIq+u9SUWuwzl8xxyAr4
	 ioF6fW8TTwm7sadljUaPX8mRHnESYDBfnfjkW1UWLBvYsUe5RU1xPqMQD76MJ39pwlewq
	 weja7XdwK9JJxj/CNm4uWJOH1hfM8PJUkYkW6DyGAIZMFDASZJUF8zzEIq+BVLUEzg9xl
	 mg2OOgBmtnQi3X57Ebb4Eroc4CCGqdRaumkRupCO9Bdxo0zkc2S+hKNiyt6Ekek+FFkNL
	 lsAFw03Ium3sdPm+kW7zfbNGVmTMeAEGC1o+GFvc21pHGVe6ThdC6LLWBT1dbZPZ81Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793728296;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=Fqeyvm7FX0eXD7hMo/JywxL4ZlWhm9hN7Af29X1fAyI=;
	b=mcriLMYPpBHen9AYb8iHYok9L0wXeEVbzvPW8WOQHW0bVIqhC21KWK+tucWxnRpFM2Fv
	 sE4wmri8gQXWXXovwStniakbWbNudZry4QgVYRbNn8yJc3rAhZPyxMW9mQ3YYd/m8r96o
	 OJA1iKR2GG/uwpDQpA50/XDNon4Oti3P8KNGuWXxRlC3y9+S8nL2aYnOxuSEAc6S5IsdR
	 6qF4pVMnxdNC09/ZDbs/q8WdTdXVRyIA3pQPue/GJjfWTEJrX1PGQpME5rttU2zUGYE/1
	 WOtTTaBt4yBi8EAbx4YkKvBUPIV+2WshBmcWzIWdvutoq3mSl12IX37S2sdjmCmlLgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=o+rtQdVi;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2BC8606A334;
	Tue,  3 Nov 2026 17:51:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D2BC8606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=o+rtQdVi
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4jJx2v1fNGzlfwgF;
	Tue,  3 Nov 2026 17:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1793728293; x=1796320294; bh=Fqeyvm7FX0eXD7hMo/JywxL4
	ZlWhm9hN7Af29X1fAyI=; b=o+rtQdVipGe40JYePYEvDhDJML08S1p46tuQbcz4
	p+mZSuZBYqdyWOHFskCIEEoE0ZJw7aE9POPWMZmXkv07KrfxDlsDbdIBbZW8HGyN
	TjQ0bjQXIqVHTwoPgomtG/ne5+cSJSaDOO6ju8Ouvhp8JVm7CyH1n64I+UUJRclH
	wchLxVrbKX3HPCmaPsPl1k+aBryAMwqe0oEXcH2PDMowYUAJQMa59fkPiqtVFZ6r
	KMHz5uNMolE6NMmxSVIj6CPidn29w5w/P4egt/Mr3VBm0FquXUUJKmZ6oCBw6fGB
	nQF2a/2uPglyxKK4RKuKWaHR7FA+++0cDU5ZsIki+R9mYg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ENP3WjZl7kaH; Tue,  3 Nov 2026 17:51:33 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2ed2:d:b098:ee7:dc7c:db4e] (unknown [104.135.182.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4jJx2r4sZLzlfvpW;
	Tue,  3 Nov 2026 17:51:32 +0000 (UTC)
Message-ID: <4f38227c-a524-4d42-a3e4-ad0157939b41@acm.org>
Date: Tue, 3 Nov 2026 09:51:31 -0800
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
Subject: Re: [PATCH 0/2] scsi: ufs: fix an RPMB teardown cycle and a shift UB
To: shao.mingyin@zte.com.cn, martin.petersen@oracle.com,
 alim.akhtar@samsung.com, linux-scsi@vger.kernel.org
Cc: james.bottomley@hansenpartnership.com, peter.griffin@linaro.org,
 beanhuo@micron.com, stanleyjhu@google.com,
 linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261103185229490gmhePBF5_11x_thf4X-Rw@zte.com.cn>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261103185229490gmhePBF5_11x_thf4X-Rw@zte.com.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/3/26 2:52 AM, shao.mingyin@zte.com.cn wrote:
> Two independent fixes in the UFS stack, found while reading the probe and
> remove paths and the task-management hooks.
This series no longer applies. Please rebase it on top of Martin's
for-next branch.

Thanks,

Bart.
