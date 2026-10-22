Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792702195;
	b=mbvh5F37CzrXGoSOLqMbgOsov3FyUP1olKnCIFnTz9Cp8MtGXaNN3HD7Slo1HKPmrQRV
	 o/32mKNbFsz8PI572lKpkz9LW8S6hTYlE8fsRcskHrUYhrQi5yjqLY8KaR3LLEVPMymAF
	 M89HDvh1uTqeniOWWRlr+uJUYJ1d9UrkWJeDWQQnyPDTOaOYNVKo4uyxIzWnYyF6w8tUq
	 U5qpCA0UtzwtT2P4yAYZxVsXj3ffokVk0jf53V2nnc6C32f5QuXCaDwjIvehEVO5Okboc
	 61M1MP5ZUY5GNB93mLsd12JXZS7z4wuR7KLLBl5DqDhcG1GaWPUW4PkVePnO2LuVCEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792702195;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=Auw/ZO+OpjhP3TL54hi6n0qe9cpVdwdE8F0+MSdgCwo=;
	b=LRWrJzU87GjXaLRt0kdUokT9BRTt8KLtEpL3eB7doiS0MlDFsVq8s1erVRBfOMgJGQge
	 /IRcH8q4A5+RuZR52ZjsxAx+Bvle1G6PkmDq04lgm7DjGKnhfvk/X0oXya2ayWlRwU/w6
	 lFV8cDL5Omq6iYThbD/ZKtucXmTXFuYCXC9lbP8M4LkifWKEJlpHKXdifNUFxMS2gKVuw
	 yMjKSbWbZo+kIaFGKsk+Lc6QgsiNQpgusnVRLNOg0WKeQ3pDRSXq6KXL9fOVpXQlcU2ex
	 Vysjp8BA+bXbPylcNs0dhxw1Aef67wKrl8uQmK+GA3ii7CMAx1cP4rS+UHYD1hLI/tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=o639aX9p;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF225606A319;
	Thu, 22 Oct 2026 20:49:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BF225606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=o639aX9p
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4j9dZB15b3zlfvpy;
	Thu, 22 Oct 2026 20:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1792702191; x=1795294192; bh=Auw/ZO+OpjhP3TL54hi6n0qe
	9cpVdwdE8F0+MSdgCwo=; b=o639aX9pVAaMwCCICHq4zQdt2loNZZMUMPpz84cy
	64MmyLnMNZKTxCWarFYES5wD7VMJ5zjzjg51OA6c4koc060sAD5Yg7Sk/ZpGqM7j
	aYxl/Fd4PciVtK5F9YZOWLxOhS4Pa/SNB+fuVkTXZr+qFGnLpuwKrFistM37Y/eS
	N6d4oYPLt5BUKutVIGeZvuCaSWFIaqqvLi98pst5Axn8Lw1ugGsqq266XbAuioN/
	Vj704W585Q4jLhmB+qO8mK91gAK3sLYcBTLkl4j+YHBe3jHQkdHqYKOzq/aQr3BO
	ctkhWKw6m11tLaBdsA+6+s73XE3vWxkgJ0Jpqt/MIqLJiw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ahxz7hEk6AAw; Thu, 22 Oct 2026 20:49:51 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2ed2:d:356:46f6:e804:1d44] (unknown [104.135.182.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4j9dZ70HGBzlfvps;
	Thu, 22 Oct 2026 20:49:50 +0000 (UTC)
Message-ID: <5fcd439b-4870-43db-9402-cf2425754db5@acm.org>
Date: Thu, 22 Oct 2026 13:49:50 -0700
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
Subject: Re: [PATCH v3] scsi: arm: Convert acornscsi-io.S to C
To: Breno Rodrigues Alves <breno3011alves@gmail.com>, linux@armlinux.org.uk
Cc: James.Bottomley@HansenPartnership.com, mkp@kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261022183658.58090-1-breno3011alves@gmail.com>
 <20261022203053.75161-1-breno3011alves@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261022203053.75161-1-breno3011alves@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/22/26 1:30 PM, Breno Rodrigues Alves wrote:
> +	while (length >= 2) {

Shouldn't this "while" be changed into "if"?

> +		u16 v = get_unaligned_le16(buf);
> +		void __iomem *cp = (void __iomem *)card;
> +
> +		writeb(v & 0xff, cp);
> +		writeb((v >> 8) & 0xff, cp + 1);

The above code can be simplified as shown below, isn't it?

		void __iomem *cp = (void __iomem *)card;

		writeb(buf[0], cp);
		writeb(buf[1], cp + 1);

> +	if (length >= 1)
> +		writeb(*buf, (void __iomem *)card);

Isn't the above (void __iomem *) cast superfluous?

Thanks,

Bart.
