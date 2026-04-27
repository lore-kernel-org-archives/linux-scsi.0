Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A0E29C325;
	Mon, 27 Apr 2026 15:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777304608; cv=none; b=eZu7DIV8avBTiT/U5W9TMT2mIetGb6xul4xUMmGor8TXsfuGDnj+Xxs0/BbvjIpSBODLJYUCIN03oiKTbZDaXgEeHzuVyntwDFokNDElOwYDEx51NoT9UIVOj/u9OXLc54LbpI2BiuEm858V5zgZG7GeAQRV/dxUWd/Y1ZamHTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777304608; c=relaxed/simple;
	bh=bo0dzjYtrvdWf19YSaqNgbZbQR8Dz0tHyTrqPTzO1fM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ubpg2yPq/F/fmPzoP0l8Edeev7owguuhkX8uFKQe5B5euQojKpqOp8YaT8fjQBy9n/KDnH/bUsFjQDKZ+nezFW9bGVFuumR5EQGD5jH3kVfcCKBf0uAm9aVYVdSOKcc6cQASJs+Cbi+KhREK6CggWkj5vDSUxrV4iwQTDFTQSxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=G0fCgTE5; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="G0fCgTE5"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4g47Bd4nnZzlfl5V;
	Mon, 27 Apr 2026 15:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1777304598; x=1779896599; bh=hDmLsryRdBaOq6ergwAZFKH/
	HP1fZNCKKsGnvVjX+oU=; b=G0fCgTE5UU/wXx3p+6YLBozng29ybrxvlI1E8iy1
	XJ/aNUOQudoTLFw3O3X49ot0iCv0ctt/D/8jENgkB2/gwq7gCF3pD8EbBbe5xpRG
	9crZsTGxOrX8ESyPzxbKTOKEprzxC283R7eB1u/RRVH98/fSDr0RYELbbKSzb2zx
	e1I9g/oiv6hZm+vW3wKT3cS5gyV7Mb36NXJNc6VCucO6A9KbrL+il6VYouHrhPeK
	u+Zx+yXybEE+mwj+6PXB7Lw3qA0q3u73eVbvPFMeIOz+CizxtwVgB+H3j4tk4CDW
	twera0iWZVWp0eCZ+v539R/7c473RGhr2vc56QjJ/SNxOw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id EIofrjMLTe_4; Mon, 27 Apr 2026 15:43:18 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4g47BW4lx0zlfpM9;
	Mon, 27 Apr 2026 15:43:14 +0000 (UTC)
Message-ID: <f81746c6-b70c-4410-831d-8f3c3756d76f@acm.org>
Date: Mon, 27 Apr 2026 08:43:14 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: qcom: Unify user-visible "Qualcomm" name
To: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: =Bjorn Andersson <andersson@kernel.org>,
 Konrad Dybcio <konradybcio@kernel.org>, linux-arm-msm@vger.kernel.org
References: <20260427070048.18017-2-krzysztof.kozlowski@oss.qualcomm.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260427070048.18017-2-krzysztof.kozlowski@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/27/26 12:00 AM, Krzysztof Kozlowski wrote:
> Various names for Qualcomm as a company are used in user-visible config
> options: QCOM, Qualcomm and Qualcomm Technologies.  Switch to unified
> "Qualcomm" so it will be easier for users to identify the options when
> for example running menuconfig.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

