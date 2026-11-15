Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794757369;
	b=shqNEXMDiRLvmy26yW5q9fI7Hhx4UJEe2RG8m/GBiZJCna5sZuSOpXqk8M7PccACSbwH
	 Th7HRBE2WFqzVmjml4V1KZdu3px6WHlq0FXqYsqt2PkMxL2wEE2wPuXu+lbrgbpgDWisr
	 9eYywz+78G7MaF4YGU+exPhLC2xr3n7OOGUhniyME3lXISEz9jnsDIp3ICZSE1TRPB+/I
	 vGtzobQi67dHB1mDmLrwHMY+0ub0WG8UhM3ZZYB4Fy/i+Ib63tSYjLVr3luPVW1bk6QmE
	 72vWTZi2/EuKQx5JRpqfgjfJtw/PQUbfpMU8YDVgUEl4QjUzgkyaKBtr2SAk5ba7A2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794757369;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:From:To:References:Content-Language:Organization:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=pei8zl3Pm3q3a79rzm7syc9SnS6/B6xPnb/+KpGjLE4=;
	b=NVjVXVTpICxRCWU+IIGqukVByhju4LpPdxW7GqSNkWz6yibdz+GQIZfWXqRrGcxdCwpp
	 YFM24BivfRd3KtESHgZsg3tUSLQEuwXmJP6PwC+fSdS4pfTaLJ7n06hvTvjZiIBlm8lAv
	 TpGp3XfIyPjgzI3K4sMv+6WJj4uK0ZwQ0fsT7oCHlo9XfRHrwKTHCDHoy+L4hs9wWXw2k
	 M/yppYuVe/7UhSkX+aN+AbZR6LSgcs7cyD/kJEC9PLfVdTmB1xC/+0nwhwADRFLULhnFK
	 E4FLOKwU7SN1+vJsOdiBYK9suguCo1ydOJhlU/FzBeyvD6TxMmRiDzUt7Cy5DfkcGHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ncu5mBGE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C20A606A32D;
	Sun, 15 Nov 2026 15:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ncu5mBGE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 781E41F000C4;
	Sun, 15 Nov 2026 15:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794757369;
	bh=pei8zl3Pm3q3a79rzm7syc9SnS6/B6xPnb/+KpGjLE4=;
	h=Date:Subject:From:To:References:In-Reply-To;
	b=ncu5mBGETRj03hjn0e7XBezzW3IB927qODoV2+f+vKiOAc+yTnR65jc2ZQFp6lLb5
	 FPwXeO/s3mG55iLuMHHmmohl8TS65kGD/ss2jqfpxfyC6TxYD6i8KRBZhjXMOOs6N4
	 26j0nBTQ+OkoeGn24beD5TL0mdMw8/gSHdszsenQ/9YkksMuo/BJdfoZsInk5Jt9bK
	 RiFDFO4wTvR4HteqRhD+WlpzT1inYSHVFmS6ajiaurtXM6qsOiFJsrG6VgVCu5bSJ2
	 jsG2ftkIVvXhzkUSLkIGrz6GA/a6gTOSFFJh2uLM3erG1yqK69iFVCCztmzU4xav/R
	 LuxBNqqynMJoA==
Message-ID: <2cd29300-fbfb-49cf-8033-8e3f018a85ea@kernel.org>
Date: Sun, 15 Nov 2026 07:42:47 -0800
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
Subject: Re: [PATCH v9 00/13] Add support for storage element depopulation
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20261115145015.938426-1-dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20261115145015.938426-1-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/15/26 06:50, Damien Le Moal wrote:
> Jens,
> 
> These patches define a new set of block device operations for generically
> using from the block layer the storage element depopulation feature of
> zoned block devices. Support for this feature is added to the SCSI disk
> driver and an emulation of this feature added to the zloop driver.
> 
> The management operations can be accessed using block layer API, which is
> intended for file systems (e.g. zonefs and XFS), as well as using ioctls
> for users using zoned disks directly from user space.

I had a -ENEEDMORECOFFEE error on this one. Sashiko pointed out my mistakes on
patches 6 and 8. Will send v10 with the corrections. Please ignore this version.
My apologies for the noise.


-- 
Damien Le Moal
Western Digital Research
