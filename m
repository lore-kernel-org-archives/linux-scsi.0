Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9058F40
	for <linux-scsi@vger.kernel.org>; Wed,  2 Oct 2024 22:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727908149; cv=none; b=OfmyGAOKzBET7xZkjiMnTGkxkQPCDNKeOLRwU/Meg1afVJgqZCaGBpyhdtiAU+65EvpMcqF8Bkbxd5P/fvuKip2S20MF+iDd2EBh0RqZsER0hYVYZ59141ma53FonllO5iZ1jgxPTh1IcNo3AJ90yc8fYRodFeFWDvKBjUGBk+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727908149; c=relaxed/simple;
	bh=lpEmjZ5W1AXiJUKNE0Ip/PiyUbsvLjOSrGuvPsgm7wc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=acTR9/bCCkFDxUBOvnQOmJWzgDYTQBma3KzgcS329PzFfnkfAwYMCJebOuCMnBgCfQ0N5hUi2d3bBe4jpFAZoBeXu6Oj5OQFPGobFFkrfjuAZCrCK8koNuARt2q7wGgrpycZItu/mt++xF/Zm5hMfZ4TNUe2pUAkrFf4OvpCjVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EI17PNG2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EI17PNG2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC41C4CEC2;
	Wed,  2 Oct 2024 22:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727908149;
	bh=lpEmjZ5W1AXiJUKNE0Ip/PiyUbsvLjOSrGuvPsgm7wc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=EI17PNG2OQRyqyqV15FIXxq0K9R18vL5ERaiehjmJmIZvEghdXiIJ6tThOTFmqyYc
	 2XObVLlxQAppjLSaVwCWIv8uBYe3u+a1GEeNtzaMBeU7GnsL1XzmbYNBZtvkISwXoj
	 MjSKEpKxQAQQ+XF3jmDvgAGC6wGMb9jQIKwkhI2/sEGZ8tkDw0XIgDIVPeZb88rXuI
	 /xMrxcuSidhve7RrCFSvm92EO6XeUMT4HpwqPeoR8Hoc4eKuKL9Uocnx61liIUW7vs
	 /OggGwxx0PYjrmV6zmsCthbTIhgoDyTnkqElJoSTY6Aj/REgeswwNPb7N/CJ+ofelQ
	 GrkWVVO5Hg+EA==
Message-ID: <592837f7-674c-4da8-82ce-d739e8001b31@kernel.org>
Date: Thu, 3 Oct 2024 07:29:08 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/11] scsi: lpfc: Remove the changelog
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
References: <20241002203528.4104996-1-bvanassche@acm.org>
 <20241002203528.4104996-4-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20241002203528.4104996-4-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/3/24 05:33, Bart Van Assche wrote:
> Except for spelling fixes, the LPFC changelog hasn't been updated
> in the nineteen years since it was added to the kernel tree. Since
> we typically don't maintain changelogs as text files in the kernel
> tree, remove this file.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
