Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E63F818CC03
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jul 2024 23:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722382994; cv=none; b=NGscDXO4kN/EF3mXY3DJSBhmmToCTxajep/nhwilLfk5C1zd3EnSquDxkzDqCpp37VXrrRx+YikkTpbrn//gKCQFy8miiT5hISn//RLYjA5KGokO3dJbfbWnGpbZSkELZ/nb/9u2kJLyNcGmuMTPbnNIWUSLQmWmnVLqLZa9bTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722382994; c=relaxed/simple;
	bh=37dPUACfS0VLdPwQkriHWSuFTzmASCVlHHyW2mq6tak=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fmxfci4hPcQgcOi9+iccOCEpB91VdEnun+BCjFsPgi4WxkaFv7wJIsA1367UcoT8OejMVwxojcCKSzXVjdisdiAGrfoPadcA8tLXDbcloK8qcvN9bdOc/vXn9pUAvIRv1D9UEq13aoR3zbnVB/ZiGccjEw162B51sIBVLUrmu1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=licGDbSr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="licGDbSr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03264C32782;
	Tue, 30 Jul 2024 23:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722382993;
	bh=37dPUACfS0VLdPwQkriHWSuFTzmASCVlHHyW2mq6tak=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=licGDbSrLjQGYdgXFSSWE6P/nkPcrRHGUVeb7FiDcNaCMCrTRKGM3n4gYE2msKGWP
	 KYcrE4IrWhWcyyD3gL8oT6hdZLyEGAX92UX4bCyux19TPqtV1qz7grVxIVsbY4T1jl
	 c216V02/V57pOvA+t5e8bhauln2Zc7szptLYyG2iwCeMegpiYXb1soKntkH6rzN8VD
	 CRYt5imJI4S9ifFhItHiRIE2LMUJDOCspvKgrk2ThAUO88M6ydBnppoG6gSe8a1YQM
	 bi5CTfurOQ8zD9CfJLQiiYvBrxZiG+Pspfx3bSPVi3qTAbUiUwPtSsaMJavy0PKFMe
	 lqExLYtyESLrQ==
Message-ID: <1e04f507-4a26-447a-b815-8b4b94186556@kernel.org>
Date: Wed, 31 Jul 2024 08:43:12 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/6] scsi: sd: Move the sd_config_write_same() function
 definition
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 Hannes Reinecke <hare@suse.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20240730210042.266504-1-bvanassche@acm.org>
 <20240730210042.266504-4-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240730210042.266504-4-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/31/24 06:00, Bart Van Assche wrote:
> Move the sd_config_write_same() function definition such that its forward
> declaration can be removed.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

