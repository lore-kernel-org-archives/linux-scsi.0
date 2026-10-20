Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792527387;
	b=gK1T/6zMw/3tzKpKXO8iF0n5EMwMzzkhqqNkhiPex16qob/YIn9fBXRaqlSIblYPMQGl
	 rzvrXHSs/3MddqdrQIwI1sCY6gk7g6q1NttLg9cy1Sq/n1Witpfb3DVBTyaYW1BbagIcp
	 SX9TrKGZX4PaWImZDIqyGW9mIDvq0qrMQdSgyd+0Lmwbn5IflosLMFcdtPafp5eKlWaD2
	 iar+wivUn3oLXHU6Y1aM0cXdcCK17k22GPq6p75vulyrKMEz6x+zogoPgzU/57MSE1buu
	 e3AOgjXXvun53L0GZhe+CdRd9ybQSEc/Pf69ep/W0RhJN4rXP+Ev+GZ1GptO8H9K6Cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792527387;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=dHXCMZxbmZBp3LZs3JAEzMx2van/657Vf/vx+nmCHDw=;
	b=4bX1yJc5vnwV1J7d1wBkgRjBo7dtIMAG66YSYW1L1UVVyCx4o0tJ5dZYTj+GtBWMAG/C
	 wOu/JjVhxVzvf1C36SHTKZI36xSy2CdsqVlKykRsR35UB2wBD42AbqoltAAoUryeyP2yp
	 uKqLVC6Dp0MlBF4n5H9UG7Td0jzCVmR6VqiMtRsrfldoSO2PUHxbWFPy8KdNEZDNTl61U
	 AeAqzoPSqr8TP6jQR0LuuvlXsevL0I1ydNWS0j4tcqYy1ybB4gDW4pKcgLpd5RJkWfvFn
	 BU7YZK/2WJ/ZdNj6JEJZtq+twYYCecnhDoeXkASklcHuJI8oFof5MxzNpS1fbo3Qwbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b="stA/Z/0R";
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1331D606A320;
	Tue, 20 Oct 2026 20:16:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1331D606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=stA/Z/0R
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4j8NwV2xGWz1XM4Tn;
	Tue, 20 Oct 2026 20:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1792527382; x=1795119383; bh=dHXCMZxbmZBp3LZs3JAEzMx2
	van/657Vf/vx+nmCHDw=; b=stA/Z/0RymJ2jtWL4LUXUX5z+oQ5LvcSYryvbJ/7
	pc9NWVi8F+X0ebIw+kH3Rw+m3Ss4Hi6MMUpKGi4/FwMx+tDfog/0ffMh+Woo5Bhq
	Fd9uu/WzJpzFLWL2xiwjAJr+K12J4uix5fzR6OHSyp86tmrXwtjHsszH/pJxMhhN
	n5smGxRA3G8dOZJ8tzo2W9mUpdhXpgquJ/SenA2taHFMpUYRespmlRa+SafWJcyu
	Nui8u2L8bxe6k45Fdt5xvp3D28GkPlzLM/IluDmz5oQi1aNHNAQTh6UMSozwwcBU
	BMhxaPcR+1DGObqmi9dOmTYHi8YOCY6TN+rqXwMKLSeCzw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id FDsGoPmVIBWK; Tue, 20 Oct 2026 20:16:22 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4j8NwP0Lyqz1XM4Tl;
	Tue, 20 Oct 2026 20:16:20 +0000 (UTC)
Message-ID: <b43f6355-2d02-4957-af64-1d9e4238090d@acm.org>
Date: Tue, 20 Oct 2026 13:16:18 -0700
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 7/7] scsi: ufs: core: Do not release a reserved request
 in ufshcd_abort()
To: Stanley Jhu <stanleyjhu@google.com>, "Martin K . Petersen"
 <mkp@kernel.org>, linux-scsi@vger.kernel.org
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Bean Huo <beanhuo@micron.com>,
 Peter Wang <peter.wang@mediatek.com>, Can Guo <can.guo@oss.qualcomm.com>,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261020082110.3511797-1-stanleyjhu@google.com>
 <20261020082110.3511797-8-stanleyjhu@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261020082110.3511797-8-stanleyjhu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/20/26 1:21 AM, Stanley Jhu wrote:
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index ee898f4a5bb1..5d1a9b4e9b8d 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -8228,7 +8228,8 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>   	 * Clear the corresponding bit from outstanding_reqs since the command
>   	 * has been aborted successfully.
>   	 */
> -	if (ufshcd_clear_outstanding_reqs(hba, BIT(tag)))
> +	if (ufshcd_clear_outstanding_reqs(hba, BIT(tag)) &&
> +	    ufshcd_is_scsi_cmd(cmd))
>   		ufshcd_release_scsi_cmd(hba, cmd);
>   
>   	err = SUCCESS;

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
