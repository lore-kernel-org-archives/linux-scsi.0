Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07CD7146D59;
	Tue, 19 Nov 2024 07:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732002771; cv=none; b=ZaybC0W0K2KB5O6S2IYCNvETYgjPVgQK2HEfhS0GMyDNd8ZWZVKFfBY57FKJRDvd9Xo4XEL8N+VyYL5f819ConbzFf6dFVNdLmB1nbbrsyKvWVs3gjuiWE/Do6x8m7/b1TiYuh2pqNZCt9ALe1tZuJbQECh1CiChwpbxWcqqD3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732002771; c=relaxed/simple;
	bh=DApbvFyqZ16T2MaLK59KCZsEwYxjPvd89a7f0vuy7lo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UvYWpQ/QOp5wdl7Jdf13Dzzvmx1eVo6GAauU9wa04Y4Nf2Mj+eAu34tBQVuQ9eOJwBvugBNViwPUd2727nvMoYIWAXP7GIC3xeCkDqRlz9KtUQPRxiiAtdvP9QoCMlt77BdIa0Xe3i5P6RvxSVrlrYTNF3h6Us6ZBXhXXwsoHik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JRkxshRY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JRkxshRY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D73D7C4CECF;
	Tue, 19 Nov 2024 07:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732002770;
	bh=DApbvFyqZ16T2MaLK59KCZsEwYxjPvd89a7f0vuy7lo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JRkxshRYohNpUkiEtWVBNMFkkbQrncDPm+4rNybkT9HWoY8YlR++CdPuAK1l9u7DT
	 9osVbmTpKRWQS5QUWRdF2lEeIDlSR8HeKc28qUsWvgt0wZFCb4f+cpG2mzkRHPA+M9
	 wcT6vaV+pfCkMBf8gqoHEy6R2rGFK3cG/R3HlY4OaKIgoziYmMqwqPWNjOEx4/hAOL
	 sDK+oujNLJtKcWfWh0FnL+ORr9FZneB0XbXXSPBLpDEaEvSX219TArqz/EOd9TnBeh
	 rLEprrl0/pA+eringJaIwyfLOSWSjNMghECHx+4aDMmxqHnC8yZdWo6cWxSwP2bujQ
	 fJfQ8o54TfZHQ==
Message-ID: <e3a1bf3a-d0aa-4423-9400-463a4e27de8b@kernel.org>
Date: Tue, 19 Nov 2024 16:52:48 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 15/26] blk-zoned: Document the locking order
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Jaegeuk Kim <jaegeuk@kernel.org>
References: <20241119002815.600608-1-bvanassche@acm.org>
 <20241119002815.600608-16-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20241119002815.600608-16-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/19/24 09:28, Bart Van Assche wrote:
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
