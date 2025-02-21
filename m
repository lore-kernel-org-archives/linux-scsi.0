Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36DB81B0406;
	Fri, 21 Feb 2025 08:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740126900; cv=none; b=m8mPFPxCl48EVslnFeqkfT/6hfKuOLdnxNhYboWDVNa6ySLJwxUYfDDuT8dtBQ7lHgfjkEaKS+xUMhqqjYdIks3w4GsM3l6344hrP6oNZ9725NcuCkUyG87SSTQXL/oAYZQGE5vUo5/UoP+Di5dQflwz784VVbcee8H5FvNxnhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740126900; c=relaxed/simple;
	bh=aMGL80grSUdUjAL22Q8i8LGN9RpI+QqS+QI8A3vn9yc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Q7OZMdI0Ib+glErkqVeGLusALJMFyGPW2NbsdycXukfM2eISAQObXA2D9mk2mWy8lNMlXVt9n3Zqtepz8s1jBEwjozsrBSNzg0ySZfx9MDljWVpAc9JC/304tCNijb0uT8v7zG3Pen1Gjf/co1t5pgdgeUVS4qy+f8aexCxTrFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YPCyAP2J; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YPCyAP2J"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-43948f77f1aso10882455e9.0;
        Fri, 21 Feb 2025 00:34:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740126897; x=1740731697; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:content-language:references:cc:to:from
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=aMGL80grSUdUjAL22Q8i8LGN9RpI+QqS+QI8A3vn9yc=;
        b=YPCyAP2Ju3zj8hcWH2GtPxn2c/iZuQueZTzUDXdBJ7566qeTVAVJF6+I7m6l+Usbks
         Yfek7v77fI4h3tggFgvIdaQG6M6sk/hX3Uu/iFr8ADDbhJ7j7GqS8Fp0CrJA9jrLdoxr
         ej02Azf7CuydsnHUNCM+MYuLjAqwOIIIjj9sVhjkcX3Xf8+gQgjgJMmtUt/GELJ0zQOW
         BV2f6AIxDNQEhYhMqzQ0PtTcg9B+XVcbVdXuepdO/CXWp1GKopmhAZ3HsVde1f9uIMG4
         8/QkdCMer0JdA1I72islo5fRw+foUevAJ1IB/jtJUfBdvldOZhzQeei6JSrdnUJlDXTM
         jkhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740126897; x=1740731697;
        h=in-reply-to:autocrypt:content-language:references:cc:to:from
         :subject:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aMGL80grSUdUjAL22Q8i8LGN9RpI+QqS+QI8A3vn9yc=;
        b=ZBWxH8PTTxYeqGgGvdAOcN96QM1nm+Jp19zYK+h0r2vlbYuxvjRPKBuKTLCl3Bn/Tx
         tVnRiaSmQ13kPIEHpOTPBeUVoaT6gq6mwah+acLMKLM4mPT9yIzu06xYhH3ckoX9x2wx
         01eVcnjpC7Pejdc1fDlKnU89xru78MCKO9ue3mFc9RyM/jGBSP1K/6QaDbID2aRVFX/d
         chf/4zfGyP1Lcu4S8rpzeMuH2UptLVZPmBKTEbOtOcCpoc1YzB6EqMcEMWhHtfScNTap
         i2BUdx4+hJKuMCYegQ/0jorKPKjyiRrhSxJWap9ytYt69a8uI+wgTzm306lzoRi2ayW1
         Ljfg==
X-Forwarded-Encrypted: i=1; AJvYcCVVPG7+lw/SMpK92PW9Sn0REBXvJDfEHpeMKHNe0bRaxR8k8dLr35X16zjXOsZxUnaIHsQUxMAgRAWqgZs=@vger.kernel.org, AJvYcCXU2YVNVx91VJaOQORr7O9N1L1zOWGh/RQMtSmDwUnmO2uFQzXYjcXrm7hTuglg12dxBcsFBZg2om7XmA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzBDuyaNOWT2AC0ZK8VAFee4920o7NiAsbNZTefRKHNHnyP5zP8
	WFcxgCu53Tz7ZWibM0xrhMJr7eTDF5p3756xZcTr3ztg4njmCChz
X-Gm-Gg: ASbGnctCIy+s0fMUq7ljqo7FKuS1b6nSFucYQtEsKTknibC8I/IpXdoOQn2/J0/O/h0
	SgYYMeq4sPcX6mDdwSNn68YiLeLb03dQjse4NLvNmkbKyxY34eOROaxlobIN10HjmfnxZoK4a0l
	D+tSwkIRUFHOLZKLs8BsIPaoW6trxD/pVcAtwGJYdkvHq7fRVb63NQb+wF1sMMR4yKZkcZDiG+L
	2izoxMX+irUlJ0E23u0p31J8y/BhViQAa33aHTAZcB/BcTHYCn4rOl2y7hKNnkh5uebcf31oS0P
	04HdjoEXUqMZBkcDlJ+8OdToirbFinR8m6Q=
X-Google-Smtp-Source: AGHT+IFQZXGJL43N6rYNUQTDvmOVnpCVxwd85mFObj4vfcP1E6rpn9j10VNNyu/DP5kimIOdPC8C4A==
X-Received: by 2002:a05:600c:35cc:b0:439:9386:ef6c with SMTP id 5b1f17b1804b1-439ae1d7ba7mr16734895e9.2.1740126897113;
        Fri, 21 Feb 2025 00:34:57 -0800 (PST)
Received: from [192.168.1.240] ([194.120.133.72])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-439b031b9basm10033665e9.38.2025.02.21.00.34.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2025 00:34:56 -0800 (PST)
Message-ID: <f928d92f-7185-42ad-9aa9-844f0e98a850@gmail.com>
Date: Fri, 21 Feb 2025 08:34:18 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: mpt3sas: Fix spelling mistake "receveid" ->
 "received"
From: "Colin King (gmail)" <colin.i.king@gmail.com>
To: Sathya Prakash <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250221083253.77496-1-colin.i.king@gmail.com>
Content-Language: en-US
Autocrypt: addr=colin.i.king@gmail.com; keydata=
 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
 FVPMkxl2UyaayDvhrO9kNXvl1SKCpdzCMQ==
In-Reply-To: <20250221083253.77496-1-colin.i.king@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------jjSt2w1IWriAaCB2nSaRnplR"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------jjSt2w1IWriAaCB2nSaRnplR
Content-Type: multipart/mixed; boundary="------------4QUfbI588VLWXc5nk1t30fm2";
 protected-headers="v1"
From: "Colin King (gmail)" <colin.i.king@gmail.com>
To: Sathya Prakash <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <f928d92f-7185-42ad-9aa9-844f0e98a850@gmail.com>
Subject: Re: [PATCH] scsi: mpt3sas: Fix spelling mistake "receveid" ->
 "received"
References: <20250221083253.77496-1-colin.i.king@gmail.com>
In-Reply-To: <20250221083253.77496-1-colin.i.king@gmail.com>

--------------4QUfbI588VLWXc5nk1t30fm2
Content-Type: multipart/mixed; boundary="------------Ml0WFusNExdpjEsOswU7LrIe"

--------------Ml0WFusNExdpjEsOswU7LrIe
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

Rm9yZ290IHRvIGFkZCBbbmV4dF0gaW4gc3ViamVjdCBsaW5lDQoNCk9uIDIxLzAyLzIwMjUg
MDg6MzIsIENvbGluIElhbiBLaW5nIHdyb3RlOg0KPiBUaGVyZSBpcyBhIHNwZWxsaW5nIG1p
c3Rha2UgaW4gYSBpb2NfZXJyIG1lc3NhZ2UuIEZpeCBpdC4NCj4gDQo+IFNpZ25lZC1vZmYt
Ynk6IENvbGluIElhbiBLaW5nIDxjb2xpbi5pLmtpbmdAZ21haWwuY29tPg0KPiAtLS0NCj4g
ICBkcml2ZXJzL3Njc2kvbXB0M3Nhcy9tcHQzc2FzX2N0bC5jIHwgMiArLQ0KPiAgIDEgZmls
ZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAt
LWdpdCBhL2RyaXZlcnMvc2NzaS9tcHQzc2FzL21wdDNzYXNfY3RsLmMgYi9kcml2ZXJzL3Nj
c2kvbXB0M3Nhcy9tcHQzc2FzX2N0bC5jDQo+IGluZGV4IGJkMzkxOWYxNWFkYi4uZmY4ZmVk
ZjVmMjBlIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3Njc2kvbXB0M3Nhcy9tcHQzc2FzX2N0
bC5jDQo+ICsrKyBiL2RyaXZlcnMvc2NzaS9tcHQzc2FzL21wdDNzYXNfY3RsLmMNCj4gQEAg
LTI5NTksNyArMjk1OSw3IEBAIGludCBtcHQzc2FzX3NlbmRfbWN0cF9wYXNzdGhydV9yZXEo
c3RydWN0IG1wdDNfcGFzc3RocnVfY29tbWFuZCAqY29tbWFuZCkNCj4gICANCj4gICAJbXBp
X3JlcXVlc3QgPSAoTVBJMlJlcXVlc3RIZWFkZXJfdCAqKWNvbW1hbmQtPm1waV9yZXF1ZXN0
Ow0KPiAgIAlpZiAobXBpX3JlcXVlc3QtPkZ1bmN0aW9uICE9IE1QSTJfRlVOQ1RJT05fTUNU
UF9QQVNTVEhST1VHSCkgew0KPiAtCQlpb2NfZXJyKGlvYywgIiVzOiBJbnZhbGlkIHJlcXVl
c3QgcmVjZXZlaWQsIEZ1bmN0aW9uIDB4JXhcbiIsDQo+ICsJCWlvY19lcnIoaW9jLCAiJXM6
IEludmFsaWQgcmVxdWVzdCByZWNlaXZlZCwgRnVuY3Rpb24gMHgleFxuIiwNCj4gICAJCQlf
X2Z1bmNfXywgbXBpX3JlcXVlc3QtPkZ1bmN0aW9uKTsNCj4gICAJCXJldCA9IC1FSU5WQUw7
DQo+ICAgCQlnb3RvIHVubG9ja19jdGxfY21kczsNCg0K
--------------Ml0WFusNExdpjEsOswU7LrIe
Content-Type: application/pgp-keys; name="OpenPGP_0x68C287DFC6A80226.asc"
Content-Disposition: attachment; filename="OpenPGP_0x68C287DFC6A80226.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

xsFNBE6TJCgBEACo6nMNvy06zNKj5tiwDsXXS+LhT+LwtEsy9EnraKYXAf2xwazc
ICSjX06efanlyhB0figzQO0n/tP7BcfMVNG7n1+DC71mSyRK1ZERcG1523ajvdZO
xbBCTvTitYOy3bjs+LXKqeVMhK3mRvdTjjmVpWnWqJ1LL+Hn12ysDVVfkbtuIm2N
oaSEC8Ae8LSSyCMecd22d9PnLR4UeFgrWEkQsqROq6ZDJT9pBLGe1ZS0pVGhkRyB
P9GP65oPev39SmfAx9R92SYJygCy0pPvBMWKvEZS/7bpetPNx6l2xu9UvwoeEbpz
UvH26PHO3DDAv0ynJugPCoxlGPVf3zcfGQxy3otydNTWkP6Wh3Q85m+AlifgKZud
jZLrO6c+fAw/jFu1UMjNuyhgShtFU7NvEzL3RqzFf9O1qM2muj83IeFQ1FZ65QAi
CdTa3npz1vHc7N4uEQBUxyXgXfCI+A5yDnjHwzU0Y3RYS52TA3nfa08yLGPLTf5w
yAREkFYou20vh5vRvPASoXx6auVf1MuxokDShVhxLpryBnlKCobs4voxN54BUO7m
zuERXN8kadsxGFzItAyfKYzEiJrpUB1yhm78AecDyiPlMjl99xXk0zs9lcKriaBy
VUv/NsyJFQj/kmdxox3XHi9K29kopFszm1tFiDwCFr/xumbZcMY17Yi2bQARAQAB
zSdDb2xpbiBJYW4gS2luZyA8Y29saW4uaS5raW5nQGdtYWlsLmNvbT7CwZEEEwEI
ADsCGwMFCwkIBwMFFQoJCAsFFgIDAQACHgECF4AWIQRwYtqk8AG5xmFnAM9owoff
xqgCJgUCY8GcawIZAQAKCRBowoffxqgCJtd/EACIWcaxfVt/MH4qqo5ELsjCFPVp
+RhVpQDWy8v9Np2YbTcZ4AY2Zj4Pq/HrZ3F/Bh02v85C6mNv8BDTKev6Qcq3BYw0
iqw6/xLNvRcSFHM81mQI9xtnAWIWfI9k5hpX19QooPIIP3GOMdMc1uRUGTxTgTFA
AsAswRY3kMzo6k7arQnUs9zbiZ9SmS43qWOIxzGnvneekHHDAcomc/oho7kgj6rK
p/f9qRrhForkgVQwdj6iBlW934yRXzeFVF3wr7Lk5GQNIEkJiNQPZs54ojBS/Kx6
3UTLT1HgOp6UY9RPEi9wubmUR+J6YjLRZMr5PCcA86EYmRoysnnJ8Q/SlBVD8npp
GVEcuvrbH3MBfhmwOPDc3RyLkEtKfSTB92k1hsmRkx9zkyuUzhcSnqQnpWGJD+xt
KHvcHRT7Uxaa+SDwUDM36BjkyVcZQy8c+Is2jA55uwNgPpiA7n82pTeT+FRGd+7i
CLQHaryu6FO6DNDv09RbPBjIiC/q814aeKJaSILP1ld9/PEBrLPdm+6lG6OKOt9D
DV6jPmfR96FydjxcmI1cgZVgPomSxv2JB1erOggB8rmX4hhWYsVQl1AXZs3LdEpJ
6clmCPspn/ufZxHslgR9/WR1EvPMQc8XtssF55p8ehRIcVSXDRcMFr3ZuqMTXcL6
8YbDmv5OGS95O1Gs4c0iQ29saW4gS2luZyA8Y29saW4ua2luZ0B1YnVudHUuY29t
PsLBdwQTAQgAIQUCTwq47wIbAwULCQgHAwUVCgkICwUWAgMBAAIeAQIXgAAKCRBo
woffxqgCJo1bD/4gPIQ0Muy5TGHqTQ/bSiQ9oWjS5rAQvsrsVwcm2Ka7Uo8LzG8e
grZrYieJxn3Qc22b98TiT6/5+sMa3XxhxBZ9FvALve175NPOz+2pQsAV88tR5NWk
5YSzhrpzi7+klkWEVAB71hKFZcT0qNlDSeg9NXfbXOyCVNPDJQJfrtOPEuutuRuU
hrXziaRchqmlhmszKZGHWybmPWnDQEAJdRs2Twwsi68WgScqapqd1vq2+5vWqzUT
JcoHrxVOnlBq0e0IlbrpkxnmxhfQ+tx/Sw9BP9RITgOEFh6tf7uwly6/aqNWMgFL
WACArNMMkWyOsFj8ouSMjk4lglT96ksVeCUfKqvCYRhMMUuXxAe+q/lxsXC+6qok
Jlcd25I5U+hZ52pz3A+0bDDgIDXKXn7VbKooJxTwN1x2g3nsOLffXn/sCsIoslO4
6nbr0rfGpi1YqeXcTdU2Cqlj2riBy9xNgCiCrqrGfX7VCdzVwpQHyNxBzzGG6JOm
9OJ2UlpgbbSh6/GJFReW+I62mzC5VaAoPgxmH38g0mA8MvRT7yVpLep331F3Inmq
4nkpRxLd39dgj6ejjkfMhWVpSEmCnQ/Tw81z/ZCWExFp6+3Q933hGSvifTecKQlO
x736wORwjjCYH/A3H7HK4/R9kKfL2xKzD+42ejmGqQjleTGUulue8JRtpM1AQ29s
aW4gSWFuIEtpbmcgKEludGVsIENvbGluIElhbiBLaW5nIGtleSkgPGNvbGluLmtp
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
=3DQKm6
-----END PGP PUBLIC KEY BLOCK-----

--------------Ml0WFusNExdpjEsOswU7LrIe--

--------------4QUfbI588VLWXc5nk1t30fm2--

--------------jjSt2w1IWriAaCB2nSaRnplR
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEcGLapPABucZhZwDPaMKH38aoAiYFAme4OosFAwAAAAAACgkQaMKH38aoAiYJ
pg//cdsW1L88ahSM77LAAOS/wns+g7kEKUhlFhfDlbvdzU/bVDeKtyie+7V9QcJ+arMQgOc/JCFv
lGKGBqEh3xoq915IrPdx2SKc14tCa8zTMyI5XD6NG16CQCsvDZlj1Kp2QESKR349gPQiXF5hpL55
spJf2TJsVJZPiZLKiFdUGT0g+lkv1uObxIdkk5taOG27ht6SX79ZDfCiSSz0QnpaDF0WLuH7zZZ9
+zm6L0OXb3W8VfyMiPLq8nnPNEW5tXfQ/0Zs97sh2XJ/4Y55E25DL7Y8rOWXod9rIofiW1kSKMo8
ivwIcNjalmXo8iQvNokLJuAQEFVLo8gmMJq/6fnJBX/4gBAGCumwreTlLLzeu1MRH5pMHgDafbVs
Tp2mPSMEt4pbNdV5yaR+w+E4jH6IyMsFZIXjHgr+559u/X9TpGGtul6poPFhOdpoK0RTyOcxRQ+k
fUVX03e85rCm8Tpq0JYkJy9TQSgnvkk4oJ7vCLUby3Rs16oBOG+FyZaQF3T6chHuXjrsJKEoR9Dr
cV5liz6LG2TMpKsQ6HfnHpFzzcjolRFYHD1oY8CGNGRgByzuTd1fbSArEF7Oak7H1+HjquGw7PIa
cKhnM54hfJKkJCXvlGkBSVw6nZb0j+1R0gliBmjJ6Y+BpT9R/Pjn1R3pUAMD2ISo2QaXg5qe8t88
xws=
=9kl2
-----END PGP SIGNATURE-----

--------------jjSt2w1IWriAaCB2nSaRnplR--
