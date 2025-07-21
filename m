Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A8C2DF3F8
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jul 2025 15:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753112703; cv=none; b=OSwC9FI/VXNIi5qceFhn43kzR29hBnsius+H1q1TzyGV1bY9Jef8v5wtz7tTVx4b/Y87ttWnDXWpG+ZpwZTZR0elzFt08BSShZCO4eH5j90Bt+2qZkgFiCelVNFhCOMBo9erFGuMOBDXX7UuUVzFuClSZ86s9FPwQnjGosWjUqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753112703; c=relaxed/simple;
	bh=cV0TLLVrWh45H8GiwU0Tx4lO+8zwZFzO8jqWulbiDMY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H/mDW0ca7yjg3+zv52vpF1mv2jKiOue42gz9bwRdjXQf30u/0ePUFopmmOxduW0g5A0bKnjzhpKzDsxXZTuZxeKN+LCH6grnatCwKuy7cAq7wjIPJhEFDRg3IGN65Rp9wOI8IApYfO0XwX6A8NokkhSevkBzxyQZQkHA1oDg4jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=h72Wp3dM; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="h72Wp3dM"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bm4Tl4Y8rzm174y;
	Mon, 21 Jul 2025 15:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1753112696; x=1755704697; bh=cV0TLLVrWh45H8GiwU0Tx4lO
	+8zwZFzO8jqWulbiDMY=; b=h72Wp3dMd8e7wXvYPGUvnwKgwmgEZjvFnWkJ/SYW
	n6WVtCCc68+6wSifCQgbUVfYd6DNBtLSTL99m9lFT+H2HJpPkmExzgHutgsm1cL3
	06H1ekyq1DGitoOWulaEkXQYjmVWUMgDZPygTfRFhl4Uq5jflmK1NGE0RVH1Vux1
	Qm1Owq+sZxHLxsGkVXR2DJQyaLgHUnwy8/O6GPMwwhCGT1X6cwa+9uTSgNrMHIpn
	zRG0SDnEWOuPY8rvR3gcuICcVp8VLuUAEC/Rn0UcN/xzP7J7kRsl4L0L/e46Hkcd
	rNm+2uOIp9nCK8FwtJXimOTL29yYCjCEx1jRlDe0Az25bQ==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id l6NqqqM_3-5p; Mon, 21 Jul 2025 15:44:56 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bm4TQ3Nqlzm0ySj;
	Mon, 21 Jul 2025 15:44:41 +0000 (UTC)
Message-ID: <37ef75af-70a4-4030-9bf7-0bae0f53f7d9@acm.org>
Date: Mon, 21 Jul 2025 08:44:40 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/9] ufs: host: mediatek: Remove unnecessary boolean
 conversion and parentheses
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com,
 yi-fan.peng@mediatek.com, qilin.tan@mediatek.com, lin.gui@mediatek.com,
 tun-yu.yu@mediatek.com, eddie.huang@mediatek.com, naomi.chu@mediatek.com,
 ed.tsai@mediatek.com
References: <20250721083626.1801668-1-peter.wang@mediatek.com>
 <20250721083626.1801668-2-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250721083626.1801668-2-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/21/25 1:35 AM, peter.wang@mediatek.com wrote:
> The changes
> simplify the code by directly returning the result of bitwise operations
> without converting them to boolean values or using extra parentheses.

The code changes look good to me but the description of this patch does
not. The conversion from unsigned int to boolean still happens with
this patch applied. This patch converts an explicit conversion into an
implicit conversion.

Thanks,

Bart.
