Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794602999;
	b=tJqF4P+0gI/qR5VXuxhr2RXAvFUdxvhCBvf7KsOkkh42cKPvBpKVOaHQZ27tU+ggKe8t
	 97jFMEdIXDYGaCMP1b/7m5KAuhxQU332RG6+yUVMzfe38vsxSKJTdYIEaH2BKfjBMp7Mw
	 r4UMiTuP0YYuzeNBIixTSCrD6uNUaTIjVF5ssHmBScOhT5Oxxg548biaX9M+dFLhRRJWH
	 VJlkM59cpp1ezP1c1LDjn+WNGids+c927YOyuq6cWYpzUWOvj2wbFYaknTjHjOmpT6oca
	 CMTblvLu6JvubBKsthduvD8Lpgd93j4h2ucigr+1r5iwvJyifg5oXcZYh/B1NmMj6HA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794602999;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=wQp4cMiNPkLkYwf2WcfeT7cPVif51d6+cweNW+as+Ks=;
	b=Vpnbg0M0LxqZdCW8PC7s+zI4aZcfVehp5jRFH1RyLQ6T4zia2qo5+FouVvA0Di9nlavD
	 sbiuWSL04gus4pCJZLU7K9cPGDpQMcb5je3BORyf9L1Bhk/Cf/mlpLXwQS1cchEKH6CJE
	 EmifCtSxWZOMymb48+m469iYfta6cJoFqG7rsl5ejfyBKLtQel+9RQr+m4c1RddPrkBzR
	 wPyCCJwm+l2MPsVCp2eA/r6r9RHbgvRH0aw985N2+YPVnTAlP3IExIUkBbRDWwBAUdKVe
	 4ilz+45v9occQbyy+t90LsCfu7cLg2DhH9MjbhZoH9Iau/dNpmHvvCtke1qZUoFC7HA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=JN2G7Ah3;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455A7606A338;
	Fri, 13 Nov 2026 20:49:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 455A7606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=JN2G7Ah3
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4jR8X65s4KzllB6b;
	Fri, 13 Nov 2026 20:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1794602997; x=1797194998; bh=wQp4cMiNPkLkYwf2WcfeT7cP
	Vif51d6+cweNW+as+Ks=; b=JN2G7Ah3ii5NMGVmCZx4rI7wH3354DV3gC3D0MvD
	sX13rYdqGbyGTzBZ/J6cjlzBvgpRj22kIeqzEwLBCHuhlnarrbuetjpyX8/SOmEA
	vc+r0tbsUtRPOl5nFeyLcWWjVlpxMj91yyjHDN4EdINUpoNunECkenAamLM+zGij
	2Q7OBALlST+Kua9eaYavzYn5Pgy0MAg77Q69n19DmTPp2T9ccc1w60CmvKcrrf9p
	9p6TqsvIm88H92QiT8y6tQ4KlS9jBpVeg915hzh+RO4rm+ivPp+NNUCyPqn+fddP
	2UuGDA+zgGM7KLEmxPt2hk9yVnWXqESJKHbOVXI0MrDusw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 4cS2IGCm1Kdg; Fri, 13 Nov 2026 20:49:57 +0000 (UTC)
Received: from [172.29.66.119] (unknown [104.135.180.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4jR8X52PL1zlgy1d;
	Fri, 13 Nov 2026 20:49:57 +0000 (UTC)
Message-ID: <0c5fa73a-2e48-4827-b0c7-dadaf6eb9bf0@acm.org>
Date: Fri, 13 Nov 2026 12:49:56 -0800
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
Subject: Re: [PATCH v5 0/3] RDMA/srpt: Fix command initialization and read
 buffer disclosure
To: Yong Liu <pkfxxxing@gmail.com>, "Martin K. Petersen" <mkp@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 security@kernel.org
References: <20261110030809.913063-1-pkfxxxing@gmail.com>
 <20261110030809.913063-2-pkfxxxing@gmail.com>
 <20261110052827.963143-1-pkfxxxing@gmail.com>
 <20261111065342.1282709-1-pkfxxxing@gmail.com>
 <20261112094138.1390409-1-pkfxxxing@gmail.com>
 <92a82300-a454-4ee5-a191-0ce5a2ee58c7@acm.org>
 <20261113083848.1517595-1-pkfxxxing@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261113083848.1517595-1-pkfxxxing@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/13/26 12:38 AM, Yong Liu wrote:
> [ ... ]

For the series:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

