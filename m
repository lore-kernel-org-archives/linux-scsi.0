Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E5E1E86E
	for <linux-scsi@vger.kernel.org>; Mon,  6 Oct 2025 02:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759716246; cv=none; b=hu/7mPpWTGVye4C2z0NLn1RW0EDTBSrPJT5BFrwQceFpEFdE9NNRtIg2qc8CmBSTTVE0z12MhkyaZT2Q1kYOh0HDj+11Gjqrq0Dj9qLUpfRxfew+j+aRXgi1qzplAsueQupA+kaWR58XqwPMwQPdabbz5l2mzP4NCVDdhbxw/Mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759716246; c=relaxed/simple;
	bh=hXPKX4HzKPNFT/24KL/Xv3H6znprlJMRkcpFIKcKB88=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FzDPMqJPX23bmOx9/qPlPg/6uIoajc1l5UgiL9y+7n9gRtE4ahsW4MhF+y5cvQgaZjlFM0DBKMqngYIZZ88O50I+9let5fKqX+sQJ5V7HE82cznId7sAzj5RkwaVcgFfaYvzmyt2/sWdTTEfnT9Uxzckf8omx8DZ6UUppwc83eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tvUGrTwh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tvUGrTwh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0AF0C4CEF4;
	Mon,  6 Oct 2025 02:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759716246;
	bh=hXPKX4HzKPNFT/24KL/Xv3H6znprlJMRkcpFIKcKB88=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tvUGrTwh5J4wTbJUx/ihrRpqORk4GfcwwyKpKgwWFCs0NpxE4Yut91M99i9lHIHN/
	 mwfcIHmOzdhjFU+IVOCvwjDG2+q09W1xSDE0MtYcW4hTPE5HOhaNenr2CWJo7NSQfM
	 sFA0y/B3nkIFqG+800Ou4Id5zllcx6R3Sw9Pxh/e30yiv0ksUYhyaV3mRU50neOwit
	 +MF0AoCsTZNhsm2/NvgTFN+vqH11liJwqSUcohPb6p8/7UHCUFeAacVmN+bNIYxehn
	 Xn8G8ynWInzPYOJP8GOUmy/mG723PRNcupDc0AV3y5edHTgTQl4irpCo9l3x7cVZIe
	 BXXA4FCTUpJ0w==
Message-ID: <3913c013-f7ce-4b9e-afbf-92920c2a2044@kernel.org>
Date: Mon, 6 Oct 2025 11:04:04 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/9] scsi: sd: Remove checks for -EOVERFLOW in
 sd_read_capacity()
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com, bvanassche@acm.org,
 hare@suse.de
References: <20251002192510.1922731-1-emilne@redhat.com>
 <20251002192510.1922731-6-emilne@redhat.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20251002192510.1922731-6-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/3/25 04:25, Ewan D. Milne wrote:
> Remove checks for -EOVERFLOW in sd_read_capacity() because this value has not
> been returned to it since commit 72deb455b5ec ("block: remove CONFIG_LBDAF").
> 
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
