Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F0631355C
	for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2026 05:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783487024; cv=none; b=PJtd69KkhARTvc08Fnoml+BTHvuoQUGAvyDLzew5xj91VqCZOiQjZIgpMnPccMzRklo6CA+Ga/le2Yl6ei82y1JGTfbmxwmV5min6YtuiGHIzvUfRCkv6ar5cnwc/cs1/kdqsbN9Z2iZZjEcWvvTBNoe3cFW93SD+wVAPrItIxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783487024; c=relaxed/simple;
	bh=RQOHhXbKwc8W8FochQlrUNE0GGyFfgJBfX9YuyMTUN4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lj5IdoJsALW1k6kmLavUMnRhXFAi3s80ba+Fv3nxn04Zm0spliLYovLDc/UKMGaSEcLCPdwYDmrGY0NiCoqXncy1biM2s3ON5tNDv2VlJnpzCGbiDpxVafpxhyPhquiuC0jrJ+JuinEbVL56mm/VH3xL+NO385J8wlkDXsdTtMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nQoZBOMg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nQoZBOMg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7760F1F000E9;
	Wed,  8 Jul 2026 05:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783487023;
	bh=TNa4U3jglo78ontyKQhgBMpIF+HRlYDxGd4Kb8y1Z20=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nQoZBOMgaJknnUj6bd20y8LZEKW05zEG6M1dPkA369WTu0PI7+o9088K7NtjQOdkb
	 zInVPqJ/KQqDCQ6ylQKsr4fDWiIs2Gr+vnqo6U/6R1Vqrm8FgLc5EMAlWGGUwAu+6y
	 jbH9Txc7E2+g5RXrXn9zazlAjt88hlIgUtSKEeBvKW95FFqJ2G2yEsWDlPQ3J5g9vC
	 gxsJTzpt1NvgJKIczbnRpPQYHQLRAjvVUFXOsJNcr6keK0DbfLIcGl9NcZDNncxmWK
	 mnYN/4GoKjaGrGtleJCyeZRi0xiikTmH0Cxh3bdFUCvurk387IHM7IaNPkMUSFpNdX
	 TV0WmdiNmPnjw==
Date: Wed, 8 Jul 2026 07:03:37 +0200
From: Manivannan Sadhasivam <mani@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Avri Altman <avri.altman@sandisk.com>, linux-scsi@vger.kernel.org
Subject: Re: Undeliverable: Re: [PATCH v2] scsi: ufs: core: Avoid possible
 memory reclaim deadlock in TX EQTR context
Message-ID: <yvqoymvwzy32dsvlease33e3dgapx2j6c2nebmbd3llanneh7x@lswksso2l6tg>
References: <20260618140941.902000-1-can.guo@oss.qualcomm.com>
 <h5lsilzmxhu3jyujladib3w75nsute7yrkr4t5sg57nwzwb2ek@d4btnbylvrvu>
 <f1960bd5-b583-4104-a343-e217ef7ed63d@SJ0PR04MB7504.namprd04.prod.outlook.com>
 <ucn5winjeqnixycuxldp3wgysrasrah4ie5egs4vo4prvy7e5c@6ef4y2gqqd7x>
 <20f076dd-636a-49f9-9a02-0046af2db0e2@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20f076dd-636a-49f9-9a02-0046af2db0e2@acm.org>

On Tue, Jul 07, 2026 at 09:41:34AM -0700, Bart Van Assche wrote:
> On 7/7/26 9:29 AM, Manivannan Sadhasivam wrote:
> > Are you willing to continue your role as UFS reviewer? If so, could you please
> > fix your email address to avoid bouncing?
> > 
> > I can also send a patch for that if you want. Let me know!
> 
> Please take a look at upstream commit b65b608eb8ff ("scsi: mailmap:
> Update Avri Altman's email address").
> 

Ah ok!

- Mani

-- 
மணிவண்ணன் சதாசிவம்
