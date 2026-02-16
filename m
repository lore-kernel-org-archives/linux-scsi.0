Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7E72D73BC;
	Mon, 16 Feb 2026 22:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771282636; cv=none; b=DwhkGBxc4mp7X5K8kJ9y9RqDHM0itrv2/5e10Ob1iFjPXvpX9ggEFk6Qanjt8i8DWoW/x0FwBQKTtfGo+aqivgHFbnEoZ7Kjz9zeuMNBcaX0wORA3p3iE3A4qDeqhtcShuIpzJyKZ3gX8rL5evhNaGDgR8ZsF0846Fy4ttIOaN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771282636; c=relaxed/simple;
	bh=PgEaeTEkmSkXbNawtw0bcEIu+CwOTOvmxPBV83PTYnE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hkf6LLmIn+PGAvV6wfYWlgxrvOfuyG65CRxChgoAN4itwPm1zLIep0HKMYWAoAbC3kmVY/PNVcdbU1owuj6SUfpQGRxNkgSSRGVHPU1lbYjhuZVUikloK1RQ22FAM2T94OWcQYk/kH5cl52diJsJ/hZFi0yHAIVOUe7EFmaW/A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RYRlxEKq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RYRlxEKq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49574C116C6;
	Mon, 16 Feb 2026 22:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771282635;
	bh=PgEaeTEkmSkXbNawtw0bcEIu+CwOTOvmxPBV83PTYnE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RYRlxEKqCP8TPHQRukDrTwCKandRB5F9eHK2glcmfyxiyUno121I/xTgeR0Y9xgXx
	 oRbVE4dVsvFcwwmRr5+0JX8el7iQGk37ZVipgwkMLXwE+azOuZ3WDcEd7ulHiqRsa6
	 /UXCkIgmRpjAkAA2xYxFO9s4PYYKn9H+gHjelgjLJJOlniwG0QVcXniu9IGjr9ktMA
	 p3c9gXGj/ht0XThbAYE0h4nyAIdlKkBGJEOcwwHw2KtARrzonry9eTW22ZnVTm72Id
	 SGaX2ROYhCDoF4+VdJyaK2iYyDMv3tsel4OdNd1l7MniObmI+wM3GWM0paVmnjEh8Y
	 yGDF67BpeKzZw==
Message-ID: <9f4cc1a9-d475-4835-ab8e-d8c69017ea96@kernel.org>
Date: Tue, 17 Feb 2026 07:57:13 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] scsi: scsi_debug: enable sdebug_sector_size >
 PAGE_SIZE
To: sw.prabhu6@gmail.com, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mcgrof@kernel.org, pankaj.raghav@linux.dev,
 bvanassche@acm.org, Swarna Prabhu <s.prabhu@samsung.com>
References: <20260214011829.508272-1-sw.prabhu6@gmail.com>
 <20260214011829.508272-3-sw.prabhu6@gmail.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260214011829.508272-3-sw.prabhu6@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/14/26 10:18, sw.prabhu6@gmail.com wrote:
> From: Swarna Prabhu <s.prabhu@samsung.com>
> 
> Now that block layer can support block size > PAGE_SIZE
> and the issue with WRITE_SAME(16) and WRITE_SAME(10) are
> fixed for sector sizes > PAGE_SIZE, enable sdebug_sector_size
>> PAGE_SIZE in scsi_debug.
> 
> Signed-off-by: Swarna Prabhu <s.prabhu@samsung.com>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
