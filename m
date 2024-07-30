Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D119818CC03
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jul 2024 23:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722383059; cv=none; b=E8fdAg08c4rAP8qdiq23GryXlInxzuPmDEir13AOly3hLKyx8VXtUiSrYN60bAFeQq+W1G/216g3P9cFlhdOuugVWyG3gDyB9PRuc+c8U8CI3TZbhUnd9vidmKGivXdfJ1ghD7zO1b+L/62bIanLGKUGiq/Vj7KZDBu/1IyvLpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722383059; c=relaxed/simple;
	bh=Pnnhv9XZIAP5HEvlQ/OhP/eeEqQyOc/IWXNGe02vw1c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jirBCiC8r/DIDDscQsu5IcaRrSVia0XCRgahH2lWHhkdE/jLJ4TF/4C/RC20ZXED6Hgq1cEJVJ921/yrQF4xwlBSzROo3CeBjIYZuZZLBh+XXsw03aHb56C27WOViEMj8LtNrTig9J7qgjV+sZHn1aeP/4A7tW1WaJ8xdwb3omY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=euHyHLTc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="euHyHLTc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85BC2C32782;
	Tue, 30 Jul 2024 23:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722383059;
	bh=Pnnhv9XZIAP5HEvlQ/OhP/eeEqQyOc/IWXNGe02vw1c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=euHyHLTcfYJvcN3hSjj3BK5I+bT56Nc7GiHi4rkd9LJB8jEsz4Sn0798QfLYBp0r9
	 VQ5UjSRvhz/rGvEtrJlcJ8TvWK7GTLmMbgWgKaBIx/5UBUGx5ztgQUcqd7VgRveCJp
	 fLe106ofvLlpCoNmYQGWxH7FA0paoU/t0InZ2ldis/hPIFKRbGWRgPloZUkwj4qdd0
	 ZADAp3Kkuq1v0eJ8z5wCNcyNhx7hqfOeHH9Xtm47PjYjmE/GGTix7EsFMalzaV1ak/
	 sco33mR7as/5PdPEXCtdhkN3Kv7dVRyrZsm1e1behNA0GtTjvlrv5qNtYNuwhqlZHN
	 SUKeG4heTlO9g==
Message-ID: <dabdf007-8f38-4afb-9317-295a7ad6dc18@kernel.org>
Date: Wed, 31 Jul 2024 08:44:17 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/6] scsi: sd: Move the sd_fops definition
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 Hannes Reinecke <hare@suse.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20240730210042.266504-1-bvanassche@acm.org>
 <20240730210042.266504-6-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240730210042.266504-6-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/31/24 06:00, Bart Van Assche wrote:
> Move the sd_fops definition such that the sd_unlock_native_capacity()
> forward declaration can be removed.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

