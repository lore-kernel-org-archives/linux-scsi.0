Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C41ED6E2BE;
	Tue, 19 Nov 2024 07:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732002836; cv=none; b=Lk873M6gPwZH/8JIyT3knb5XVWRw6Q5s/XmoWwjjplKXeFmCQqZ7hmYtz0KQijMkO6GCKYCi7zKSlM2OOapzSehmdbOcw+hZmr09d0pvzpb3ENBCeyM8e8UBwpfaWVR2weTQ95WBoJmb2eJBgS1k4WVJUzM8EdFEUSPrLTLprnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732002836; c=relaxed/simple;
	bh=4Bu/KLWBDqmmMVIAlICuUAY+6L0VUU0bcRNhYNFodMc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JAIg6sMRew6WKDWgC3lNPjxYOTI3TPPAAHhXyVlmzurBHZ87Uhd+sZzB/TdG+fA+ufHe//sYE+yiPDvEmzYEorqo5nO9HgG2P/xTHHlWOFoEcHSbx0cI0V1vz91EPJ85bTJPgbwIa/VAnOQgVHaMTPSC6aTU/WjyGBfYZjtf5F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JJ/7maED; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JJ/7maED"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD2CFC4CECF;
	Tue, 19 Nov 2024 07:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732002836;
	bh=4Bu/KLWBDqmmMVIAlICuUAY+6L0VUU0bcRNhYNFodMc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JJ/7maEDe38GMtozVo5yQpWcuG57w5hOaKf/syKq1a00YoUk/2QaF86nhTlanV1Op
	 CuMf/mrx+cMazWTg79KRnR6yku+WAB9L/+7VR67Z7OlgBN+CWF8lvQAheAJSZMFRJM
	 j5o8xVXHB1FIIeso2mhwBiozJAZzIBweDDa4jIuKcuNcu/9o2FpL1Th387CBdI0/ow
	 RFlLcIkjjuVOIjfzGaUFOq/HTe2Ueop55L+qlU8bDPkzYijLm5ZhGX1GvZEPjOtuha
	 Pr5sWi2hlb7NwgUx2blxAC0U2dVfv1jj6x9hgtckwyF8hd6D2ulXulJq22ua55EKCU
	 SSkDo+emBrVZw==
Message-ID: <9defe57a-8a40-4f63-85d8-b30f4da79768@kernel.org>
Date: Tue, 19 Nov 2024 16:53:54 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 16/26] blk-zoned: Document locking assumptions
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Jaegeuk Kim <jaegeuk@kernel.org>
References: <20241119002815.600608-1-bvanassche@acm.org>
 <20241119002815.600608-17-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20241119002815.600608-17-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/19/24 09:28, Bart Van Assche wrote:
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

The patch title seems incorrect. This is not documenting anything but adding
lockdep checks.

With a better patch title:

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
