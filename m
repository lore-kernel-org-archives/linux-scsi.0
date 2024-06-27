Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B793DF5B;
	Thu, 27 Jun 2024 01:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719450993; cv=none; b=SjAXX9U3f+iT6jICyDBtBhTOKWug3rmA+MbKXtS4ytg8p5pmf0a5m5HIslggG0eqg5VFB2Nj47J56Jyd2UWQF5rR4q5s6pW/8V2qtRlG7LheBfS2B5Rk0AaVfMI9ZB1zDglr3MISvsg4VYyM2dG0uKnB3kBgS57uH63L/OtF/Lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719450993; c=relaxed/simple;
	bh=/STcYAu0sw2PuxnMB97gwIeR60pr6DjR2zWUsmU6I8o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Uf11qowkVMS6ZcDQ+J/wS8jMYRVT53a3C8kAJHuEik7nZ5y+P7O/0yNBVYpyIRsD0nxG31vt04MHCyFVtsgxaIAHsLLUd57XI4YzQCsCIuT0T1X3WbDW0/1t5QqZQ9fGqedRs6VEqxIOAY22JmG9674HPfFgajvhDDKBylpAXHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RZitIJnj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RZitIJnj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5108C116B1;
	Thu, 27 Jun 2024 01:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719450992;
	bh=/STcYAu0sw2PuxnMB97gwIeR60pr6DjR2zWUsmU6I8o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RZitIJnjT0+m+i1tnXPrFL2r0REB3de+KCsJiig9g6wTa68fFG14VGPlQVmngTb1b
	 3SBqPRf82T8D02vPC57Y56hYxd4PQmPn6YyIQSK/NYHtMVWxX1/9yhEAyW86Xz+avE
	 MpxW2HJfIJJbrdBBrAp/WIZ9JKudiM0iO1laH73rRYWDx/15mn6Q8VvuDJp499kAL3
	 5CYSm/q/b4mVomLPcw+RRjmfEV2/tcJDwMngCDuPMRwlKG6sLSz0IJxoX7naGkhqOw
	 i/ZwgeB6dmZ++R10FjiGRTJ4dKY6ud3ueRzqyoH0qm6BBiEnMtlasegci0KoU1sMDv
	 qtXX6sm7Yttgw==
Message-ID: <49312dfb-be4f-4b9a-960c-3b4d972ea350@kernel.org>
Date: Thu, 27 Jun 2024 10:16:30 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/13] ata: libata: Remove unused function declaration
 for ata_scsi_detect()
To: Niklas Cassel <cassel@kernel.org>
Cc: linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
 Jason Yan <yanaijie@huawei.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-ide@vger.kernel.org
References: <20240626180031.4050226-15-cassel@kernel.org>
 <20240626180031.4050226-21-cassel@kernel.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240626180031.4050226-21-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/27/24 03:00, Niklas Cassel wrote:
> Remove unsed function declaration for ata_scsi_detect().

s/unsed/unused

With that:

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

