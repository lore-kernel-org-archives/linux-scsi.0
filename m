Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E7D1754B;
	Tue, 20 May 2025 20:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747772065; cv=none; b=lcjCnxftDwgbz5uh59zN3ddtV2WG4zLJSCnsLn3ya4OYgA93Sj6Gbsm3u50tU7lhOOlrI3HubWdyVbGlwPSi+ZR3L7DDuEAIA7aDiHgMJrEo/kFkYWqIGs0YayHnpTJtN/Vag1O8hJmeXVVPkSwQybxC05SW/0jGLDAuUr3U20A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747772065; c=relaxed/simple;
	bh=5dJAVSZSlBpMGuNH99KaZBAJ1akl81nByLTUzZkeIU8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gY/yAXuF2V1iPoYftC30wJ+0aW/6Yy4e3iqONyrdvb7nl7OrhYSNJ2ObmfnM+NVdrnQtkw3DVxPantV9Z5RiP+im/YmGcCVBBiAiJNk6DDgMgT8Dt31sClVVc3dHIw6iEwmrDYXaWqGeGNLl1ZJYMyb/IFcXKNkBy0pVDL3J1h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=JilRvis5; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="JilRvis5"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4b25P35f1Lzm0yTm;
	Tue, 20 May 2025 20:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1747772052; x=1750364053; bh=cOpxo2nrCrAcfyxVcWSqYGBP
	oXDE0PWkTANOWymUEsg=; b=JilRvis5bHi/wZFe2m8v0w2+PC7/6DB4obj17Kof
	eHJhkGNfePOL3SeEPkt4wCM3egj8x/cenAPWf0pr6swtLJyfDo3ZylN4Q8VKyqcz
	u42nRNvgUTz9akwxiX9Zorv5vULTWgoO0GpxQxXzE6c7Y7JPOMEu2Go2nLow3BVG
	kxhNESxlZtGuHv5U3uj7TV01T3AyqFniJ30vueHTk40xnJ0ih3p5LPzA4z5vddMl
	OA80G3ECafKEgK10bCOb2UOdbxmV0dU54ksPzkyMwez+WlubKxpi4DF9reHIGAXe
	IywTpbcFGcI3oTBqnCHJJ12fV5W9vYLyOo+qZxrFgxRfIQ==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 1yHhljgweE0s; Tue, 20 May 2025 20:14:12 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4b25Nm3Ftpzm0ySm;
	Tue, 20 May 2025 20:13:59 +0000 (UTC)
Message-ID: <3ba29109-86d8-4bc1-8f2f-49fa2e56673e@acm.org>
Date: Tue, 20 May 2025 13:13:57 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] ufs: core: Add HID support
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
 "tanghuan@vivo.com" <tanghuan@vivo.com>,
 "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 "manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
 "luhongfei@vivo.com" <luhongfei@vivo.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "opensource.kernel@vivo.com" <opensource.kernel@vivo.com>,
 "wenxing.cheng@vivo.com" <wenxing.cheng@vivo.com>
References: <20250520094054.313-1-tanghuan@vivo.com>
 <ab468bb26dafca673d7ffca7dff519b7cf024cdc.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ab468bb26dafca673d7ffca7dff519b7cf024cdc.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 5/20/25 6:14 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> On Tue, 2025-05-20 at 17:40 +0800, Huan Tang wrote:
>> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
>> index 3e2097e65964..8ccd923a5761 100644
>> --- a/drivers/ufs/core/ufshcd.c
>> +++ b/drivers/ufs/core/ufshcd.c
>> @@ -8390,6 +8390,10 @@ static int ufs_get_device_desc(struct ufs_hba
>> *hba)
>>=20
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev_info->rtt_cap =3D desc_=
buf[DEVICE_DESC_PARAM_RTT_CAP];
>>=20
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev_info->hid_sup =3D get_unalig=
ned_be32(desc_buf +
>> +                             =20
>> DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP) &
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 UFS_DEV_HID_SUPPORT;
>> +
>>=20
>=20
> Could add the double negation (!!) ensures the value is exactly 0 or 1.
> dev_info->hid_sup =3D !!(get_unaligned_be32(desc_buf +
>              DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP) &
>              UFS_DEV_HID_SUPPORT);

Hi Peter,

I do not agree that this change is required. ufs_dev_info.hid_sup has=20
type bool and hence the compiler will convert the result of the binary
and operation implicitly into a boolean value (0/1). From the C23
standard: "When any scalar value is converted to bool, the result is
false if the value is a zero (for arithmetic types), null (for pointer
types), or the scalar has type nullptr_t; otherwise, the result is
true."

A double negation does not occur elsewhere in the kernel if an integer
value is assigned to a boolean variable so I think that it shouldn't be
added here either.

Bart.
