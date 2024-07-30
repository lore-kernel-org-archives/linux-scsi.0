Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA4B18CC03
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jul 2024 23:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722383024; cv=none; b=eqZcJ0YgVeDiqLCTLrLoBgTMkoRGwrlttiTF15sb2e/m1iXi23IM/gg55SDdVZPwB5xziZ3xLayUci1EWQgNVwiy5iNvj9JR+aoQLpqv70EN8kRaW3lIhSwr1R3K26ibePRUUwl0/H501L7estSXo+9e2cfgZpGHyG9sp3zhb4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722383024; c=relaxed/simple;
	bh=nkwUY6BDypq4YTIRhZ28LzhweJKUQVvdP7Vb+TXrhY4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KRjlfTR3OHIXGDbEQvSwEs/heeQgcEEnVSm2E48t5HzMpXu8WUKD+DdZhq9e+eXCqK1lU1+6iA38ZIkodE+D9gxvtAnVRqv7GO/9Gfz0UA8v6+9BjxivpUnPI9OxynmrchVONZGtM9ez22FRTOQOJfwtKwWtgmD1b27WYuvzWGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yp5ycLRv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yp5ycLRv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BE5FC32782;
	Tue, 30 Jul 2024 23:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722383024;
	bh=nkwUY6BDypq4YTIRhZ28LzhweJKUQVvdP7Vb+TXrhY4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Yp5ycLRvjUMQgphdevejWAL58vw1eZH9AtARPuuOKHS1IIvvX3L78IcnRkOzflU6m
	 L7uuNHrNPtyx4Z4Ms9VS38xkO/YHiXJDVZXU6sJ1UzAErNcuX5N1APCdcVRX3A+PxN
	 ZUMLLpbk+n1EbB4cguMP/AG5vu6parsQJdCyLPEI8Uq9pn+hh2n7kUTsIXoZX6morp
	 m8mha3XjYfhCJSxPGodp/oJQOxm+qGze0iKHut+R/h+9T0tqYW+RvsMOOXw4LCqIwI
	 jdynhYtJJ4j5dbngTxSQd6URku8HGk1nrfQg+p6L4/spR/PoGSHw48kR4GcinFYGI2
	 VGI5zD0kwwZYw==
Message-ID: <3d230d76-4d0b-41be-a27d-c164c6ea1854@kernel.org>
Date: Wed, 31 Jul 2024 08:43:42 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/6] scsi: sd: Move the scsi_disk_release() function
 definition
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 Hannes Reinecke <hare@suse.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20240730210042.266504-1-bvanassche@acm.org>
 <20240730210042.266504-5-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240730210042.266504-5-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/31/24 06:00, Bart Van Assche wrote:
> Move the scsi_disk_release() function definition such that its forward
> declaration can be removed.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

