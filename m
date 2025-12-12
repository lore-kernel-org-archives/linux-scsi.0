Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683ED2BDC17;
	Fri, 12 Dec 2025 16:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765558770; cv=none; b=ZcY5PVQouPhK6MQQT+4Ogh0ALe2/7rdFuUldx84Fgf9vZsEA8Bia1n9fTojg5n2yJbSMHaewrC143xy1bm60kc+2OJsrQ/cK+XwPE5EIVRHE/TzbAjGm2Y1umJy5Ra2nrIqvbC001z/xv8T4Gw9MOG0xFByi0g8Zry9cMf8qElM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765558770; c=relaxed/simple;
	bh=X8pY8ABvMUKpUTwV6vCvK060H4RCs4A9iKwJp7m3hyc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=AlRBHOQR1z6FH+m68J0q/FPCVbf2j5IMEVWq+YkEdiKR4fZ5dfdNo0My0S555IUdvWRolJF/7kPF7iCCvSGGrVBfPVB1yNj6NumEQaOC40M/18W6Vdl4q9kZT4/gZBKeEJWfYPcW63BhDrPMk+c1/SXcfnWiO6n+PsktDq3yshU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=afzG18LM; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="afzG18LM"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dSbK76LwJzlgxZ5;
	Fri, 12 Dec 2025 16:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1765558762; x=1768150763; bh=Y211rBP2wBufMYa2f6Q7iqBy
	HccoZa7QPKA4k6++KtM=; b=afzG18LMCJOTOVJvwqez60lneKSgiD9hxwCLmzHr
	CRWBuzVMIkElx2qb5E7M9/yhqc+jiBT1Kjo3eXk/PGlbLzqn3rwqEfI88vXCuR7S
	UH3qIoB4tDNZVRHwwdjuXTsfddjycjB1I812G8mtuiv6xgjxt+wMQo2Sd2jdxaKj
	2Zs1lZCVbH2GDcTUVpmpaHcmuSN5LNm6rN+jzoZwigIaHy3SEk1nr3rz4YoMh3oq
	AnFGQPdXx2YIEN7YQk4yoqqZJEN1ulLkgR4mXXRL+1brESChcgvZ0QPWBrtFs4VE
	kjEyQvmSZ2O5gIDMn9Q7EtMO0M45vDHCPhoQ0MC1SAZjJA==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id xe-5K5iArl3o; Fri, 12 Dec 2025 16:59:22 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dSbK53Ym6zlfftc;
	Fri, 12 Dec 2025 16:59:21 +0000 (UTC)
Message-ID: <7893102a-da39-4ac0-a738-410de7a5c078@acm.org>
Date: Fri, 12 Dec 2025 08:59:01 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: dt-bindings: common: Fix a grammar error
To: Zhaoming Luo <zhml@posteo.com>, alim.akhtar@samsung.com,
 avri.altman@wdc.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20251212131112.5516-1-zhml@posteo.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251212131112.5516-1-zhml@posteo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/12/25 5:14 AM, Zhaoming Luo wrote:
> diff --git a/Documentation/devicetree/bindings/ufs/ufs-common.yaml b/Documentation/devicetree/bindings/ufs/ufs-common.yaml

Who is the maintainer for this file? The MAINTAINERS entry for this file
does not mention a maintainer:

UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER
R:      Alim Akhtar <alim.akhtar@samsung.com>
R:      Avri Altman <avri.altman@wdc.com>
R:      Bart Van Assche <bvanassche@acm.org>
L:      linux-scsi@vger.kernel.org
S:      Supported
F:      Documentation/devicetree/bindings/ufs/
F:      Documentation/scsi/ufs.rst
F:      drivers/ufs/core/
F:      include/ufs/

Thanks,

Bart.
