Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793030196;
	b=1PXdCyBpf1iYKjA13ZNVIpZgE4ec0VO0GAbzGpj28eS6taLHjRM76Z4Yi2V5i6HCP5fb
	 +BRa6zm546BaWZzOQ/7NdWmyiDa31jtFnVDYzlLAJfUZ6c9q5O7BcMTqDF5ngJ96cCyGm
	 Rj6xGWlXBOXw+32ieUkzfaH2jHoXzyKnlm1qWGzJPGSahcIHE/gyAFuQciyty83IqS4MI
	 kRCeTS1NG6sPgULJfjN7tOwG/qwMGBUIFkfuV7ufhfFnAI0kX9nR4J/b5gZe29oKDKvhU
	 mEX5AumFWIOu/sTm71rHoSbyUU4MWTJGFgTOj4kZDRB189j6t166CVbke8BKbc+TLUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793030196;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=2GoPmj1ZmLofWBrMyOcxppGzOSH5vRfw4U/a5/6h2ME=;
	b=dQKt2r3K4IBD6jGs3YF3YqnDiEX6KlRA1PTe+V5Onol+uXTRoywGOWpcXGSu0Hhw/xfY
	 2vfG65sqkl92n9ES2YN3NKgDjsz/urEiEpKTZc5/glA6yJ3LnifsxmLcPju2KM+nnJk7+
	 kyHjjbLDE43S8ecvVEClGS64QfRRjnwB0yo6m25NqOJ8Lb0mqLNYh6IiYkPh/NgvoqdVW
	 kAx40qUGmHXLVGwwdGOmiaYTvQ8Z1zl4yZJaCkgu30gvjMWfu95ndwfsgU2HrGBqn7CBC
	 hbPKtgBLzsVJRo82g5HBcckafQCkp9VnPW/0SPYpbLeakknVhFe2K5NT/yBajIKVZtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=CFz0EqCR;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A14C606A31B;
	Mon, 26 Oct 2026 15:56:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2A14C606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=CFz0EqCR
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4jCysv5DCPzlfvpW;
	Mon, 26 Oct 2026 15:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1793030192; x=1795622193; bh=2GoPmj1ZmLofWBrMyOcxppGz
	OSH5vRfw4U/a5/6h2ME=; b=CFz0EqCRRpkaKxNgZD2gnz80gb+xK4IrgHP2uIOb
	1xwfASfByJrEHN0huo3sKoNPmOs0ifC5Yv8nLBNf1o6EzwirzmUWsf+J2M42I9PF
	nbiWg3HgJ5p1lUWSewqvgho9m5utg/N/ezYFouYlik3FSM7mu8+ZtAVX30EhnFxL
	WB1gyusxNjUGmOUDeB30svhB2RuD1yqTxQJEZkNRGPJK+zMNTqOPkcMRG338CG1N
	/Jb5+EPe3RAY8raVd8m2mNxNRez6b1f/zWzFBREz4G5W5yckL/BtZluXHeMEGnkf
	X5liwIBizR6JnImgJyTHdkc21Hi1UTMI7p7wxNVFQxVxZQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id A3JlEVgOhlsY; Mon, 26 Oct 2026 15:56:32 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2ed2:d:829f:7082:d079:ed8b] (unknown [104.135.182.43])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4jCysq64GJzlfvpT;
	Mon, 26 Oct 2026 15:56:31 +0000 (UTC)
Message-ID: <6efae213-c75b-435b-888e-f58c32b28bf1@acm.org>
Date: Mon, 26 Oct 2026 08:56:31 -0700
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
Subject: Re: [PATCH v2 6/6] scsi: bsg: release io_uring requests in end-I/O
To: Yingjie Wang <x-professor@outlook.com>,
 "Martin K . Petersen" <mkp@kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 Yang Xiuwei <yangxiuwei@kylinos.cn>, Jens Axboe <axboe@kernel.dk>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <cover.1793003363.git.x-professor@outlook.com>
 <8f30e238d2b169702308303687e9504c7513ecc8.1793003363.git.x-professor@outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <8f30e238d2b169702308303687e9504c7513ecc8.1793003363.git.x-professor@outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/26/26 1:29 AM, Yingjie Wang wrote:
> +	pdu->response_addr = READ_ONCE(cmd->response);
> +	pdu->max_response_len = min(READ_ONCE(cmd->max_response_len),
> +				    SCSI_SENSE_BUFFERSIZE);
> +	pdu->sense_buffer = NULL;
> +	if (pdu->response_addr && pdu->max_response_len) {
> +		pdu->sense_buffer = kmalloc(pdu->max_response_len,
> +					    gfp_mask | __GFP_ACCOUNT);
> +		if (!pdu->sense_buffer)
> +			return (issue_flags & IO_URING_F_NONBLOCK) ? -EAGAIN : -ENOMEM;
> +	}

No new kmalloc() calls in the I/O path please. These have a measurable
performance impact.

Thanks,

Bart.
