Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89DC6244665;
	Sat, 18 Jul 2026 03:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784344164; cv=none; b=n27XBalaKVG0qBUMQ3FhpFOyeV9q11dE9eNu4waMo79sXvxVJ0iQKG2pIIrbACgJGsZZiwos49h/IkgVPM6qNvjgIx3FYUStuNT//lqQ08mFZ30bd7p/R0ZNBme0+37A+tJOR1Jw0/eM/H0S/mxlmAHtITSeToCyANyds6IEx0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784344164; c=relaxed/simple;
	bh=roykzd+QFosNN/pthpXHLqb7IroROAP/jITXXrLuN3U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aEWS5qWZT7DTbAyHs5JnMA7tsefKe+MTs7aG53NrSauey5W0kDaU5qUhYp5NmDw34q990wEhzLISyFMJdE07fI3G+Dcqjhv0G2p/MQb5suL36wKZI6888oZK+kQdDwCYyykgw3ec/vs349KknJflPUW/tfXGMYlvnxK7tKKkAQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V4XvIPDV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V4XvIPDV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCBF61F000E9;
	Sat, 18 Jul 2026 03:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784344163;
	bh=bALSyLsYMTzP+pcvxV0IAJ7BZk85UdAjFMFItU+gDqQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=V4XvIPDVRMgjPgWLM5vpD6NX03TYTmCWt1E3VR+TlfQWVLSBUYjAWhPFHylV6VGZK
	 AFchmtYPB3xn2QdT7EMx6f14i8cPwzlldsgFrVue+MLcXeuBW99izTrqUW0x4kK2AC
	 jSZfChzrA5jKJy9tG49gw7WcolbmYZG6hpsUsp4C0+k6fwxr3FwBPyeeGfB8G2AYyL
	 F3rJCLNZwmyRId5Z1kkCeHS733Dre9H0j5p6LGomek1VZcWGfPBcY1mCT/uAyafo16
	 Vfrl/XicCPorFVY+AAv8IumVf46pKlYzYrCWkt8Q67ESNGmCRcdtgL4IdQyHNRzgQi
	 z1mUUWclydqjA==
Message-ID: <b889d380-1767-4b83-847e-7d9cda3e27e3@kernel.org>
Date: Sat, 18 Jul 2026 12:09:20 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/6] libata-scsi: multi-LUN ATAPI device support
To: Phil Pemberton <philpem@philpem.me.uk>, linux-ide@vger.kernel.org,
 linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Niklas Cassel <cassel@kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Hannes Reinecke <hare@suse.de>
References: <20260611024356.2769320-1-philpem@philpem.me.uk>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260611024356.2769320-1-philpem@philpem.me.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/11/26 11:43, Phil Pemberton wrote:
> Some ATAPI devices expose more than one logical unit behind a single ATA
> target: Panasonic/COMPAQ PD/CD combo drives (LUN 0 = CD-ROM, LUN 1 =
> PD), and Nakamichi CD changers (one LUN per disc slot, up to 7).
> 
> libata has historically hard-coded shost->max_lun = 1, so the SCSI
> layer never scans past LUN 0 on any ATA-attached device.  This series
> lifts that restriction for ATAPI devices gated by BLIST_FORCELUN.

Phil,

I lost track of this series.
Could you resend the latest rebased on for-next with review tags etc added?

-- 
Damien Le Moal
Western Digital Research
