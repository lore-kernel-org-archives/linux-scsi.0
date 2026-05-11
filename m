Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 133E9382F0F;
	Mon, 11 May 2026 20:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778531358; cv=none; b=OFvPYh8lCH01myfqr01iZliEY6bYdGMrkaJ9N/lOIHduXuoyqfR3xbQR3MZb1Lh+eIQT+W0ujut3BZ3Bt3LkAO/0BXt26BPomQOre3tBbX66RQRZ+bChWLM6yFLXWDIw2AscHlvEP9Gq2N1/0f8hu49FYcB2ZQOpD7Ui7VdPycE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778531358; c=relaxed/simple;
	bh=ALX1DcuAGZICnqHSwIebe0EVk0XeNlG5pPBY5+BWxLc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RpTOm4OnupVtdzJIFL25iriGsx9eR8rQ+QMZ6006VEbWaoAdjVATlmxcIHIOG1u664XIZ/eRVV2gEyrZQt0N6+6oAP1KBwH4VadtApKADjjYHxEOXilRBXMQzCuQbOBYefTmdTN3fp4FLOmT9e2H+Au37FQVJ67TtDPJQeP9oUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=SmRTOKVQ; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="SmRTOKVQ"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4gDrt444QMz1XM6JN;
	Mon, 11 May 2026 20:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1778531354; x=1781123355; bh=ixyrTw49jB4fOP5+j7x5MU7x
	MLFh4Xqiye4S2vngAuo=; b=SmRTOKVQE0AYblQAzq+DU4WKVLDbmS3Gg3K1cd34
	unqMSEG+Q3UHIrvQKT+rzZDYkF5L+1F7v3c2UsWAKX+yNyoo6PC35SXEu1h93PMM
	/7Yfy8w0ON+XroWAGXOctWiR0nQQ+a+btl8epWrqgd7MD2YsJJgpH0W6Tv1BcBGx
	hbrFme9eWqblBth7NSAO3MLhtf3+fjhamNs1ZF7QPgW75ZgFvODVAow0s0GiQkHw
	ioN8kju6312bC6kPOOkLHt9nY1e3OveAgZjLHmNmBvxNtbffg0DV658TV6H4YULl
	KhBcJBJ4I+F5KHUTjERw1HTmJu+YnZtX7akkrHSQjmSWWA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id igrNeGht7vYO; Mon, 11 May 2026 20:29:14 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4gDrt10p9Lz1XM5kW;
	Mon, 11 May 2026 20:29:12 +0000 (UTC)
Message-ID: <2f5230a3-63c5-4513-ad2e-34c2f1b49527@acm.org>
Date: Mon, 11 May 2026 13:29:12 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: scsi_scan: Fix typo in comment
To: Md Shofiqul Islam <shofiqtest@gmail.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
References: <20260506094504.2235-1-shofiqtest@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260506094504.2235-1-shofiqtest@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/6/26 2:45 AM, Md Shofiqul Islam wrote:
> Fix spelling mistake in comment:
>   - initialze -> initialize

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

