Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EED218CC03
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jul 2024 23:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722382958; cv=none; b=c+le+2Tuz+82pcZPTyCu1X3vUGh1RwskbD4rBNnwj/T3k0BvTNc655ZgZb3onPdBCpOdR4iWD3ydVI6bJ2ikQa0dnRd0bkdT4kOM78iaOST51RzAFYO7hyYAfgAETIM5L6mCt4X7TwUj5lGd5mTsDspvFafbaQDxbRzTAzzgkwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722382958; c=relaxed/simple;
	bh=ZeatTjHcIdixUgxifk3ZFGKlcW+JW72t3ElEPGcPAwE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dB4xfzuqskNLz4bE1xcrB1Bq7jt7Mm7fdQovsbrsOSPMUvbGAgl34B9DUHSrkyUKgw1CF2LoTVLr7CRPOoZfwh3pnRqpiFzyru7l91myRMujosZqdgpltBaUc/aMIRoccz7mCIs42NXMlPIKik8dmApQlMQkbC+lqYewingA53c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m6YEC66m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m6YEC66m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6E8BC32782;
	Tue, 30 Jul 2024 23:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722382957;
	bh=ZeatTjHcIdixUgxifk3ZFGKlcW+JW72t3ElEPGcPAwE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=m6YEC66mcRfB7XNxUrXD9R3SYzSQXujBELrTNHCDK700fQKF/kpPshyAVcQMplUhQ
	 sA/JNxIBN6vtQ1+pfAJ+TS2ulzkJm1kZq9FtrmijUMaOlzQWjRosMgcrnUaKb9tKBo
	 Bg3n8QLykWyqJznc9sstBEXnmD2x1M8mKQ/NOOM6hbcklw+KHmFADBwcFrYuHO+wgS
	 u2jGwvQTHkv2fT21cYf7K5bG2w2n58G2EFNrwJgYCV50Ns/+5Cew5BLRYYHHpRVizk
	 AHOK7IehjXp9SajcLdHh+ztEMZN+BHyt5LJRT2QgVZcjfYIRCF5kE8OZn2TDrxmJAr
	 wCCcnpHLF2+6w==
Message-ID: <9b8dea4b-ee4a-4741-a9e3-40096c9be63c@kernel.org>
Date: Wed, 31 Jul 2024 08:42:35 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] scsi: sd: Move the sd_config_discard() function
 definition
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 Hannes Reinecke <hare@suse.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20240730210042.266504-1-bvanassche@acm.org>
 <20240730210042.266504-3-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240730210042.266504-3-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/31/24 06:00, Bart Van Assche wrote:
> Move the sd_config_discard() function definition such that its
> forward declaration can be removed.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

