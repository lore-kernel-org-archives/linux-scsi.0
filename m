Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A2225A353
	for <linux-scsi@vger.kernel.org>; Thu, 23 Oct 2025 17:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761240607; cv=none; b=VitGH8jtnUz9VfXaOig1A07CpE6swjh8PX7XTckg88zDqrpKEQfikE5gL6uMWkLWNXbDZ+Jh0zikRF+9vOSMOYznBnlGrBkhrZFBFB1G2qWj67ABOOW50bgTqSeJ0j1td9VKtGQW0Z5Uvza/tBYW7Np4BLsFNMe+WdpkkneBeC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761240607; c=relaxed/simple;
	bh=f5+MiYIy/tQgcXje5ttkzN3IP0Oa+OMgmSxPSDcMNJg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MgSCsxsFxONLW+AC7kwQrvGpJutC9c87/OsPqjx+IJruzTOIIXHalBsR1qvaWqjde9H9mJ7nDZAXGrgT6J//x5Jwom/5RRWALspUb8Z6DIZy9WsXXR1CZN5oeCHBEha6cYCvJ2kNGMJTbdIzSvmYkzYY2hYEFRL1m4E3RRlQly8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=VRVBkE+U; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="VRVBkE+U"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cstMV2pBwzm16kj;
	Thu, 23 Oct 2025 17:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1761240597; x=1763832598; bh=C+yom9Rot9gCTldqZnotqMSJ
	s7sR/NQvL5jgCCFwxGA=; b=VRVBkE+Uu5uwCUAc/DMUFTo3aXAUik2i1HSj1E9n
	42G5xnS9DQ2UK9PQjmutfr+d2pBk2+wdcClVWYSQH92BvVLLM07Drj3GttWfFZ7/
	aYKQPkhuLZChiKl01ksReB8WWjYUK/EPMunTuVwIuSI7Dg0mBh7BjyLQYPVFG8jy
	AQHsGULjmltjukhenFg01QJwoV6jpST76NJECfS5BQCScMeKvimYzewy3lYA0LPW
	ZLhHzQwMaq8rW9GHrCI3cANQahX1JbP+0j/oIAQOwun6ooIhcFOt2VVS0TDKpdYs
	EOfXWquZgWfMMnSYEJ+8RfR38tN+bHvsW1+w5j32DWlRrg==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id HWs337TwhQYA; Thu, 23 Oct 2025 17:29:57 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cstMR6LcNzm0ySQ;
	Thu, 23 Oct 2025 17:29:55 +0000 (UTC)
Message-ID: <0747ab58-1895-4753-b4a0-4e93bd7091ff@acm.org>
Date: Thu, 23 Oct 2025 10:29:54 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] Eight small UFS patches
To: Manivannan Sadhasivam <mani@kernel.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
References: <20251014200118.3390839-1-bvanassche@acm.org>
 <yq1ms5j4raz.fsf@ca-mkp.ca.oracle.com>
 <ueff6kzx4imwyz4bqxgls34lg7mw6oyi73yyyyiqtitbxu7p2v@rhlok6yvytj7>
 <f761feb4-6b58-4778-9417-067993a484fd@acm.org>
 <b5rfpnuhhewqmnaqa2uzivmo3byzommrjeanoawn5x5vargt2y@7vl7r2uw7kjo>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <b5rfpnuhhewqmnaqa2uzivmo3byzommrjeanoawn5x5vargt2y@7vl7r2uw7kjo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/22/25 10:31 AM, Manivannan Sadhasivam wrote:
> I don't see how there will be merge conflict unless the remaining patches (3-8)
> depend on fixes 1-2. In the cover letter, you also mentioned that the first two
> patches are bug fixes targeted for v6.18-rc1.

With my comment about potential merge conflicts I was referring to this
patch series: "[PATCH v6 00/28] Optimize the hot path in the UFS driver"
(https://lore.kernel.org/linux-scsi/20251014201707.3396650-1-bvanassche@acm.org/).

> I echoed the same thing since without these fixes, boards running v6.18-rc1 are
> throwing a bunch of warnings making it inconvenient to use.
> 
> Ideally, we should try to fix the newly introduced warnings in the current
> release itself without relying on stable maintainers to backport the fixes.

Agreed that warnings/bugs introduced during the merge window should be
fixed during the rc phase. My understanding is that kernel patches
should be sent only once to Linus Torvalds. Hence, kernel patches should
exist either on the SCSI fixes branch or on the SCSI staging branch but
not on both branches at the same time.

Martin, is it still possible to migrate the first two patches from this 
series from the staging branch to the fixes branch?

Please note that patch 1/8 from this series is fine but incomplete and
that I plan to post a follow-up patch soon.

Thank you,

Bart.
