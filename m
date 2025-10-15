Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3B92153E7;
	Wed, 15 Oct 2025 07:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760513571; cv=none; b=BAcFCGf61/q0EpOkv4Nt3SOfi6n2Bdni/B1Uk7zP4GrTmkfmANYWJLRlxcXD12nQqqabNuatRgy+H46ogNaMFeaUunpu1IAkLE3GFU7f6zOrNQSM8UwVvXTUmJIKkQlG1+fRhsF1I8uAszXLdLa7RtMgGntlbHwUhXKlzLdEDEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760513571; c=relaxed/simple;
	bh=Zj5joXRixtLsiFfXNIl+g8rSRe6SLRK9W3vpK+q8eFo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UphE4gM4eNPU3u9TpyctD48W62GK3NcKkqkUEVVUNK5KfQAmAVTk8J8zQY/ji2yeV+ufghY0g0duFGkBguCx3cRK4GNwCCy5uUPPTXVzh5HyVNgMtyPU9bXpJEUno2oYCVFm3FMS31pJ/XX+gPviLkuBqttlkvEL4a5PRJrczek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E4jhapzk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E4jhapzk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F17C4CEF8;
	Wed, 15 Oct 2025 07:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760513571;
	bh=Zj5joXRixtLsiFfXNIl+g8rSRe6SLRK9W3vpK+q8eFo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=E4jhapzkrN0cQV8IfZ1w7RdducAcALFp+6xGI5wU6vouU3q36pPnbEBOoof4Qb/PD
	 SoTFU1g16dD6D7TMsYDo7UX6nCgfvU4j4u3hlj/8dAw2NgnbiioiK8y/ub3uhs99ZC
	 lPe6XyWP83u1nlHwWWSFGSluhgvYbwQyZMwPtdz188lb/okbonKrxL4xOXv3UIPMPd
	 /8MGOWKM9JvXcHpz4+PNtXCTd7b0FsH61lS6YNfGrMW0cFw9LkQCPclRu7LV2hbJUl
	 aRi/bMD1/9kv3fVAL/mLnTkM2lJJtYlwxxxsGCHHxJaKWcxzGzaKUqXbRrZ9hqIHSI
	 pakOfLoRO7cxw==
Message-ID: <57a601c8-ee0b-45c4-b64f-90858e75c233@kernel.org>
Date: Wed, 15 Oct 2025 16:32:49 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v25 08/20] blk-zoned: Fix a typo in a source code comment
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20251014215428.3686084-1-bvanassche@acm.org>
 <20251014215428.3686084-9-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20251014215428.3686084-9-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025/10/15 6:54, Bart Van Assche wrote:
> Remove a superfluous parenthesis that was introduced by commit fa8555630b32
> ("blk-zoned: Improve the queue reference count strategy documentation").
> 
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

This can be sent independently of this series.


-- 
Damien Le Moal
Western Digital Research
