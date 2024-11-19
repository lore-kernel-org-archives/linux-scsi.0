Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F38146D59;
	Tue, 19 Nov 2024 07:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732001989; cv=none; b=Uz/dkFsjdUzo49nwbTN3Pk8f9g7ITV4gwtkRHM1+u8aCyrLNziDxEdnSi3GtwxryRFHQJXmbHzHmXpweIp9wfGESfYMiTnlZluVa1EMgLZt3VoJW1aXI/9/tIkFou8S7GkPtbI53psSN3ljhSYmqlBs70ISA2BAQO+SeNccoF2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732001989; c=relaxed/simple;
	bh=e26uORlS1bmz9Nvz02HnCIuBuugHPBHuqqWd6cj+v3I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cfFKglohE1O0gGASGfYJex7W5aNN5IMAOWMPHI68lMKPf9E+VJfKNkkoRnOoZC+kGE3kmwkfJKw7xw3XLyTKuuLEqZkuL7TT0fEliO6UqNHM/32Hf0hL9UM3kRompahb5553MOglmaqmUtnnQG1cHrnyg/4Orc6exw59omhyGQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NZ4EU7Nl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NZ4EU7Nl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4724DC4CECF;
	Tue, 19 Nov 2024 07:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732001989;
	bh=e26uORlS1bmz9Nvz02HnCIuBuugHPBHuqqWd6cj+v3I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NZ4EU7NlIzz7zVXlnj43SnV1LVUa16uiRuHIVDO2bSywsiXy6Vl2fGLYx85M85MKc
	 F0bholtQnaTYnU6E9ND05LASi8YHsu+BRl2tBiA9V2arEYueyacl8pNNTFJ93ZWPsh
	 CEDZdWoOyLF3CMKT+lUx6CswzRKLn/jtkF9MPBQj2+EkHtneGM41AqsAPU2iD8F4UZ
	 8sQ8vM4Vh7puwXhHnQmhhbgxWi0y0AypPe7r373SKUU0+ki0WNOSNK68/JVDEsXMdF
	 kA+MW1ew8lQAbTWh30H24SXpI/7pBRth7sFwUCbMUDW/stblBvhLKSHpu0LnTbqnsM
	 Nc8L9Wf7/+TAg==
Message-ID: <32b7a002-1b70-4165-bdbf-8cd3ccfe592e@kernel.org>
Date: Tue, 19 Nov 2024 16:39:47 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 10/26] blk-mq: Clean up blk_mq_requeue_work()
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Jaegeuk Kim <jaegeuk@kernel.org>
References: <20241119002815.600608-1-bvanassche@acm.org>
 <20241119002815.600608-11-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20241119002815.600608-11-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/19/24 09:27, Bart Van Assche wrote:
> Move a statement that occurs in both branches of an if-statement in front
> of the if-statement. Fix a typo in a source code comment. No functionality
> has been changed.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Looks good.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
