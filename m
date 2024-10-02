Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32DC8194ACF
	for <linux-scsi@vger.kernel.org>; Wed,  2 Oct 2024 22:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727908223; cv=none; b=nGK558/8BDBj5eXf+3w8StxX4gXG3fG9NERx7TAapU2HkpU1W/dSC4MRLj9hgLNsulWjtHXS86YmajTID9YffazOR0l7zEO33Z8Zpoj5IXNBpH588cW3B1yUxi/fJrwn6mZxAlgoEGESJ+P5Qkdz0GiLGTvLQV1Yo9yk1tvbCzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727908223; c=relaxed/simple;
	bh=ceSr2ynchHHBW19/XSSwAO1uVOS38cnUL1aGdx2SZFA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fJ2lADevorHfdskQyYM17bzkm2E7KG7Q3nlPNqHTdW/B4jVhvbK/Hw6G5RxLLcz3uzvpc6b7Ah+3zXsKnCj9al5b55pc/kwEtB5UvpcYbrgGpsOImNeVDLkUsURXIHmG3sLQMtUXRLATlAiF1J8zorG1uOc27/8lq3H/4PJhNV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=APgPLwuG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="APgPLwuG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D192C4CEC2;
	Wed,  2 Oct 2024 22:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727908222;
	bh=ceSr2ynchHHBW19/XSSwAO1uVOS38cnUL1aGdx2SZFA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=APgPLwuGyzDG1Owi/DMyafF/CLVADNKGYYn42uPX6F9OkJZzHZEyfdcZ3v85+ZjJh
	 k71agWivkXqMRKGrW3HJ94GFMJaq6QoRXhWR2UDgtkjp7Jyu/Lx0qKJhXXvUEmoiUy
	 /aLCWPx8gvD+iXwGfC6Ebq1HMnoDFVE4/5BdUl+VEEBCor5XeX2kN1sg0AvPrUm+v2
	 19GNGxgAoXWXreCQp4ENdz58sfhCFJtDA/21cJ3F9RfUCOvOhYRJcRzB7u2/98oW/c
	 GtZ/lpMJbWla47XCfEtfncjER0mjl9at+x1Qk6f6wW8Sw3LGFfw3mArIF2RGjDNKxf
	 xO9ADeokemeOQ==
Message-ID: <8b8c3a02-53f2-4435-b8ff-66db6bb4cb5f@kernel.org>
Date: Thu, 3 Oct 2024 07:30:21 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/11] scsi: sym53c8xx: Remove the changelog
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
References: <20241002203528.4104996-1-bvanassche@acm.org>
 <20241002203528.4104996-6-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20241002203528.4104996-6-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/3/24 05:33, Bart Van Assche wrote:
> Since we typically do not maintain changelogs as text files in the Linux
> kernel, and since the ncr53c8xx changelog has not been updated since 2002,
> remove it.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
