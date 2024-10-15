Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9DF91F80B1
	for <linux-scsi@vger.kernel.org>; Tue, 15 Oct 2024 19:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729019745; cv=none; b=fb6+SbFwDkB7nKqI6GPQU8jgyUtcCFGRTALZCkFulJlvvlWXLo52bM/Bfvbtv4ut3ikAzpWbTlIx1JGtiqw/g0/ioynqg1F5z3tdzJ1tlt6JUDwKgTWVE9qiPEyf2MbK/CT3xFwu007+p/g6cQRnXvmEYEyPM+zit2RDybfwJ80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729019745; c=relaxed/simple;
	bh=0Auewsxj8jqmZzszzJ2innIX3ilQfw7zuywEoPCD63w=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Vt/1KGQ8a3HemS+fP36zB1AJJ7MlbOZ8uUHCUWrLxxrAJbUMsXRiZyVhCFziUX2fCBHiCh2bTP3bTCcykfkWLf7SR13DvP4PMo9yzFy+jKs6jh0VVAGhmoHjJzOFbcrjAML/P3GhGzab4i4TM+R8u+OLfkMHCyzKUvMVQKKB/Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=o4Us+PKU; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="o4Us+PKU"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XSkMg2lV8zlgMVl;
	Tue, 15 Oct 2024 19:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1729019742; x=1731611743; bh=wO3qaHgbAq7m0V6jIVna50Hj
	/a0W+4AjBIJua/rFdEU=; b=o4Us+PKUCbwVFjvwXhWxlwHVzKLBM28wxX+uXFO9
	Sgnz8gIxwFmTJyfutABEF8ajr8yn6Tjjqwl7gaJkGisXaBBHq/4fX7m1sjG1oHaK
	igA+GDdgAuxTBw7wbAaHcB587W9RBBAmntQ0w9BrcI4aJScSR1DUQj/ylt+YTVSl
	Bmq+Ytpm73/k2woX4ZMWRCO+e5ZDb5KPCwE0XbbHV2cPVaRpMAIVfWKZ9Vj7UUXL
	U4td2lSFp3ioYuCfxatWYM3S3YFfCJo5emTkG81QiNIfZNEuVtRTNjpLYsYG4RDl
	8xRI/+u8ZlPF09Jcq4Wx9u7iCPiM/pIgpjJisREGaEHsLg==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id LFtPwyggFrA0; Tue, 15 Oct 2024 19:15:42 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XSkMd6yvzzlgMVh;
	Tue, 15 Oct 2024 19:15:41 +0000 (UTC)
Message-ID: <6a587c9a-b573-4860-86b9-3a27572d39db@acm.org>
Date: Tue, 15 Oct 2024 12:15:40 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: Remove unused host error code strings
To: himanshu.madhani@oracle.com, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org
References: <20241015183948.86394-1-himanshu.madhani@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241015183948.86394-1-himanshu.madhani@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/15/24 11:39 AM, himanshu.madhani@oracle.com wrote:
> diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
> index 340785536998..b74c3f505300 100644
> --- a/drivers/scsi/constants.c
> +++ b/drivers/scsi/constants.c
> @@ -403,8 +403,8 @@ static const char * const hostbyte_table[]={
>   "DID_OK", "DID_NO_CONNECT", "DID_BUS_BUSY", "DID_TIME_OUT", "DID_BAD_TARGET",
>   "DID_ABORT", "DID_PARITY", "DID_ERROR", "DID_RESET", "DID_BAD_INTR",
>   "DID_PASSTHROUGH", "DID_SOFT_ERROR", "DID_IMM_RETRY", "DID_REQUEUE",
> -"DID_TRANSPORT_DISRUPTED", "DID_TRANSPORT_FAILFAST", "DID_TARGET_FAILURE",
> -"DID_NEXUS_FAILURE", "DID_ALLOC_FAILURE", "DID_MEDIUM_ERROR" };
> +"DID_TRANSPORT_DISRUPTED", "DID_TRANSPORT_FAILFAST",
> +"DID_TRANSPORT_MARGINAL" };

That doesn't look right. "DID_TRANSPORT_MARGINAL" occurs at the wrong
position in the array. Please use designated initializers instead of a
traditional array initialization list.

Thanks,

Bart.

