Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65876146D45;
	Tue, 19 Nov 2024 02:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731983146; cv=none; b=mIbZ0OIN1Iozk0GRf+QgGfJnPbRB1HXALnf0kpn1bxClsvI7DKvOiCqjs2yjSGoRHO1wjLEw968yFyIdVKIQiXLMC0DTbIPQD60WBLSn7VHuT/nifi2U4FXBf2mdUm0pjgweY0gCUeAFSYlVZLQAnvO1ct9fmH9kreBfErAQei8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731983146; c=relaxed/simple;
	bh=lgV6a1pJy1XdDv/Wt0SEPA9FmVr6wCeHibqAs074XAQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fjDB/6Lsukp4lebtFiV5eOZkEjaUDEFy2P8B0HbAR8k7hgTjb3f2nSWwnO2pOqjF6o/tMtgKdJI8YKqeOFHtZIaxnpgYnHyzEgObkDdabU5zmyD0j3UsAj81cZhAVtQbyNi+l3KIUgMqfewwZZckuHR9u38LMKQGp1OkPpA+WV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ABlGMfNv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ABlGMfNv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 977FEC4CECC;
	Tue, 19 Nov 2024 02:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731983146;
	bh=lgV6a1pJy1XdDv/Wt0SEPA9FmVr6wCeHibqAs074XAQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ABlGMfNvpjTRuhnSG0oCMT78/NCRAUXGeYF2iVH0A6doezLW3jGpmh/lOCabZB9tu
	 5IVYGJr2ZksIWWSNJxrNa9E71LxRGkdrkxnFFCLEYxsusWoVKTAfpbP0k4ijwAuDmZ
	 wvvnmSSrrYxDJOPWV9qxwswinP1y3lQ+mWNVZupZYFrXctGn6l0yEEQZwVGGZzSpUP
	 FfnR2mY6D2K/WLQmfendqhSHoUneE7SSlAyhIRoOWHyHmwqa40dE8cQjoVRAxuAI1y
	 UFS0Rcqp37pjI3KPfjHSdL6BWqZ8pwV7J0vx14CaYQcnfp4A0tMYy7SiUpKr5FdiZq
	 tfRsljlc3lOhg==
Message-ID: <258c8ccb-f3fe-41ed-9c8b-957f855ab411@kernel.org>
Date: Tue, 19 Nov 2024 11:25:39 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 03/26] blk-zoned: Split queue_zone_wplugs_show()
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Jaegeuk Kim <jaegeuk@kernel.org>
References: <20241119002815.600608-1-bvanassche@acm.org>
 <20241119002815.600608-4-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20241119002815.600608-4-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/19/24 9:27 AM, Bart Van Assche wrote:
> Reduce the indentation level of the code in queue_zone_wplugs_show() by
> moving the body of the loop in that function into a new function.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Looks OK.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
