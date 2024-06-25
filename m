Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B7B3B7A8;
	Tue, 25 Jun 2024 21:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719350947; cv=none; b=kQWVINGbIt+sb7zvNIMfnRWBi9jWC6HOVFNRFXxTQWzA/bA6LslzHJF3Hd88fQ/aiyKjAJO/R8c4Ks2OaIQzYv6bIW/iI4jw5Y5uO+2Nn48gEbZSoaFLsVlUsNd4sKKX/eYHcO68dSwUeTvZ7GWVs8G0xja9AnKLlJivrDx2A54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719350947; c=relaxed/simple;
	bh=KL8wBBqLXkuwLn3yp3nHiQbZcGryVCNXsdItxS5NxhU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fjHurWh3ipYK8U6ogiGx5B/gaY3e+wophjikEUglnhJt1CXyVXyqhRmFzQLiddlY/N7milPmk4frXgeWluC4sede7B3TEyNfai9blVfmA8Kc4CFqdfbVODBbJebGMNKjP0CEt16URwvoPCDFb+ltC68J5h1IRlEeVsgz4V7Ot5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KCWEyhad; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KCWEyhad"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85BF7C4AF07;
	Tue, 25 Jun 2024 21:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719350947;
	bh=KL8wBBqLXkuwLn3yp3nHiQbZcGryVCNXsdItxS5NxhU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KCWEyhadZzyzmOHCTQdChb7DuG92tME7wV3aiN8U93f3Nvs1uzVS4R0xTVMjNgrvf
	 hy/DiCcmuS+3WnpncxvovLRttpue+r+NsBIcOTzDjr1SY7WxPkQHdl4ehFwdLRnj1D
	 XATUT3R5QI4PYgOy8SOGkvJoQT0bRWYduKZ3pCCdOZdemvxee69qMZ7Tpo3APt4FlZ
	 wO50d/DUWxR6kjKCWyo5aXh734LPrBfWkk4p56kX6XX+2Vjxb5HrgXhuW57NqaZPnA
	 XalypvvXS3YZctWw4Ld9CrMX6GbCT7FyU1Oi/rE9h/upcZcYD0dH2pt6N5nN9n72sm
	 0dqIhIVeZWLAA==
Message-ID: <68bc17c4-c280-4c5a-9eef-9e9bdea5a1ae@kernel.org>
Date: Wed, 26 Jun 2024 06:29:04 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/8] block: remove disk_update_readahead
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Niklas Cassel <cassel@kernel.org>, Song Liu <song@kernel.org>,
 Yu Kuai <yukuai3@huawei.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>,
 linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
 linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20240625145955.115252-1-hch@lst.de>
 <20240625145955.115252-7-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240625145955.115252-7-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/25/24 23:59, Christoph Hellwig wrote:
> Mark blk_apply_bdi_limits non-static and open code disk_update_readahead
> in the only caller.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

