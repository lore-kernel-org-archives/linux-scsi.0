Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCBFD8F40
	for <linux-scsi@vger.kernel.org>; Wed,  2 Oct 2024 22:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727908118; cv=none; b=MkgbXrn3NnaYoy3V2RSVAjfMpzu+sXOKfG8JgaPIkoFC72hGU8oTApEONMSgS0qcAXZ0pCi2vQMDJzXnYgd9DAK6TvepNyZzupnSY9GiJZt3x/PrK39DwVIPDBFo+cwO0R4TnfigdUYW6VT3c7E4Z/XfiwTgsC63/tSOk8x1idw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727908118; c=relaxed/simple;
	bh=L9Crd8WbJ+Ai98qqQzRwzwheTXvpbCy4yheLQZPI3pw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gTJxPhjpQq2zT7iSFz0LLiDvmWjMMmTjRC7C82k54LhY4/REN393sooxWXzwcU3tSuOl7NGsq8sr9Le70O5098xu9eFhoM6RMJnZx9Ul7eUvrRazTJ1Xs2hlN1ua1kpC5Ip1TmtfkCRK4js9CAIp6+2C4YjYY0WrqzAo4QJ4260=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XRqCMGWC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XRqCMGWC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BAFDC4CEC2;
	Wed,  2 Oct 2024 22:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727908118;
	bh=L9Crd8WbJ+Ai98qqQzRwzwheTXvpbCy4yheLQZPI3pw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XRqCMGWCw2UEDvQexwEQlIkdJpu2QnupS644i/eom6qcLLhulthWoGg3mEdhaMBsj
	 qg5vCn2AIOkD7Iw5Mssw+1s1DwczVyOFhBtRI+e/ebG4drzU+aCliVgTMGv0I2T5t8
	 3w434d4djBjgDEugkrwEwCz6Abyf8RdDkrYkioRGvOMPwdwhjp0jqGvWd6NQmFWMbt
	 5ExrVgHFdh6zykb6goLpKRHc7WOdS2T7nqXf9vIhSkFoRGApFBfWN+XuurgtnSl3Su
	 r/vO2MlHqSFZDff1rw6kGwXHmoTordfeAYMMabXYeKN+JHLgJMWZ8JmNalYVQ1SWWP
	 MWThvRL2zJidg==
Message-ID: <c5d88ca3-3db0-46ab-9877-0499ffb02cf9@kernel.org>
Date: Thu, 3 Oct 2024 07:28:37 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/11] scsi: ips: Remove the changelog
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
References: <20241002203528.4104996-1-bvanassche@acm.org>
 <20241002203528.4104996-3-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20241002203528.4104996-3-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/3/24 05:33, Bart Van Assche wrote:
> Since we typically do not maintain changelogs as text files in the Linux
> kernel, and since the ips changelog has not been updated since 2002, remove
> it.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
