Received: from mta-03.yadro.com (mta-03.yadro.com [89.207.88.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72AA822F166;
	Wed, 15 Jan 2025 07:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.207.88.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736926587; cv=none; b=cZVtYs2ZF4t/E0bmeySbshSqSYjM8LU9ci04tHaLKwhc3x1hVW4oxY/Gzt+9JyexH1Dxn65RjvzBjCsoMMKCWlY1wbHzm0nO87AGo/fJP90OTC8vaSlk0zStliqcOs23t9mijha9LEx+qiV1XNht1aDDxY5xFt2ki9ycuz8wU9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736926587; c=relaxed/simple;
	bh=i+Lr0l6u7knbE2lN3MK6vmkaz+cKHINY/Jfu/pdkK64=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r/kH1zOcGPyze2gUVkUpLa2v8vnDeI9vH/Bn0bx4yoqskgV+rabYHIARxTRcDyFeeEo0elykQPbpaMzgfmF9HE9787oIAuee8gkjCUXZ3T1sGYg9tyiu1SWRN9mff8rRVLpHbRP/7Py/+gHllGrksFqzfWC57kTePbz3AhLgQwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com; spf=pass smtp.mailfrom=yadro.com; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=L5rKqhF0; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=g5wo/hqi; arc=none smtp.client-ip=89.207.88.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="L5rKqhF0";
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="g5wo/hqi"
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-03.yadro.com 9E18DE0003
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-04;
	t=1736926573; bh=F4jfK3BzhDlQR4ssxeKb7chAJyn8i/ZZwlISiS7quGc=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:From;
	b=L5rKqhF0VjBXUwVBWo7Jr9dRWw11897tiu4XoXO9QnnQ3kJdZ5oOMyHd5snd288CG
	 f8C5Uue8MQjUA/pVJ8CmwIXn7Gx2ykhisJlZvVbRmz9vkngAw2pyb15gM3xX/+didn
	 5jLzQRLti35GgAEP5xyHBqki/1ge38PRgP2paAPvM9uwi/u9UvJW8lO6yM/YRxi9JJ
	 uS4ILMs21vsq1rVe267vrR1JpvfLjUvd54w9LmEVWzAlBrBb2j8CUu8/Fps0hIOl9w
	 fc58BYDqevPzkTPCOioONhUshbwPWd6OAjx+vNKtABuvm3pr3EmoVc1LCwGCHhUIP1
	 NUI/zLdcz9p8Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1736926573; bh=F4jfK3BzhDlQR4ssxeKb7chAJyn8i/ZZwlISiS7quGc=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:From;
	b=g5wo/hqiV1UZNiZu2RF40kVpv08cxaTkNlj4oMEzIOwumAjtuCB3Sa8gG152HmaFO
	 rGPMaLL7SRrfYvO6HKHHRdVfU3aS+BLYlL6kw/oEwxtdbjq/u8c7BBL885V1ZOomeM
	 pGPk6Odv1U7QhsTL5+if4D87pu3iSGnBn/CumaapD7TSRP7Xh0nSfq1vG3V/w4YjnL
	 13mHcgfcSliXZLDYE3Mx8p6uEfGmYGKWalYZ4pF7aZKqtNoI5d0Hlb+6b9MShtPGOd
	 ccKJmw2cOrpPeBamSVTscFcAdwtK/M3EMzU/eBsGXiX18SPBa6GmKUfPDedgaPOgyk
	 qyZLzfc1zdBXw==
Date: Wed, 15 Jan 2025 10:36:08 +0300
From: Dmitry Bogdanov <d.bogdanov@yadro.com>
To: Chaohai Chen <wdhh66@163.com>
CC: <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
	<target-devel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] target: fix All_commands parameter data header size
Message-ID: <20250115073608.GA17942@yadro.com>
References: <20250115070739.216154-1-wdhh66@163.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250115070739.216154-1-wdhh66@163.com>
X-ClientProxiedBy: T-Exch-05.corp.yadro.com (172.17.10.109) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)

On Wed, Jan 15, 2025 at 03:07:39PM +0800, Chaohai Chen wrote:
> The SPC document states that "The COMMAND DATA LENGTH field indicates the
> length in bytes of the command descriptor list".
> 
> The length should be subtracted by 4 to represent
> the length of the description list, not 3
> 
> Signed-off-by: Chaohai Chen <wdhh66@163.com>
> ---
>  drivers/target/target_core_spc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
> index ea14a3835681..61c065702350 100644
> --- a/drivers/target/target_core_spc.c
> +++ b/drivers/target/target_core_spc.c
> @@ -2243,7 +2243,7 @@ spc_emulate_report_supp_op_codes(struct se_cmd *cmd)
>                         response_length += spc_rsoc_encode_command_descriptor(
>                                         &buf[response_length], rctd, descr);
>                 }
> -               put_unaligned_be32(response_length - 3, buf);
> +               put_unaligned_be32(response_length - 4, buf);
>         } else {
>                 response_length = spc_rsoc_encode_one_command_descriptor(
>                                 &buf[response_length], rctd, descr,
> --
> 2.34.1
> 

Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com> 
