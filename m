Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=160.30.148.35
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793735384;
	b=P3ZHhQqNNk4l55tqPQtiDZrjhVUE6yN8UZ9HvkzQUayaxvgtVvrU6LZRRnFS9Xrmez+9
	 bW1JSeV7TK9qXALkzPgaDzMTQF3LOYlx066wvNJEt8kg8lkL7cRIDi4agMxCj5t++y8EU
	 oFS7q2a5o2zow19N06aapXI1GJUv4uJZeupAn19pTXNKCW6jyadbAmEJtgRpgTzOKTRZh
	 MuFa7H0+DUZ2G5sFOiZTEBVI+u38xkGgtDfVppH1QhEgz7qjzinNPGLKJFVQYWpCpd5h2
	 YGY4cFFAEdhb3cB7qgwyiIwC/8MTR7gtbjLvNvH/gLAAGyhtw9l397tu7n1NzAtbfUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793735384;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:X-Mailer:
	 Message-ID:In-Reply-To:References:Date:Mime-Version:From:To:Cc:
	 Subject:Content-Type:X-MAIL:X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:
	 X-CLEAN:X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=4vPuarKyRMKeh3rN+6+a8c86tLfNuc2zV04pU1af7g0=;
	b=H8RDjVs9pjfulwbrt/iFWvw45xKcv44izEaPZlS7gVMrvRAQx7mEHNiQ/N7aiTN487Zw
	 A59F2XVvhNbspXIYxBWmeG3pWgUtLb4ix3rhpfw1QK02RbxDN9MxGbajoziW/fSasgejN
	 rleSZ3L7QsTQalEkvApmdd90gAp683/MheBlaBYygZZGPTQjFEQ7YPOco198GBgEftnJd
	 n3K3G9jBC45bM/6i03oygn0oNT3av1cIO34RRynUBxhYR/MpkQ9y/783YodSvau/90BrU
	 3gD6ym0Rdmmy/PGr1kHgmYeZbZZeyMOK/X2ukZjrF+3UU4T27uEcyB8vPRrQMDnYl8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=160.30.148.35
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C813606A324;
	Tue,  3 Nov 2026 19:49:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1C813606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jJzg93bQ7z8XrrJ;
	Wed, 04 Nov 2026 03:49:41 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl1.zte.com.cn with SMTP id 6A3JnWaJ010926;
	Wed, 4 Nov 2026 03:49:32 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Wed, 4 Nov 2026 03:49:35 +0800 (CST)
X-Zmail-TransId: 2afb6aea3acf164-ff67d
X-Mailer: Zmail v1.0
Message-ID: <20261104034935427D1IVl2AY_0fcWTEaGq7-g@zte.com.cn>
In-Reply-To: <2ed72d06-a938-422e-a62c-562f9efbb62a@acm.org>
References: 202611040259247915t_cYYK0k5pPbEqfdTAQu@zte.com.cn,2ed72d06-a938-422e-a62c-562f9efbb62a@acm.org
Date: Wed, 4 Nov 2026 03:49:35 +0800 (CST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
From: <shao.mingyin@zte.com.cn>
To: <bvanassche@acm.org>
Cc: <martin.petersen@oracle.com>, <alim.akhtar@samsung.com>,
        <james.bottomley@hansenpartnership.com>, <peter.griffin@linaro.org>,
        <beanhuo@micron.com>, <stanleyjhu@google.com>,
        <linux-scsi@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2MiAwLzJdIHNjc2k6IHVmczogZml4IGFuIFJQTUIgdGVhcmRvd24gY3ljbGUgYW5kIGEgc2hpZnQgVUI=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 6A3JnWaJ010926
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Wed, 04 Nov 2026 03:49:41 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AEA3AD5.000/4jJzg93bQ7z8XrrJ

On 11/3/26 11:28, Bart Van Assche wrote:
> Please take a look at the attached review report from an LLM.

Thanks, I went through it and verified the points locally, including a
KASAN reproduction of the devm lifetime problem with
CONFIG_DEBUG_KOBJECT_RELEASE: devres frees ufs_rpmb when the host
detaches while the delayed kobject release of &ufs_rpmb->dev still runs.

I'm withdrawing patch 1/2.  The ordering it adds is already part of
Stanley's v5 series (2/3, "Decouple device lifecycle from devres to avoid
UAF", Reviewed-by: Bean Huo); that patch also allocates ufs_rpmb with
kzalloc(), frees it in the release callback, pins the RPMB WLUN and
guards rpmb_route_frames() against teardown.  Mine only breaks the
refcount cycle and leaves the ownership unchanged, so it is incomplete
and a duplicate.

I'll resend the Exynos BIT() change separately, as a cleanup without
Cc: stable and without Fixes:, and with the nutrs/nutmrs description
fixed.

Thanks,
Shao
