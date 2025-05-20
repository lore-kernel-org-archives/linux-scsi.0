Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3BFF24BBFA;
	Tue, 20 May 2025 20:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747772545; cv=none; b=E2vpf85YokM8/PNpoMeccfRvaazvGHha3TMdr8DjKRVZGgVuE/KOezh2S+5x9AEMt910s72vRu7Y19/wDTaJRZ9pNifWw8Pki/+a16neRnj4aVb74cNtJlf8zgaRksOLCE0KXwin5uKsvDeJ/reOmgdQ/huz+EJOjCQWy7Jcpds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747772545; c=relaxed/simple;
	bh=nBIz2YBhpcCG6sMnziTwhK5Dqq9fn+f5ySbYnL3wGz4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U7pf2XzfhTZY/r8lachtFRyCqj4dcsbKXPkDraSqmyMItei85KQQl8vht5ggB0aWmpIk2/eMcf20DCUAl8a9To06OJuFrcdyaIpEloyS1ZfslROTGjdaiu95u3fYBfwJuif187XxPnyLqgvv5x3aGrZX2JSGNPIqj76LxFzGRSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=pBIR+Zvh; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="pBIR+Zvh"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4b25ZQ3hKWzm0yVW;
	Tue, 20 May 2025 20:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1747772539; x=1750364540; bh=VsWblo70W25KLjzab3RDQK4+
	FjMs+JwITco0BGNeUJc=; b=pBIR+Zvh4Q7rLh9RZvGG64FHSWIbR18L0w0sCyiM
	btVI41klJaHxTtmoaFZ6deEOiM4BBh/9lMca/kD4klUMO1jrxUUspO1xf7FKxWOZ
	7BiZxUpK1YolQgYDd47Xpo61TBOTzc0Rb/J9WhyCu+9ht7x0VrOc8lpQUE6iSCqi
	I1xit/mlup5HSQCdSWhXFffbAt+mIoI8CYgvHAuerAuMSh2yNU/GjK27St8Sqpz3
	U1ZS/0A6QluC4E3gwz+7+hVgZbJUcPQHefRU8Jr1aq8pg24Cwx6LDqk+KIVH5YvT
	f/1Bxnb9oiW3DoqWwusNrFo267n5iMO2RbE9FC+PSzvzbg==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id g1LDX6Kg9hux; Tue, 20 May 2025 20:22:19 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4b25Z71qClzm0pKq;
	Tue, 20 May 2025 20:22:05 +0000 (UTC)
Message-ID: <b0ec5b8a-b303-4e5b-bca9-4524eba9fa31@acm.org>
Date: Tue, 20 May 2025 13:22:05 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] ufs: core: Add HID support
To: Bean Huo <huobean@gmail.com>, Huan Tang <tanghuan@vivo.com>,
 alim.akhtar@samsung.com, avri.altman@wdc.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 matthias.bgg@gmail.com, angelogioacchino.delregno@collabora.com,
 peter.wang@mediatek.com, manivannan.sadhasivam@linaro.org,
 quic_nguyenb@quicinc.com, luhongfei@vivo.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org
Cc: opensource.kernel@vivo.com, Wenxing Cheng <wenxing.cheng@vivo.com>
References: <20250520094054.313-1-tanghuan@vivo.com>
 <32c36b58dcdbb09403fa9dccff28b6bee76882e0.camel@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <32c36b58dcdbb09403fa9dccff28b6bee76882e0.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 5/20/25 9:01 AM, Bean Huo wrote:
> On Tue, 2025-05-20 at 17:40 +0800, Huan Tang wrote:
>> @@ -87,6 +87,26 @@ static const char *ufs_wb_resize_status_to_string(e=
num wb_resize_status status)
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
>>  =C2=A0}
>>  =20
>> +static const char *ufs_hid_state_to_string(enum ufs_hid_state state)
>> +{
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0switch (state) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case HID_IDLE:
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0return "idle";
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case ANALYSIS_IN_PROGRESS:
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0return "analysis_in_progress";
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case DEFRAG_REQUIRED:
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0return "defrag_required";
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case DEFRAG_IN_PROGRESS:
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0return "defrag_in_progress";
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case DEFRAG_COMPLETED:
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0return "defrag_completed";
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case DEFRAG_NOT_REQUIRED:
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0return "defrag_not_required";
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0default:
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0return "unknown";
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
>> +}
>=20
> The enum ufs_hid_state values are contiguous and start from 0, maybe ch=
ange switch-state to :
>=20
> #define NUM_UFS_HID_STATES 6
> static const char *ufs_hid_states[NUM_UFS_HID_STATES] =3D {
>      "idle",
>      "analysis_in_progress",
>      "defrag_required",
>      "defrag_in_progress",
>      "defrag_completed",
>      "defrag_not_required"
> };

If this change is made, please use the designated initializer syntax
([label] =3D "text"). This will make it easier to verify that the
enumeration labels and the strings match.

Thanks,

Bart.
