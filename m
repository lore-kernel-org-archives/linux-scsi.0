Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D9A5028C
	for <linux-scsi@vger.kernel.org>; Thu,  5 Dec 2024 21:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733432730; cv=none; b=aEGRJfaJ7poRRs9JWzyAX0WsNLjqGlxRF1k1k3n8d34tykgVaOGp4MngSleTpolgG0JswkTihimj6oHQyj442CL8yljBl4PhBIZkPUdJL7tL0KMvcNlpQvyfbXZR6B3JZ203a3UuQzLu7976b1O1szPx34VkgL6Xqab5KoYZg0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733432730; c=relaxed/simple;
	bh=MNmXYjxB4XaYR8DXUYQyKQ8zU7BMCCDbAt+peiIIbq8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sO85g8EVL3/GJnVjqLWLLwOaaCa2gg1fL2nLhudZpu2gKQXEJ7K9ybGpKbAgz3OjVXeAtolXMN01sYQPAcT+wZ3x7PtqB12sLRQ6sC9Yng2GvRL76kVBmgTO5AbIDgw9U7/3UM6yK2EGgn20LJofFnntBXy165kn8GAOr8hGLrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mWUMLqTt; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mWUMLqTt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
	:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=awe3ZeDg6QeaK+2CuRSkG590RKRCHOMF6m/Tdcv7qUA=; b=mWUMLqTthX3ZILRROUa774xxij
	MkolykvwOOtv99ZrzpYAFiHFIQXtSNsM08ud37wniScdunQtKtnmlQnfrynSVOmAsaEkiCgEOXTNy
	f7kYQsx3LctqMyu7yMrgDQfmpbRVFLp3n07tKPCa7W34woz957wPGBki7/yhVRkYD3VTI7S7Deea0
	FwavxgMn/h7U6O9smu+AygtQMXYNWgj431d9mZCmSbG6feZqagsfZCPOFbuOCHrkuESsZ04F+BlnU
	ZyKhnT6sxWCVQUVo9vlnALQEAlUAGv9tEM42Jz8+hQZuKTNKKlk4VrvdC2brb1zRyHkCJ2sU54ZU+
	lZQzR05g==;
Received: from [50.53.2.24] (helo=[192.168.254.17])
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tJJ2C-00000002yC2-30I1;
	Thu, 05 Dec 2024 21:05:20 +0000
Message-ID: <8bc51b87-60ff-4064-ad8c-be98116fd41c@infradead.org>
Date: Thu, 5 Dec 2024 13:05:12 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/5] Replace the "slave_*" function names
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Damien Le Moal
 <dlemoal@kernel.org>, linux-scsi@vger.kernel.org
References: <20241022180839.2712439-1-bvanassche@acm.org>
 <69d7efec-1f69-419e-a300-84ff347eaa46@infradead.org>
 <yq1ldwtoqbk.fsf@ca-mkp.ca.oracle.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <yq1ldwtoqbk.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12/5/24 12:00 PM, Martin K. Petersen wrote:
> 
> Randy,
> 
>> Can we expect to see this merged for 6.13-rcN soonish?
>>
>> I am working on some patches that would like to be applied
>> after this series.
> 
> Already merged, it's in 6.14/scsi-staging.

Ah good. I was looking at the linux-next tree.

thanks.
-- 
~Randy

