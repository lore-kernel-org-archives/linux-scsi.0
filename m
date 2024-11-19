Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1426E2BE;
	Tue, 19 Nov 2024 07:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732002952; cv=none; b=bYyKsId8anLQWJWYQPG8wntkHW75dfAZzfd+lvAcsWmEzJQwMRmQV+MVt9J/KXhPNTmFf4F/opNEfU5nhtn83HqAWgcKqU2n+eLUWeGlehYOr5cIfQ+gNpKO1vfTYm1Fwp/4E34Sdavb+E7RzNLRPgehUA4nI01Y/hobz/Lf7/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732002952; c=relaxed/simple;
	bh=gIr9nW1OQ6no7X6DqouyG269QD1RBm5OV+v+7lia2a4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EnDxtGf6HbyyuWoySdTbfYh6cOhDB58KjT/vtYa9fZD58MTVl152p/j8RZTnenbA+KMHRKD0mlJlkpGUCNWAzRf0XtfSb0phfYuUAVRLExryzRWZNminRG52JmU23+DAkcLOwO/L3q//K6SVD5UxyQVVXvandtxZDqGNYm3XP1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U7d3Y+0f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U7d3Y+0f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D55FEC4CECF;
	Tue, 19 Nov 2024 07:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732002951;
	bh=gIr9nW1OQ6no7X6DqouyG269QD1RBm5OV+v+7lia2a4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=U7d3Y+0frSjen1/SK+0tkJ9MCJgzj5STYM6+4HY73jd89H7g29upk464ZXq3grO2L
	 vxyor5TRhHzL01lDBEzWebyWB3xKgAQSauHFGYlF6LgJkGnbIuX0feptvU5KDXfiTF
	 /MdMJpjk+SdecxTwjZkbzLOXiGvUnvt73GCCxiICg8lF6ZV6nbuS26gUx8zz3TirI6
	 BG0qlFRnSnL9DmtYU5ujdlf385QfLCVPKRBtUUv88QQeguV5t/LG+FurPfpG+ODLlM
	 uq5XSQ5UByERbyBI1S723oOYZa9yEGdthJOp/9hUQfl+oJ/IEJ4FlfLGpjTNdNTGP4
	 G1iLmMfdIIkKg==
Message-ID: <c8cd9037-4487-48b5-80dc-2ee35c1fc972@kernel.org>
Date: Tue, 19 Nov 2024 16:55:49 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 17/26] blk-zoned: Uninline functions that are not in
 the hot path
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Jaegeuk Kim <jaegeuk@kernel.org>
References: <20241119002815.600608-1-bvanassche@acm.org>
 <20241119002815.600608-18-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20241119002815.600608-18-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/19/24 09:28, Bart Van Assche wrote:
> Apply the convention that is followed elsewhere in the block layer: only
> declare functions inline if these are in the hot path.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

I do not really see the point... Anyway, looks OK.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
