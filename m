Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793785402;
	b=KUOHvnHlaQVnFqLUCtTsGA20TqNmpp+lxTX7bk4A70M9720SZrMecLzCm7VeV04txkcO
	 Z4wyVWPzWIWvWjJXHtl0oBMgXkOtbQ2JbybHRbq94vKQ25AzwmVS3IYA0IyNn1cLopfI1
	 45qafCHdu8HP6y5ZlYzuIz2Hmi8SOrCmckSAjmrDUDH4Bz9fYiFA6TbWxoiuYi8D1x7F2
	 5buG6CT2xs0LV/t3WVAxSxYi6DNtzgkGl8QWE/IwPnHDxyj2s1jQlQUALT1xbI3oO8/9o
	 XJdsP4RY9v+7Yc0ger3/UsOGbXn2Z5cbsP4WIgTD2XWwroT+0P7j09wLRXx6fwULtnQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793785402;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=QiBV51YSsvAhVbkuD5G3dwy2wbYhE77P1hdgw6UX+wY=;
	b=sJGXfSGzT5rGO9+ln31vn+vZTJuHalnMERWrxlQMHsJmoPNYQ0CDrKEeT6qAMb/Vo6PO
	 eut1ym26Lfyy23dKhoOR15CKkJaOEA7sc2iOEKwInnGwhCys3v5JkncxrP92FIsYnqJfl
	 qtOU34vyMi8rBAi2RNlPUg6AZY68Vm8qc04YvnXrjunDpAAZ3mFLJg0s1sPDrn+dq2GVc
	 8s098EdlcZ/FvGR1Wl6KP+pEEMbtc7BFa9JYWYxvucvqblk6PmLP9p67wBfp6e4oN8tmu
	 VKWLFSAeXFfr0J9gXPldlYTxwWAJzUQdUOxEjCBlQFAvAIvLGcBNPqhhVY9XxgTuC2Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cloud.ionos.com;
	spf=pass smtp.mailfrom=ionos.com;
	dkim=pass header.d=cloud.ionos.com header.i=@cloud.ionos.com header.a=rsa-sha256 header.s=google header.b=dsixcZ1v;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.54
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E94D606D805
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 09:43:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5E94D606D805
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.a=rsa-sha256 header.s=google header.b=dsixcZ1v
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c411b7a2710so8704966b.3
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2026 01:43:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793785400; cv=none;
        d=google.com; s=arc-20260327;
        b=aVqQgSXsRO+XYDFadMnf1AkK+xpxYhpU4+qd61U0Nfmpl197Lh0WRst5oSZawVtzEL
         cxGe2YJe4cPNTwjjtIvLk49myuNhYuWtyK9mKOKclOfk4ZifZbHOke1bnrhik4XWqIo8
         +GgvzTyzZR4I7wStTMyL9auMzerp3RUWo7pxP9yc9ZNs7a7LEmrmtxCs9FmanKNXu0F2
         LcwY47CB8Z5H6hed8xQqjcMXgt4Q01GIsHKuPd7XBI7ETK59KE2ZetrL8EsNVPdaxOvA
         Cj4czLKDn0Gr1HigGskpDLBB6fT1/MRamf39LotDJ+j3Y+bHT6UgL+62FvjoGn5S59qI
         UETA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QiBV51YSsvAhVbkuD5G3dwy2wbYhE77P1hdgw6UX+wY=;
        fh=mt4aJNvQjwPh/lY12GVGsmjznPTk12t7igeAGpd/lyI=;
        b=pdH3KmxpSdzJkZ07glsvcZCnJiaxzTdHBX7b1RSUqkWQ4YC8uz2j1aLfOMVyBB8mhe
         /0Xe6fkUYit2WJ3sK4UuWKB+iNNFB817qx5lkV/XivD9GbWE2u2uMiznctVr2lexnMme
         8bz38LzXAdDXTqyBVUQ4bmGjvSSoYmGvOtz9jCuMFrt9olVRrSgN6+cbdGHFkCH4Eu7+
         EEuZdwxp7pjqGTo/Giiw/HtDpMtfq0htj9jLaFUJ+UJyYbYvR1CdO3Luy2yEsoN9zAak
         DyniXDRygFqFlvqPZ68XKzP6+pxM/o++ci1XPzbQUwjtvBy0r+nIacwWyqAjAO82XiIp
         hkBw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google; t=1793785400; x=1794390200; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QiBV51YSsvAhVbkuD5G3dwy2wbYhE77P1hdgw6UX+wY=;
        b=dsixcZ1vkB9iD8z8soG/VDexrD7EqOEe9fCxrDv+eB4rXsY/GfaX8OjFMNBWmin/RP
         7TJtiRDJDeXLtyBfmIu+nsxpwtZPeadxAZtmMOUOAINd+95eRSmkn2LwR7uK3tzFnR1D
         RkPv22G441RYpBEFaSn7Cd/uGV/DXNygrl7URm+hGWpedUCeyM9FCMbPHbDF3kwbR3WB
         EDG/c5BK2Yea8/qInNrXu8mXWwpxiHXaG5XpTMS/+aCV7ihei9YQuL/y36gWKIiOGPjV
         jT163fOj7cr3CxM2RiYT/Yu4WwxpQSe9eNv4R7/9R5PawjsVu0Zlw4QUu0GyTr+vhoXt
         4Zxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793785400; x=1794390200;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QiBV51YSsvAhVbkuD5G3dwy2wbYhE77P1hdgw6UX+wY=;
        b=pTk5blVk91vK4ntqQPd2Woi5kTEl3sljeLqUkyhOItb5OvQa/QCtBjNvmWQ4ZAjQEf
         c6umFO7H/hcqxsTq7DV42JiC4QH9Jckn9GMo5IHEZ2HjIXK806mQrfsDitMLO2et3bDQ
         anjWdq0lbWZ7YEOJm8Vk5ZmM9jII/kJ0Ol/jDM1FEY0la1CZNWEz47kxJ/R6BMtmGOAx
         HLfgyfZm2JClkSe9GJeFIZ/0RNGWRgYV8hVRsquNbqYyboKVOdRvnBcHLVL5O4RvoPGF
         MHRPveQF5L4dxpyia21IWsvZFt6ccCPyTscUHXzinhPLuFeQdZ0Lilz8WIcBfRD+H8/y
         4iow==
X-Forwarded-Encrypted: i=1; AKwUvBwj6GU4G87ATC5dCeSw/n2cMLFvxAnpgr4os3JnmBeL1yD95UUnC1JOCRrBB6D6BjY4sGLk0nphlnHl@vger.kernel.org
X-Gm-Message-State: APuU4Z9HietOBnDBwhw/ajgeXNtHK47nqTe+mFqsGLtUx1ke+kdo06w9
	5KvjupwM6XKP5AlFxSgkmQnnRcrYt88JiasgHIltpd7/e4/YsPMHcNahIISXoE+0x0/mGkIEg1K
	jEUnRyVo+HdnutX8ya2Twvb2C9kpJVIHbMJsZ4XD5ZV5faWgWEmsWZmM=
X-Gm-Gg: AYBFou0nK1OV783+AwpHuvQ4XvZlGoqmpFI5TQ57GadYqtJ6R6uphbcGszzrlU6fKhY
	wrwqXe2kUYp2Xx0OLr5Eb017E/LU6aPNfQh7Q8SOPkSYX/NYm7jwteMPeh82z74ys1rpTefUvwm
	/ObMagDk/oDIhbYWL3WFTlH+0iZlbCzxkH1gV7f0jdymwfes1NAdoTwOjDT5gyUfEmPTErG5Wdk
	ui13baCcODQeg0FClhpquo2UJWbHuFA3mmj/Ed5s/tC7kaXc5GpR0sO5C33XvYFPHjhRKx9GHyn
	AqeWxjRquzwViHpdXd7KG9odGukiVJSgaE93qUhB2DyMSYqOzf7w60PcVjZ9qG0t39puuQO6UFK
	v+KNkoV4HOM8UbjQrVoC1eBujshEeGqEo5E85
X-Received: by 2002:a17:907:bd88:b0:c4c:b03f:11ed with SMTP id
 a640c23a62f3a-c4cb03f132dmr1510037566b.0.1793785399624; Wed, 04 Nov 2026
 01:43:19 -0800 (PST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104021411.1467970-1-vulab@iscas.ac.cn> <CAMGffEkj=rzCiiek=p+9Qc2AjJ1Nkk00H8wFReQ9-0ptWHKobw@mail.gmail.com>
 <20261104-fragrant-fascinating-civet-9c5cd8@quoll>
In-Reply-To: <20261104-fragrant-fascinating-civet-9c5cd8@quoll>
From: Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date: Wed, 4 Nov 2026 10:43:08 +0100
X-Gm-Features: AclHuK8EAqHptojAMedX7xZPLBxLBGDBVB0uhtjpy1fDRpkJASdh3EyQ4EMSZYA
Message-ID: <CAMGffEma9iNEFWSJX4o845CRcpk2U3A6=Y6NisANmhrAQ_riRA@mail.gmail.com>
Subject: Re: [PATCH] scsi: pm8001: unwind the probe on ccb tag allocation failure
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Wentao Liang <vulab@iscas.ac.cn>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 4, 2026 at 9:41=E2=80=AFAM Krzysztof Kozlowski <krzk@kernel.org=
> wrote:
>
> On Wed, Nov 04, 2026 at 09:33:55AM +0100, Jinpu Wang wrote:
> > On Wed, Nov 4, 2026 at 3:14=E2=80=AFAM Wentao Liang <vulab@iscas.ac.cn>=
 wrote:
> > >
> > > pm8001_init_ccb_tag() is called after the Scsi_Host, the sas_ha and t=
he
> > > driver's private data have been allocated, and after the PCI regions
> > > have been requested.  When it fails, pm8001_pci_probe() jumps to
> > > err_out_enable, which only returns the error: the Scsi_Host, sas_ha a=
nd
> > > private data are leaked, the PCI regions stay requested and the devic=
e
> > > stays enabled.
> > >
> > > Jump to err_out_ha_free instead, which releases all of those resource=
s.
> > >
> > > Fixes: 5a141315ed7c ("scsi: pm80xx: Increase the number of outstandin=
g I/O supported to 1024")
> > > Cc: stable@vger.kernel.org
> > > Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
> > > Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> > Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
>
> Are you sure? Sashiko reports introduced UAF (and/or other bugs).
>
> Mind that vulab@iscas.ac.cn is a bot with spams with tons of patches
> which looks exactly like previous hypocrite commit approach - some
> security vulnerability intentionally added in between of thousands of
> valid patches.
oh, didn't notice the report, thanks for the reminder.
I take back my ack.
>
> Best regards,
> Krzysztof
>
