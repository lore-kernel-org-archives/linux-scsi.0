Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522C92BD1B;
	Wed,  2 Apr 2025 04:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743566715; cv=none; b=sIXUVwm4qREYZgpRn0P4FpTpdYro9mhrq5EPOSaLSoPzuHPC1/azhHRg7tYGky3/jHW1Fpbuqcj50ghtUSg35Xzlgh/FxUkjwIeKUxhIT09CJmqSQVANeOUvrujPePW0ANkUWCQ96QAG2jkTLZ6wD5Ibv3hSH3SQSeDfoWVgeu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743566715; c=relaxed/simple;
	bh=hWiyRl/X/9yeimNvdCKJD8krnNXHk+4afQS0MlH+8vs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QsWQZs5MmniWG0fV0MvMEEczyE1SJhHI1m9+GoDRMoKKljKUz326nLcLcCF8XXUz8XhdigfHmWJ3q8wclUz3AvFFELVskUFO7DsUajXZFhqz8kovNC8J2fXSZaYIWgJTICFtjWTqgEBs87O2kYWCVv2zRLktYosBGzcskY4TO50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=RZsmeRfC; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="RZsmeRfC"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZSB940VhBzm0ysj;
	Wed,  2 Apr 2025 04:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1743566710; x=1746158711; bh=hWiyRl/X/9yeimNvdCKJD8kr
	nNXHk+4afQS0MlH+8vs=; b=RZsmeRfCr1psvAgRfghl3TT75+T22z/B8oZVqmE3
	JtvttOv97mUwumG0OQKG6zYuvFY+PzrqsPlMkQSYyhyPt3P4Skf2vwnE8ILv4ufC
	QiagAkoqOBe1Cr18F/nMqm9uGZAiHzO8Zl5THL0DGfB7Vm0PRqC9ZmC7jlEtEik/
	ji9WQRS+C3tPU4JPZ22R4L11oO0Nn8swzRO6S+CtMGTt4D40Jk9GVirgHk0iJJ1X
	EqoCjxM4oY5Ml+ZDlOh78IDhZ+S6yQQ3FpJ/Im2MuIyP2993Wc52wVt79L38xryg
	plScsK7DH/3CbtiR3qXTOgxN/h6Q+/+/R7s3ra+TpsQDHg==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id GLPDgmGgjL2c; Wed,  2 Apr 2025 04:05:10 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZSB8p2NFGzm0yVc;
	Wed,  2 Apr 2025 04:04:56 +0000 (UTC)
Message-ID: <37bc5aef-2c88-4e7e-99dd-8407e988c355@acm.org>
Date: Tue, 1 Apr 2025 21:04:55 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] scsi: ufs: core: Rename
 ufshcd_wb_presrv_usrspc_keep_vcc_on()
To: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, quic_cang@quicinc.com,
 avri.altman@wdc.com, peter.wang@mediatek.com,
 manivannan.sadhasivam@linaro.org, minwoo.im@samsung.com,
 adrian.hunter@intel.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 open list <linux-kernel@vger.kernel.org>
References: <02ae5e133f6ebf23b54d943e6d1d9de2544eb80e.1743192926.git.quic_nguyenb@quicinc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <02ae5e133f6ebf23b54d943e6d1d9de2544eb80e.1743192926.git.quic_nguyenb@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/28/25 4:17 PM, Bao D. Nguyen wrote:
> The ufshcd_wb_presrv_usrspc_keep_vcc_on() function has deviated
> from its original implementation. The "_keep_vcc_on" part of the
> function name is misleading. Rename the function to
> ufshcd_wb_curr_buff_threshold_check() to improve the
> readability. Also, updated the comments in the function.
> There is no change to the functionality.
Thanks!

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

