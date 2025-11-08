Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8840C221FB6;
	Sat,  8 Nov 2025 01:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762565570; cv=none; b=MSWRh18IG7BLWds9Vkanitpgxkxb8q+kKp5UjSVCw/J+M+O2ei7aVHAqg4MEqyybLi7ilKDo2XGkZHfVUgEMaNtX/hqeDy3tzCmDu2iW/eOaX8Ugx6+qzz5tfl2Je9uR45AfAsM093gUNtAZRC6BfJba+ygTNQP6jUDnuGnH2OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762565570; c=relaxed/simple;
	bh=RsOdHrNkwDRKK7Fry1eRB3AruRwtBxXKhin3k2uGEpg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V+weOW5ZGCwu6bOaUScDNjUbIWIxRT3j8vF6RItAO+LjUoFnXL76a4vIVjHtblUEy0tGJpVmJ+ifq+hxfxu7nhp9uaQ5esMRoZ7e44bDMUScC1QfIG2eRpQvDN8F45jbIhD555oOeOgoyICLbuQYlo8aPiQVQRsgtN5XE3gast8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eMfycPEF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eMfycPEF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C6AFC116B1;
	Sat,  8 Nov 2025 01:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762565570;
	bh=RsOdHrNkwDRKK7Fry1eRB3AruRwtBxXKhin3k2uGEpg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=eMfycPEFCgNR3wRDC2x//Xwe/nq6Fou+jVRS190vvQRBtuofp4rN7d4+SSUQvlTzB
	 pRnYhrRl5UKDvgjlbalCxq53+CP2vmBZB+t06Jvz6rXTBzEaJrQ7uuC8bNh3G2KgLB
	 kPnblL62lrcQlonIay4KFXnSVXaOUCERYVtx0Ph033UliqqiG11sbxpUWUKTs/qolR
	 oZTmleNl0/pNHrdfAPt8y/Ptkm/TNvyqOsYYpVQQqxrmkeQpXyzBiEOHYZSobtbBc2
	 piNTKGvMlYScu3O4MIEZtkxzeaHv/OskXDaRzCRRFhxF/gC8KhbSY9XQAQYg5wTEPV
	 AORu3RrSVAcOA==
Message-ID: <f3d2c81b-0a58-4fae-bb33-302627f689fb@kernel.org>
Date: Sat, 8 Nov 2025 10:32:48 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v26 16/17] scsi: scsi_debug: Support injecting unaligned
 write errors
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Douglas Gilbert <dgilbert@interlog.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Ming Lei <ming.lei@redhat.com>
References: <20251107235310.2098676-1-bvanassche@acm.org>
 <20251107235310.2098676-17-bvanassche@acm.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20251107235310.2098676-17-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/8/25 08:53, Bart Van Assche wrote:
> Allow user space software, e.g. a blktests test, to inject unaligned
> write errors.
> 
> Acked-by: Douglas Gilbert <dgilbert@interlog.com>
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Bart,

I think this should be sent separately as this is useful regardless of your series.


-- 
Damien Le Moal
Western Digital Research
