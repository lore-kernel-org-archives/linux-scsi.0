Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C309C2951BD
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 02:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755225145; cv=none; b=KA4xbVche+fQAuRUPF6CtF6nfPtuKE2exFhQzO5OVVuBt6hTeeldUu58FxCg2OZ6oIm0X7upLdXLMe7xykRdiJFTNtell/tMlCrUxvNslf2EmMTjTJPMGubuyqKXpakO2o+TC7LQvr/8gkwoZBncbiWYFOjetp9toV82gR8CSb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755225145; c=relaxed/simple;
	bh=SAgGV4IsFeyvGnc3SmSDzjj6mXwJTYXz3mD5xh8Lp6k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fzBHgI7DUEgGzjEVg2O0uiN7mmrxPyDxo3/XcrFvSRCz9st49vlX7qWm0WgzK51JEUt3xKuWqoGL0tpvbJ+MPaodIQteKmfjFbcJzmp/lUxdFF+l7C2hE9wXFpQMYxlwN1biHdnurgaGEclVnbK7A+vR9JQ8zB5ZDEZdId8VO78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JH8KFWrZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JH8KFWrZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C50D5C4CEED;
	Fri, 15 Aug 2025 02:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755225145;
	bh=SAgGV4IsFeyvGnc3SmSDzjj6mXwJTYXz3mD5xh8Lp6k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JH8KFWrZs+88aUG3XsTXeK0+6NwrsSQQ+iBCY14J7JjFy7qPT4bO58cDTDdyXlqZg
	 PZBwUXL5ySkTRbE7AVHMmnOM6sRLc6PrmC52HaaAtNnFIbaz9oCryK67MKToT7XH5j
	 3xB/UW76K/+22o7OwfsQS7P/c/Ol757NNQP2/zVbEV7AyjdJhkYJJYPmC0j9N0rG/I
	 GKDzQTC/Z1ti7LNh1nnFCD1gPlwrxYdd/q+KZmGQtO4Kjq0myYtp9A72kvVE4c3Vnw
	 9cH/OfbjQMKpyMeRbAT/ApxP3MiP9sEs9XGMwl9Grhndif3JcIUosQNMKee+wyiMQH
	 fUyfRjQc1mH7w==
Message-ID: <25b51bbb-6ccf-4ecb-a2a1-25397ecae583@kernel.org>
Date: Fri, 15 Aug 2025 11:32:23 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/10] scsi: isci: Use dev_parent_is_expander() helper
To: Niklas Cassel <cassel@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
References: <20250814173215.1765055-12-cassel@kernel.org>
 <20250814173215.1765055-17-cassel@kernel.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250814173215.1765055-17-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/15/25 02:32, Niklas Cassel wrote:
> Make use of the dev_parent_is_expander() helper.
> 
> Signed-off-by: Niklas Cassel <cassel@kernel.org>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
