Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3979F2DFF0B;
	Tue, 17 Jun 2025 15:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175958; cv=none; b=dFVpUKhMze0ZCuYabNwBXgP3c2apsgMGS3hjY6B7bOikyf0SMGF5QIoIEXrfZtXGKG4HgDPV++WMfdNDqCrUDARCFBSUVwF8+bVp53z7HIFmxf67Q1CIgiJe7w4a+DwM1QFm6LJRVxeLOi74py9g9j5gda/QVKtcTL/YTjR7TC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175958; c=relaxed/simple;
	bh=IQ6N+mQELJxCRKCRP+4y7p3FkeV/Wx9FRuFOmOxh4Bw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QAp3lgENGv6XpWcuOXZFsIpmpS+Zc7Icss3ngTFVjc/r77ATTywuK8AytYxEsGkZmFM8jO4E/5Y+SEuRvqfTKh9+wFZauj+2GShACTZcP4/4EtDZ7Q0daJpRCLlhX0M+mVQyRIFegC0rE7RFmnM/M/qMwG4hwZJBmGHsQlz8bOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=1p+XzA11; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="1p+XzA11"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bMBPt0lbBzlgqVt;
	Tue, 17 Jun 2025 15:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1750175952; x=1752767953; bh=GHrVGqBNCoBBXZwBA+OhrI9r
	0+p0Q/Hz7tkNzq9vv1o=; b=1p+XzA11h3205qWpxFatgFRy4dgxX1XtG78jxls9
	+Xkr3U/qfLNmwEn4kCVgfy7ubGByh7cEioINFtJ30pgv5XlprKyy6Y8fiRr+1xMt
	IgcK15PMCPWSi2+C2h8gJt81CZg70WX/Xp95CSQv5qFWWZ7hdYUJRngPAhKP5M0A
	VIgehqrP4nFxkpjBbuF2QkzIjP1EjSlwA1Wqc8U8QPr2GYnboFGEPdQpNNtgrEkO
	aP0ynrf4FZD6TxS/ezU0x9ia4vEh2fflMh42oFxK16CZRMyhexEh0HL5iPNLW8z2
	7gnvIQzuDmUSeS67qqypdbIJdpjaVJcwyov+MV8WnywtRQ==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id QmOWDOUtjq7N; Tue, 17 Jun 2025 15:59:12 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bMBPp2CqTzlgqVx;
	Tue, 17 Jun 2025 15:59:09 +0000 (UTC)
Message-ID: <74b7ed8e-2de3-4498-9add-5b50d010d496@acm.org>
Date: Tue, 17 Jun 2025 08:59:08 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: ufs: Document NOP_OUT transaction code
To: Avri Altman <avri.altman@sandisk.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250617095611.89229-1-avri.altman@sandisk.com>
 <20250617095611.89229-3-avri.altman@sandisk.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250617095611.89229-3-avri.altman@sandisk.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/17/25 2:56 AM, Avri Altman wrote:
> UPIU_TRANSACTION_NOP_OUT is 0x0, which is the default value after
> memset. Comment out the explicit assignment and leave it as
> documentation.

This description is based on the assumption that the compiler only
initializes the data structure members that have been mentioned 
explicitly. That is wrong. There is no partial initialization in the
C programming language. Structure members that have not been mentioned
explicitly are zero-initialized. All structure members, including those
that have not been mentioned explicitly, are copied when performing
structure assignment.

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index c2048aca09fc..84165b45467d 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -2835,7 +2835,7 @@ static inline void ufshcd_prepare_utp_nop_upiu(struct ufshcd_lrb *lrbp)
>   	memset(ucd_req_ptr, 0, sizeof(struct utp_upiu_req));
>   
>   	ucd_req_ptr->header = (struct utp_upiu_header){
> -		.transaction_code = UPIU_TRANSACTION_NOP_OUT,
> +		/* .transaction_code = UPIU_TRANSACTION_NOP_OUT = 0x0, */
>   		.task_tag = lrbp->task_tag,
>   	};
>   }

This patch probably doesn't change the generated assembly code. So I
don't think that it is useful.

Bart.
