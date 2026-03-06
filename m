Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7242E2FD1B6;
	Fri,  6 Mar 2026 02:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772763550; cv=none; b=GC0vGlx+tO8wBks80zjn2T82X9L6N/WLecoeVoVR7w210KdwDCgE2r6SBlNqqMyUuVH1CDkYwBAc8m8v2GaPTK4T/+Iyr7qVRlm+gZCWfhOe86hyevnT81yH3bDOgO8FXnLAoYSulDuUqEx8waD6brSqwkHDksj9InkCz33504Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772763550; c=relaxed/simple;
	bh=QQzhNc04McOCTp4ZWH0zZtCOyhhtw3rBPEi5ryyYZDs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SW+pCDbjS0yea4cL925nEWOTcQw1V6QltqUcRu5nv216wqjahf1S0wCP9oyM3XW11TdOP+WahZZ+S+b2goyR4ICj4fr8g6nzzL+MlgBM/+7NWGtNz5Xc89JBS+o89EULjG90IkwJwHUqTK89FmUODxo6KExhBCjW4hQMy31F2ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=JVocAbDc; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="JVocAbDc"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fRqkq3gjdz1XLyhj;
	Fri,  6 Mar 2026 02:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1772763341; x=1775355342; bh=QQzhNc04McOCTp4ZWH0zZtCO
	yhhtw3rBPEi5ryyYZDs=; b=JVocAbDcPCawaLdZUbGJ/JA5LZXFqCklWhrTCayZ
	+PFOMpYsRetddtYRypn1ESePaMZTi6OD+Z1i7/xXGEzOBZxYwfWsAmsaj5CGwgRY
	xhnTN37ra7EojpmRd5/rhEXtFSSIqw35jTrvhFtZwHIXmhf5MvhYZqldLW45B6n5
	/ommnXVv+teANBYAKlJh79scM91RgXGVAwuNegFiAuoIhfJMD02uTPocuOAsDvqe
	Msoqjo8A7nHcIu1CM4UAaSM4Dmd+LzYxgOxCc/yUe8a+BJO50HArwpMuVl5a/OZN
	q3/Aiwori8z5C7rpzcHsEk3C5syk0Uc+rfUfqSGQEjF0BQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id XSnpNyjx8kaO; Fri,  6 Mar 2026 02:15:41 +0000 (UTC)
Received: from [192.168.132.187] (unknown [12.150.89.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fRqkf112nz1XLyhh;
	Fri,  6 Mar 2026 02:15:37 +0000 (UTC)
Message-ID: <0c793e57-ee29-4322-8cf9-0a4a859b9981@acm.org>
Date: Thu, 5 Mar 2026 20:15:36 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] ufs: core: Add quriks for VCC ramp-up delay
To: =?UTF-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
 =?UTF-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= <Chun-hung.Wu@mediatek.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
References: <20260305083610.2672344-1-ed.tsai@mediatek.com>
 <20260305083610.2672344-2-ed.tsai@mediatek.com>
 <fd1fb573-6d02-433e-a74a-1a015c64e3be@acm.org>
 <0e812b2b96603f69467b57ae6e9836ef8b4bd1ff.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <0e812b2b96603f69467b57ae6e9836ef8b4bd1ff.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 3/5/26 6:19 PM, Ed Tsai (=E8=94=A1=E5=AE=97=E8=BB=92) wrote:
> On Thu, 2026-03-05 at 06:24 -0600, Bart Van Assche wrote:
>> On 3/5/26 2:29 AM, ed.tsai@mediatek.com=C2=A0wrote:
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 /*
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * On platforms with a slow VCC ramp-u=
p, a delay is needed
>>> after
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * turning on VCC to ensure the voltag=
e is stable before the
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * reference clock is enabled.
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 if (hba->quirks & UFSHCD_QUIRK_VCC_ON_DELAY=
 && !ret && vcc_on
>>> &&
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hba->vreg_info.vcc =
&& !hba->vreg_info.vcc->always_on)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 usleep_range(1000, 1100);
>>
>> Since the value of the delay is platform-dependent, has it been
>> considered to introduce a new vendor operation (vop)?
>
> A vop does feel a bit heavyweight for a simple sleep. How about we add
> a new configurable variable, similar to the approach used for the VCC
> off delay?

Let's postpone introducing such a configuration variable until there is
a real need for such a configuration variable.

Bart.
