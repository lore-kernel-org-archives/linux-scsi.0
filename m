Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793028856;
	b=xroKzAbCIh8hzqe/wteK4I60VSY9IXS21q9Tyvu7Q1a0CIdnqZDuJcYkuzoCoi1ujh/j
	 2I0POUS7C29CE3xcfUYnOyR27OdJ+ICUuF9rfXy8I0BymTXEWW/lpXNVd+Wbcya9PWLha
	 CGQgv4virzdC/krpU0DVIpeIozxTkyvKSUaIJ92Q1y93R0N1ugM/+XwZ52+IcpQdcuZyd
	 hJZjh0WztbXDXop9r9pGqIXDMm2KZ7BQtuvdunGz2AFcSbnb/6HeCvQdwjdcdqs4MiR+N
	 aeO8w41aw/mGvci2FsqSprxNy03Sq7VUvD2hEc0zl5n7td549W9tgNGrlphCPO3fpJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793028856;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=N2M2ynz1TYTbyP0bcLVwndk5qgcK+iuezakI16B8/5M=;
	b=l45+dndvOOgO7PUzLThnQ5cGqXxO0lpK0p09R0UoD7fTgxdLIMA230hecoQNOHVHvldP
	 Ije2IHoKVvmHEDC5BX+FNS2ZXUd6BfEWQfCwfRONRCUv6yO5nhd6t5LrWF++P3lJGoPgS
	 pZxtagb1N0BH6C2CASueBiEBjWdPJgVVswQqcOAsxcDfYSLB2/kr9MVGR+Pk43mkpxGUt
	 pR1S9nzhlvw5Th8ld2Y0pjpPmameQ1zRcZz5yUEyfVcskp0rO6EslWr8oAVJtNR53D5Sy
	 qGes17geq5dLiT1iLGs/FUPPpGIQMe4gTswjYihHOvvhHt69v4Fe/qsD0azoPz+ZmBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=XTvnriEA;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A478C606A31D;
	Mon, 26 Oct 2026 15:34:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A478C606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=XTvnriEA
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4jCyN06wtMzlfvpc;
	Mon, 26 Oct 2026 15:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1793028845; x=1795620846; bh=N2M2ynz1TYTbyP0bcLVwndk5
	qgcK+iuezakI16B8/5M=; b=XTvnriEAS2EihqfB4LvyS9p3zH4Z0gmCa6imAX1w
	geyaXlZiiltMj/dC9TKJLEUAUg6iBA7VHYz7zWOCs80wqdUG0oN3xOJGFJajBpya
	U8tJVrF4ihNCEZht4KMu3b+Z96JiikxFHvi9to60QXa47ghrqvGYa57tisO+mAB0
	90h2jgPoeOYOgUt/kN9hpj/hs07+vEBRl4+TtyjGVMEsntLsn2fq1NH4eiLLC6N1
	/wiRMtv0cbaocn8NT4cN0tncNGCyh2rFjNV4I/vDE7W6oaDS8FlwxuMn5ZBHuRxZ
	Y9GESKEQIY5UwF/YhwRIeqGoNHQ77bjTNkKkrI0WWc/zCA==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id UGNZoz65PEB2; Mon, 26 Oct 2026 15:34:05 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4jCyMx2ZrrzlfvpT;
	Mon, 26 Oct 2026 15:34:05 +0000 (UTC)
Message-ID: <1d79dd9f-ef71-43f9-a02d-5d5138047fbc@acm.org>
Date: Mon, 26 Oct 2026 08:34:03 -0700
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
Subject: Re: [PATCH v4] scsi: ufs: Change the error check sequence for auto
 hibern8
To: Stanley Jhu <stanleyjhu@google.com>, HOYOUNG SEO <hy50.seo@samsung.com>
Cc: "Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, alim.akhtar@samsung.com,
 kwangwon.min@samsung.com, kwmad.kim@samsung.com, cpgs@samsung.com,
 h10.kim@samsung.com
References: <CGME20261026053046epcas2p31ae8a493f40c0f12523feec6e036072f@epcas2p3.samsung.com>
 <20261026052632.1848929-1-hy50.seo@samsung.com>
 <18e21b71f8996bcc.3137322e31362e3131332e313435.1c875f.0000sendgmr@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <18e21b71f8996bcc.3137322e31362e3131332e313435.1c875f.0000sendgmr@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable


On 10/26/26 7:42 AM, Stanley Jhu wrote:
> On Mon, Oct 26, 2026 at 02:26:32PM +0900, HOYOUNG SEO wrote:
>> v2: https://lore.kernel.org/linux-scsi/20261022074249.3098100-1-=20
>> hy50.seo@samsung.com/
>=20
>> Signed-off-by: HOYOUNG SEO <hy50.seo@samsung.com>
>> ---
>=20
> Please move it above "---".
>=20
>> +=C2=A0=C2=A0=C2=A0 if (ufshcd_is_auto_hibern8_error(hba, intr_status)=
) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hba->errors |=3D (UFSHCD_U=
IC_HIBERN8_MASK & intr_status);
>> +
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cmd =3D hba->active_uic_cmd;
>=20
> This brace is never closed, so ufshcd.c does not build.

Hi Hoyoung,

Stanley's comments need to be addressed: please compile-test v5 and move
the Signed-off-by above "---". Additionally, please consider using a
local bool for the ufshcd_is_auto_hibern8_error() result instead of
testing hba->errors, describe the actual changes in the changelog, link
to all previous versions and Cc stable. With these addressed the
approach looks good to me.

Thanks,

Bart.
