Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CAEA24A044;
	Mon, 13 Oct 2025 16:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760372728; cv=none; b=VF2QnL+G8vdT11bwwtc3CCn04UMc9RgTx/lYnmBazLfmUnCQkv7GEVuAYlGRvWHcM1ImNWdUI5jJJEenstiHSkd89BBJ/AytVps5UYy57ZdNV1lWKL2jeJ7HoqiUwwm08tOAB0vugEzjRHXeLluHMv7GMzrJoe9mPfq7wMusqpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760372728; c=relaxed/simple;
	bh=4ODZp9Ac3U4UBksEC4T2F1JAzzCTr67ebtzW/nICJ7Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VpeG1oxoMAkEPy06iCbT+t4438Dkncy/FzkYzd+X3lOSVYKl3no2wpyc9c41Sern8AYhIY0HxvIJ2YbYH7ytO7Hcy+7MIjKUh0QRstYsee5yAbv8JTv7r+vIWOryAOLzFkHReHIqnUXk48wsfUaqaHCsqDoqI4KRVUZXWALsKV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ILM36MU2; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ILM36MU2"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cljPd4RYWzm0yT2;
	Mon, 13 Oct 2025 16:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1760372723; x=1762964724; bh=XIAnYj3DsbpzMjwoJ0ze2gZX
	cXKKCVY1BDuyjjnWQmY=; b=ILM36MU2MgkgaHM9E0Gy42lzYVus9Lfc1vkB3nsk
	tZU53eixYjoUtk6uZS+2mvycAAsU9Ath1C2XiLpV5FY4qGqLoFoeazbHEWq8zntM
	J/Kk++KP/vHo5ZhvFEibVRplAHPJHGT5sp/c8lVeZQwIYYUtOD+SrkCoA0O+7/90
	NL5YKk86wNlu/xvBZShQeVD9tqDGwdZ1Wtl0bxsuyW2CtYoTleGM3CuU6fvP9dPg
	6ky4MCP/knppEnsNRBxmUEWRo4BK4VdUjzFUoYE1jX+D509OAfzKVybfEYVLSExf
	3aY22m5BfNh3MNtQiywFlgJBqtbZTUYMxKYRmM0g9QmgHg==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id kU_6DtTk9V3t; Mon, 13 Oct 2025 16:25:23 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cljPQ1R8Szm0yV5;
	Mon, 13 Oct 2025 16:25:13 +0000 (UTC)
Message-ID: <6a2068cc-1d4b-4a80-8a71-e491643a6c57@acm.org>
Date: Mon, 13 Oct 2025 09:25:12 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] *** Remove UFS_DEVICE_QUIRK_DELAY_AFTER_LPM quirk
 ***
To: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, quic_cang@quicinc.com,
 quic_nitirawa@quicinc.com, avri.altman@wdc.com, peter.wang@mediatek.com,
 adrian.hunter@intel.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 "open list:ARM/Mediatek SoC support:Keyword:mediatek"
 <linux-kernel@vger.kernel.org>,
 "moderated list:ARM/Mediatek SoC support:Keyword:mediatek"
 <linux-arm-kernel@lists.infradead.org>,
 "moderated list:ARM/Mediatek SoC support:Keyword:mediatek"
 <linux-mediatek@lists.infradead.org>
References: <cover.1760039554.git.quic_nguyenb@quicinc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <cover.1760039554.git.quic_nguyenb@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/9/25 1:10 PM, Bao D. Nguyen wrote:
> Multiple ufs device manufacturers request support for the
> UFS_DEVICE_QUIRK_DELAY_AFTER_LPM quirk in the Qualcomm's platform driver.
> After checking further with the major UFS manufacturers engineering teams
> such as Samsung, Kioxia, SK Hynix and Micron, all the manufacturers require
> this quirk. Since the quirk is needed by all the ufs device manufacturers,
> remove the quirk in the ufs core driver and implement a universal delay
> for all the ufs devices.
> 
> In addition to verifying with the public device's datasheets, the ufs
> device manufacturer's engineering teams confirmed the required vcc
> power-off time for the devices is a minimum of 1ms before vcc can be
> powered on again. The existing 5ms delay implemented in the ufs core
> driver seems too conservative, so replace the hard coded 5ms delay with a
> variable default to 5ms setting and allow the platform drivers
> to override this setting as needed to improve the system resume latency.

For both patches:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

