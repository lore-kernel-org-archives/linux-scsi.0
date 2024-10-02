Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD0412E5D
	for <linux-scsi@vger.kernel.org>; Wed,  2 Oct 2024 22:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727908738; cv=none; b=fQlqIC3YpzccNinr0PA4MiWPRRUCfxiuMtPPLQCiFnmZidYjXUM3B7lPo9/c+VaWo0yK6lriUTtLO86euZJY+P4uVtZbkWJjiZEq9g/vQnXG/gFo+UonObpZkv2uWAdKx2K9tuBw5gT3CoSKwAegKy0FaV1CdvFLzmBC/vKRHlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727908738; c=relaxed/simple;
	bh=p+lfHYBJxnMiy/A6TUVoxghT87SorSeCBNRjp28fkuA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kAxpTqKCcmUBxmYJTHPAl+6Q27Ko9AvXwoU3zQ1Nq8DI0w/KXNZfdRdM/NHUYyPT1K+ezh5eLSLsypu+/f72LK7lM47gNmYwwWXURSLmgQJx326KwYxWs7PUPoowKoYU4SDKn6LFarnaltS9YVCaU+gYpellCHRH8+C0FFlAuNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kwy5Hmoj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kwy5Hmoj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D08C4CEC2;
	Wed,  2 Oct 2024 22:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727908738;
	bh=p+lfHYBJxnMiy/A6TUVoxghT87SorSeCBNRjp28fkuA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kwy5HmojRAboGQw1+bzJLKN+6iDAqmP/dd1+ZedYf2s1hbzq5BSS0bmhAjakLcTTg
	 e2vcvicrHe8BuEu32cYJKj/Oi3N+UXihu2OLAb5I4aI4oUFLWuq/EZaet7+VaQLNvF
	 silSRJADKftZ/TqavT+bKcfoBB+HTTiS6IGjSGak4WVAxTeZ0EgBFDYxK1dyHBxJQY
	 kIN6mEEZttDeH9MOBUVWcIMoKnt6GYwu1zCBVeUvC2xwDzjtwapYi+j5x8qK/VFsS4
	 frgtesVcdSrflDwm4oyRC0YBEZUkS3wxxY7XRlcVA4rJmdsFVt+vcexjrW2liAd7V9
	 crcpzFYhaHXLQ==
Message-ID: <157221c0-b6a1-47a6-9a16-19f982acc2f8@kernel.org>
Date: Thu, 3 Oct 2024 07:38:56 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 11/11] scsi: core: Update .slave_configure() references
 in the documentation
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
 Randy Dunlap <rdunlap@infradead.org>
References: <20241002203528.4104996-1-bvanassche@acm.org>
 <20241002203528.4104996-12-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20241002203528.4104996-12-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/3/24 05:34, Bart Van Assche wrote:
> Now that .slave_configure() support has been removed, change all references
> to .slave_configure() into .device_configure() in the SCSI documentation.
> 
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
