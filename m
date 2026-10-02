Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58653876B3;
	Fri,  2 Oct 2026 13:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790947934; cv=none; b=M6yAwfFkXoCohtB2NXOztO9dPIWja7H7TJGBiCAHhyDZKReeU2G2hRgutXoejVrC1XIMGgVOdvK5+etyZdYulwOPFg+U5SLtDvvOu6X7AUPznEVSZhMkFr/eUSRt+ZXk68mQuMExt1Ty5EMAjNsRxa7hAc5Wy0LMjcUziW6DRa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790947934; c=relaxed/simple;
	bh=Sfgq4J4qmWTTb9yeLxUfDNuD9UH88svUye3bqI21IR0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=epY8U0q8zTU+NBn5NL03tn5ln1x7eaFG95fAnez8lz5OGqyXlrGCaPF+ZSF/DOGcoW29Ghw6nPianRlzCGKTnGPbBCtLog2Z+PpDnqA2OsIyiEFDC6ewxtE0k3GUm/FchAVbj2nqfcYgzV2BgeBhRNGWZcUfS2u0zBG+uuaiZj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=jPE8nfjX; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="jPE8nfjX"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hx8pG0SL7z1XM6Jf;
	Fri,  2 Oct 2026 13:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1790947922; x=1793539923; bh=Sfgq4J4qmWTTb9yeLxUfDNuD
	9UH88svUye3bqI21IR0=; b=jPE8nfjXLtMbvt8PnSV8T2T8Dghv+6SMuWovNnwu
	I9im8qn6TUQKGoJWFUQQbC1DR+US2zeNdd5fEpQ0zIsM04JpG9+w7s/7Bf8R7/0s
	pWRMdH2QV01n5/JK6nj5fO+dTff9Pq2scaeBle5jlsTlLwHMVueahi9kA8oXUoVq
	uHeUP6M2N4BYphN0fvsJ93gY8etTEBrIVr124H7K33NwUzPSdCP2Lt1xn9Dyz2IC
	dzSYHjcjjGmlqMFxVevnbJrNtHWKDeyd/n0612OsiWrehG0vBD2BRR/xbOrwnhU5
	lLXlRinMAjuEWUE4dcgYezxBK+pHv+iS37kANf/PG+yQHg==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id qXHkVSQjcEHf; Fri,  2 Oct 2026 13:32:02 +0000 (UTC)
Received: from [192.168.0.215] (c-24-6-239-25.hsd1.ca.comcast.net [24.6.239.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hx8p83vcpz1XM6Hv;
	Fri,  2 Oct 2026 13:31:59 +0000 (UTC)
Message-ID: <2fbff86c-f276-4e46-b7d3-549461706d37@acm.org>
Date: Fri, 2 Oct 2026 06:31:58 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: Remove Avri Altman as UFS reviewer
To: Stanley Jhu <stanleyjhu@google.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Avri Altman <avri.altman@sandisk.com>,
 Alim Akhtar <alim.akhtar@samsung.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260930135947.2339918-1-stanleyjhu@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260930135947.2339918-1-stanleyjhu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/30/26 6:59 AM, Stanley Jhu wrote:
> At Avri's request, remove him as a reviewer of the UFS host
> controller driver. The listed wdc.com address also bounces.
Did Avri request this? I haven't seen his request. Did I perhaps
miss something?

Thanks,

Bart.
