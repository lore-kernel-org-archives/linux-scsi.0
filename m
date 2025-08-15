Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04691A9F9D
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 02:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755225257; cv=none; b=qbocK78KH5A+vjWZ0gZeYdmvPdveoDhJGyEL1lRHcCf0a1Dr5bgZQgEHzl+1CnurNtcXDXOcnrUewZ5IKAxQ0/9J2dyrWenutOlTdPxw6V9u6Dsf/4RBbFmBJS5hiyRQeCPEVbV8osNyZif9m6cWVbI+QjSFaCMjAHuXc//iXxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755225257; c=relaxed/simple;
	bh=MSigjS3ftUzGCSLbWZ/H2GqTD86ffJcnw0VRQP3SDIk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MHRynvhPIH5DcuBqLS3t5j6Z+rTCrdU73smbeI3WRzMiC6r2BaQ8a6Dy0xa+6C5ggEgrVizkNawzqdEgeg9GIJxpDnlWkE1yRt1uM9B19NwWd0miNSCbSoXT43vaz6TxLIceXR1a2HnTlim9hdIVyI+wFW2R3lnTeDXiqfU3D04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iTGzpg7g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iTGzpg7g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16042C4CEED;
	Fri, 15 Aug 2025 02:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755225256;
	bh=MSigjS3ftUzGCSLbWZ/H2GqTD86ffJcnw0VRQP3SDIk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iTGzpg7g13e2c43IcRBljBeAQWQiSqWLSJhi3/ZrkpVv6a5atXqzW5fXQgxTnLpFj
	 dB032MLcHWMAr4C21TmGrUcPChfeZE5v+f5Mrn6xT0qJihDUvVmJUXqfUIxRZ/lc37
	 CvWiuaUNEwfSvvgN9XUTmKI4oQYIde4W6S2iuqSPd74gUeJkWUpDWLVsLxNpfwlb6a
	 8T/bntgK+M8rgOML0rt3rZK3GFGEHA6sja+Gx4WQ0KUNie0yA1pHTRpzWWN/m/cZva
	 M8cRcrjeSnaFvXVP3S/aOIHXO0M+PLnTx6gHRvl5RAsdsMI9o5MZEBzz2zqUMTV/6g
	 njoangvoWyZKQ==
Message-ID: <43046701-6cc6-4595-a0a9-14dce441659c@kernel.org>
Date: Fri, 15 Aug 2025 11:34:15 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/10] scsi: pm80xx: Add helper function to get the
 local phy id
To: Niklas Cassel <cassel@kernel.org>, Jack Wang
 <jinpu.wang@cloud.ionos.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
References: <20250814173215.1765055-12-cassel@kernel.org>
 <20250814173215.1765055-20-cassel@kernel.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250814173215.1765055-20-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/15/25 02:32, Niklas Cassel wrote:
> Avoid duplicated code by adding a helper to get the local phy id.
> 
> No functional changes intended.
> 
> Signed-off-by: Niklas Cassel <cassel@kernel.org>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
