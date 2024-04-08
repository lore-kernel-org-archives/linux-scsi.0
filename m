Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF29E7460
	for <linux-scsi@vger.kernel.org>; Mon,  8 Apr 2024 16:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712593830; cv=none; b=IYLkTHCHUCyAMr2xiqIyIGXkuZlGJmQJPqj39/uSD5H5u1vt1zP5f6Zs1A/e8NJQr1AlLj1Hf4NlN9UiAMalfrDLeUkPRvJc1vZekfsqqKesz10Sku95XaemdVmLIR9t8PWcmf0wOTJu45iVsSw0jHgxwWK0Y5CJ4BSMXTttTUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712593830; c=relaxed/simple;
	bh=QQBvAmKHS98LE1AXRBIuo22s+B0lnXfrmHgo5McRczI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WEmcU+c+GfsDUhI6fxM6sQa+H15oiq5XTGI36yjRupLIufnS0FdzCHZMAXUqQR+TpAET2dkue/Aybr03SHVENNtSCbQFzuRErMI2pbJ6fbfYtzCj/eLonQ3ldBOQd/veLaDfNHIT1eERJaqmzhp7XRisg5yF9PpVPlnZ7b/4z6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=i0tT9yCz; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="i0tT9yCz"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4VCvhh1QyXz6Cnk8s;
	Mon,  8 Apr 2024 16:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:references:content-language:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1712593826; x=1715185827; bh=QQBvAmKHS98LE1AXRBIuo22s
	+B0lnXfrmHgo5McRczI=; b=i0tT9yCzyJtpewwtKpQu2j8P6rZ+2hkvn9FNfWAc
	ZP+QjBqyhtvXAvD/St81691GW1/4OwhkezEKkhZby6mwJFlvvMkYwilD/5HDjZL6
	AjPm+vWjM5asMacNT4Mgf6M56OBhQassAlEBomVkEyErjXSIRDf7HSc/EECmegJl
	wHj2spzc+I/mIiqCq0+4CC3vKFup3hViDaV+/mvuDFg5xLiRm+dQEm6z8wUwwIgj
	LP1vNkOqw3RxBsidjDeMmE8NIIV3kgkg8lvMgrxcPTnAf4X4ot5mdS0v6wt84QIB
	6+K88xRkxjPPNSXvzhxVCftA4AtvFSNbVltEdRs1DScHZA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id SpfwUbOpF6Pc; Mon,  8 Apr 2024 16:30:26 +0000 (UTC)
Received: from [100.96.154.173] (unknown [104.132.1.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4VCvhd0D52z6Cnk8m;
	Mon,  8 Apr 2024 16:30:24 +0000 (UTC)
Message-ID: <0c3b41c4-3ad7-445e-817e-eb80d91a9387@acm.org>
Date: Mon, 8 Apr 2024 09:30:23 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/8] scsi: scsi_transport_srp: fix a couple of kernel-doc
 warnings
Content-Language: en-US
To: Randy Dunlap <rdunlap@infradead.org>, linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20240408025425.18778-1-rdunlap@infradead.org>
 <20240408025425.18778-9-rdunlap@infradead.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240408025425.18778-9-rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/7/24 19:54, Randy Dunlap wrote:
> Add a struct short description and a function return value to prevent
> kernel-doc warnings:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
