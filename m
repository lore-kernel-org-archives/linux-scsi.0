Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794248400;
	b=NLE7pm5sP1rkVgGOSBEYThb6Qf9SuLBuC7Mgcgapp72qtVlHh/SRI04bvwG+jIyW2IeD
	 C4SiDzuxLqmRUqR0Q0P3fNfnuOYMpgpzB8u4Te6OrHyvmrebeMh/79XrMLR+xc3xoDPnv
	 PYs50Te2ush07gyUfLtRKHRABkYzmvhpjplufxYQ2DE+/eYdo5WidzvQOiRm89I9wIqxI
	 8JQBPfjMx8K+fuNPf2rDhjk6iPXH6E89q4Q64d/XWkLghQXD1ddklQ9uhDEZWFWlUruGQ
	 7uhEtFQ+ml9hbJANgkNy4l8gG1USM1cXu38GZJZ7CXr4wqLcqsTaoYg6+eDu7KjN+YA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794248400;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=t6KaJjDKYgdsxCn/x+DcOuRyLRSrJHR5bZ1fNs67esU=;
	b=JtGEsGaOnwbxsD+PJSLtKcG5hqCYE/WUL0kXRBHwtip9A5adrJxk/U7gRg9D7q69s5Bz
	 PMFUlCpEv+ZY+oUnIxmgnkOXwHXMg4b4ZLxbuyCpPKkFyrSRIggBWtmxqRxGeu8QVzDjW
	 PkaA256MEBMh/eefEM4kl3h57qdC/WUSTzbkzZFVPrg+WMqx+PO58qN9fYecfDwZmXAyF
	 KdBEnBI3NCidt76lsJLBXCN7z51hHj6UtfwCp0TbU1BN1UVmTjW5T6bPM+Mr6/YMjWg/W
	 Eyf4Rdsibvh/7nd6IFjv7hoi1PL4O8YmHBOepFvtbI9/HX6InbCqF7S+JDnjbx43S+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b="r/SqOy+3";
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E27606A325;
	Mon,  9 Nov 2026 18:19:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 91E27606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=r/SqOy+3
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4jNdNn56z4z1XM30h;
	Mon,  9 Nov 2026 18:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1794248391; x=1796840392; bh=t6KaJjDKYgdsxCn/x+DcOuRy
	LRSrJHR5bZ1fNs67esU=; b=r/SqOy+3CO2pEJ1RMWjgQgxEuel2MYJip54GsQFg
	tmfkpuwReDEz4wLFwcjGjW03owqNJf06qcpJrWMt9mPZPmRJJPAOdx20qzXL3wtQ
	O6wHv0pNWtn0MGStu2vxeUiZKyUVgkJ38nUWuod0OEFqZXvskCJUSgjuD1uL3S+2
	p4V36MlBi/yJsfhtbmBZNVGC5bZsCG3XSrpP6vvOzpS4Vno0QM55ONaAuz5euT96
	Dn+nwbiVW7HzyIHl4sKUIorH4W4taJvH/SZAhfHvczs1RhZfYAhoZK8Y81C//SZ8
	PIEwqcsBLGOZgnpPt9KQHxWV/XqoupAU+vsT18XfBvxtFA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id y0eBIHRfhNv2; Mon,  9 Nov 2026 18:19:51 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4jNdNl2Kjwz1XM5kD;
	Mon,  9 Nov 2026 18:19:51 +0000 (UTC)
Message-ID: <ad6c8019-15b1-42a6-8bea-bf74533522b9@acm.org>
Date: Mon, 9 Nov 2026 10:19:50 -0800
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
Subject: Re: [PATCH v8 2/3] scsi: ufs: core: Hold host_sem in
 ufshcd_wl_poweroff()
To: Peter Wang <peter.wang@mediatek.com>, HOYOUNG SEO <hy50.seo@samsung.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, mkp@kernel.org,
 martin.petersen@oracle.com, stanleyjhu@google.com, alim.akhtar@samsung.com,
 kwangwon.min@samsung.com, kwmad.kim@samsung.com, cpgs@samsung.com,
 h10.kim@samsung.com
References: <cover.1794196863.git.hy50.seo@samsung.com>
 <CGME20261109041347epcas2p17b5c0fd7b693f92eb2af35b12a24de31@epcas2p1.samsung.com>
 <973576304.21794200282836.JavaMail.epsvc@epcpadp2new>
 <5fef4ff73511a2613beaa7accdf635a1c634c449.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <5fef4ff73511a2613beaa7accdf635a1c634c449.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/9/26 1:34 AM, Peter Wang wrote:
 > Although not checking the return value was an original
 > mistake, this patch would make the previous mistake worse
 > and cause a system hang. Could we at least add a check
 > to release the lock?
 >
 > +	ret = __ufshcd_wl_suspend(hba, UFS_SHUTDOWN_PM);
 > +	if (ret)
 > +		up(&hba->host_sem);


I agree with Peter. If __ufshcd_wl_suspend() fails, host_sem must be
released so that ufshcd_err_handler() does not deadlock waiting on
down(&hba->host_sem). Also, please propagate 'ret' instead of returning
0 on failure.

Thanks,

Bart.
