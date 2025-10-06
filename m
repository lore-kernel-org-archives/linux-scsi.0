Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800D713957E
	for <linux-scsi@vger.kernel.org>; Mon,  6 Oct 2025 02:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759716449; cv=none; b=WTwwJg0PIpJzjBFvSBRaIVgFJCFM2WQyoUTcK3qV1T4QmVVmX9356gxc01ZyDxQKdQDGPfndblX8ew+g5bvnfjhYkY3oMTNNFyVTWc61HQ0NH9nmbJ1K/OwXI8MHj11Hj9u0SiGkW+iTBwz5m/1AgjrzTatERnfgDHoEow/R2/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759716449; c=relaxed/simple;
	bh=gYlzpGJMP6QUFvSZeac3KDwxppkNF8ie7uda0A9wtSE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PUso3AcLJG3T2N73jn5CR27ERcUGHhw3dHAiN1N13xY/Kqq3T1/CX6p9ceh8F4nmNEABoniWLf0Bh4g3abfSyLSfeMXDOcEu+NmHYz9XYjDHL/XaIVE/u1NxzNzwpSKEkNShZ82+FjOvWcpPeJEjb30tHHf+0HlL2tfCBPVI0WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c3j7jyqo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c3j7jyqo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34147C4CEF4;
	Mon,  6 Oct 2025 02:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759716449;
	bh=gYlzpGJMP6QUFvSZeac3KDwxppkNF8ie7uda0A9wtSE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=c3j7jyqoIF0BdoIMLaFm+HKzBdagqNbPdtmDom/GClwHbsNt2R+LWaJybaS/OAcEq
	 t4FgVKemFC63ILK2d2+x3ziSRnPon5rqygwqnWsYykNMbYCfXA3vuHZIffwkxlUDV9
	 pwdMbyga+1aeRRpPfcpsfVx53X0nsV0Bsdqe7ZnqwAy1dMFyulFIrWU48RCzUZ8/yc
	 8P9xYP82zUfmCs4Aa5JOTp+pIHexsWHvmiJP5gTgMIBnft6l6UQdYWh9kGhAd/i7c5
	 Q1evmUEzFjvYHaRvPXEJ0yDTbLUBhS1+X9GbUWUeMvghJ6vFUKs5QC7uRftQshwkMx
	 3ScGLeintdJ2A==
Message-ID: <1100e92c-0cc6-4e33-a7ea-68d93a417b95@kernel.org>
Date: Mon, 6 Oct 2025 11:07:26 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 7/9] scsi: Simplify nested if conditional in
 scsi_probe_lun()
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com, bvanassche@acm.org,
 hare@suse.de
References: <20251002192510.1922731-1-emilne@redhat.com>
 <20251002192510.1922731-8-emilne@redhat.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20251002192510.1922731-8-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/3/25 04:25, Ewan D. Milne wrote:
> Make code congruent with similar code in read_capacity_16()/read_capacity_10().
> 
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
