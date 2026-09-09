Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66996576EB5;
	Wed,  9 Sep 2026 16:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788970242; cv=none; b=ug5Z15tfNUDWosd1lMDLALkxOMRrwOa6EqUjE6dzw977SOLUaHnOtQU2SpsbaSuv7KW4KS1FtI6o+eRL5h5BnFcutsvN1E0ZP+xERsoXEDkBVyLvaEt9qQUN6ZvjNRM4CrAeosSPAZrLQE0/mkNL6RQt94yS/nGCGDwSJ6VqLAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788970242; c=relaxed/simple;
	bh=ZPvRPiwLPr1FPQ1PU3R8Ow/4JR+ZdHFaVHXCEI6XBw4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GNdiKHYWY06XdXa6S/1kKr4CFkfKuHrU/qDzOnBoTTKjrJYXiFqJVWK9WqNaF7KQ5ldaeBaUHg7inko/CjIbWUNi5mrvwkrFU8GO3qigmCjfoCLc3g7BubK8n9ISoMXG9f2h76wvdOvRw9vF2ysLaPN/SD/qriljGUg1nzT1nW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=i555D44u; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="i555D44u"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hg5Pr53qjz1XM4Sx;
	Wed,  9 Sep 2026 16:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1788970233; x=1791562234; bh=pLj/Ofe7oVMEBbdIEYbnkuIZ
	aaXKaasGR5Wdd8zPo5E=; b=i555D44uM+30tM3kb9cZRjpqypwoNdtwtUktFI4g
	7qD9biquc7rVw4XnAEqTfb2S3JuAg17Harge+7fgMSyGldBmKPUcQrqWAyyaqPUd
	SAQjN4/S2rOvphW8LP7TVmfjwDnp5m2TwsRjib1Rcxr0ogNgLO7sxJzjd9tCfHFs
	rqfAUqDAzwVEa5E/v5sBIkXRrF+CxNTbMgI2HvmPEs0O/2syNw3fEG2FZFdqc77O
	XkRgGoypdQIv8+Cn571AF21GOEQHJRWfcVzE6DVlW8CQ4YrywoZlsQw5ZrJjz5xs
	8KsLM+nz6zZnzXEjmJnhTWQB6vC3LAHLESkRy8mdiJSOUQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id zB1bHIkeI3rz; Wed,  9 Sep 2026 16:10:33 +0000 (UTC)
Received: from [IPV6:2401:fa00:80d:9:bdb1:3a99:5373:a9ef] (unknown [104.133.214.195])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hg5Pc5VMSz1XM311;
	Wed,  9 Sep 2026 16:10:28 +0000 (UTC)
Message-ID: <45a04396-c6c1-41f4-ace8-0ee0ccbc50ad@acm.org>
Date: Wed, 9 Sep 2026 09:10:26 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] scsi: ufs: tegra: Add Tegra264 UFS host controller
 driver
To: =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
 Kartik Rajput <kkartik@nvidia.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@sandisk.com>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Thierry Reding <thierry.reding@kernel.org>,
 Jonathan Hunter <jonathanh@nvidia.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, Philipp Zabel
 <p.zabel@pengutronix.de>, Thierry Reding <treding@nvidia.com>,
 linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
 linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260909-tegra264-ufs-v1-0-e4a9831702a0@nvidia.com>
 <20260909-tegra264-ufs-v1-4-e4a9831702a0@nvidia.com>
 <aqFqhNA50674GtPo@monoceros>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <aqFqhNA50674GtPo@monoceros>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 9/9/26 7:20 AM, Uwe Kleine-K=C3=B6nig wrote:
>> +	{}
>=20
> { } please (i.e. a space between the braces)

The preferred style for Linux kernel code is {} (no space).

Bart.

