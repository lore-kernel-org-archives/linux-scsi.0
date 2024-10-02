Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285628F40
	for <linux-scsi@vger.kernel.org>; Wed,  2 Oct 2024 22:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727908196; cv=none; b=OMtG5BQWp0PeK0/jZjR+N+OoMOQK66YpA5LCaOTGx9NyjOs33J/lA2X6IIirhPYiAPau03WneZwpAh0RsypLsoCUXDp9cV0w9BqTFwmJq2eHQj+a2cxuU8tpPMf2vbBa9OqI5OAbB4AZpWO1CfcSj9M/MsKL9pPQCLhgNiDlaZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727908196; c=relaxed/simple;
	bh=ceSr2ynchHHBW19/XSSwAO1uVOS38cnUL1aGdx2SZFA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bmvHMHaEz7tFMKT157ZzGTLe2fOafwmfErSzxuXHNmJ4eMxwAeT9D7TCdW9U+ugYSyYTKXozOl1Bu82FQiKyeFm8sfeLDgFU/3XsKS6Y3R5EdDTOJacPp8VLHEzKhZ2rV85HFEhjj0Si3wLTWoJ3LCOULu5q5vhIJM1BqSNjKXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nnAJS+fv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nnAJS+fv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14765C4CEC2;
	Wed,  2 Oct 2024 22:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727908195;
	bh=ceSr2ynchHHBW19/XSSwAO1uVOS38cnUL1aGdx2SZFA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nnAJS+fvvKW2J9yVBOpj+xQquwd2vLtMwYJ4qfsaUT1VEEfAlrOdpEGcT5ofR1cGO
	 TcdjtAd/crQqN5K5WBqWzYKKOd/w3NVotNLeaV2q04SM3l8vOjnSXCpHAUBIYlbaeX
	 MK3TMJ0IUy5deGfw4/5zd5a4GZ3LyDPG/m+2c1upA2L+2UFf4LKXuyZXYoBfVJ1I7x
	 Jo2pWSk8p29HVP+nS91AYG6q2vhNEyKprX3TI1FgaVga0T66yEagWtMsdBMeLipbd+
	 H6KcakH6ACjCJiGbhuOwxbmbXQGJocgCgZvr0AZVn3H2ISRmif9Yz+sguo7IkfldjS
	 eLB8mvcUelJ3w==
Message-ID: <729af557-2759-43e9-ab41-c772ab8243a7@kernel.org>
Date: Thu, 3 Oct 2024 07:29:54 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/11] scsi: ncr53c8xx: Remove the changelog
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
References: <20241002203528.4104996-1-bvanassche@acm.org>
 <20241002203528.4104996-5-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20241002203528.4104996-5-bvanassche@acm.org>
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
