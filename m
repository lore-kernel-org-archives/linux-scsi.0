Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446C4145FEB;
	Tue, 25 Jun 2024 21:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719350870; cv=none; b=iZALwmbtgz+7jnJUGkS7lUweYMKApEUsQq04iS26yOYBQFkVEgUMa8PC8cbbr6zzQsCCz8aUFLB7ucnOYQXpUwb8MCisR7E5B8O1g8PLbalPMGredw5YF7twk8wWn3dibxgkHK3AIXfQYhpYKXjqnlTw2pcMhhwQBk3w7SbgF1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719350870; c=relaxed/simple;
	bh=EU4E15Nsf17X+h7pqeBNZaZsMVUAY16Cp3VNtlRX1XU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LSrcW8b4MjAhaiR/Ah5PACXR3dmlhZOGW2SXiGJ1UZiXxyfofXDH/nn6iOalYWFBLfoNx9sCodOd2eMB+OB+/ih49H/HKcvanHtIpoT2hUtMmnDvpImNl5/kQWoTNBdsxc38RYR2+5MBYUusWHktwlB8N4GtxJgiFX8JZ0T2fd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JqrJ12Z/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JqrJ12Z/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BFCBC32781;
	Tue, 25 Jun 2024 21:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719350869;
	bh=EU4E15Nsf17X+h7pqeBNZaZsMVUAY16Cp3VNtlRX1XU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JqrJ12Z/8iB3w69W4qp+DemeLdhqdN4P3LgWJ77QeKGlYW0OGyNDc07hhJXLgdEaK
	 LwMy3/71bo9WnN/pGURPZtjmOwYQhNmq0o8r5lCAhTfKljTXsDf1Dk3c05CbWqYxAJ
	 caQ33oys8BX7rhlTXz6FyfKWp7EWjL3JnaPFOSEK6htiCzH7JnvbZHgncrzySN9FY5
	 bjE8GfaY+btlD+KTBytLO3IRN1jYveL0USTKmm+MOzWC7lvtM62l33lU9MOOwPqYm0
	 BtDs7OT8KRNQbSWbT3NE0x9wf3dJjY7OQjB6NWShFpP6iEPw3JZ3R4ybFO5c6wrJx+
	 oSi54Kz2p6EBQ==
Message-ID: <28335f52-f5ce-4566-aa98-704023b6a5a9@kernel.org>
Date: Wed, 26 Jun 2024 06:27:47 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/8] block: conding style fixup for
 blk_queue_max_guaranteed_bio
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Niklas Cassel <cassel@kernel.org>, Song Liu <song@kernel.org>,
 Yu Kuai <yukuai3@huawei.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>,
 linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
 linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org,
 John Garry <john.g.garry@oracle.com>
References: <20240625145955.115252-1-hch@lst.de>
 <20240625145955.115252-6-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240625145955.115252-6-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/25/24 23:59, Christoph Hellwig wrote:
> "static" never goes on a line of its own.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: John Garry <john.g.garry@oracle.com>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

