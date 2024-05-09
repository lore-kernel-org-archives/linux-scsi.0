Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03572C87C;
	Thu,  9 May 2024 02:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715220762; cv=none; b=EZ1Bj+faHzqH8v3p4YbxLD40m1BDpfVW//UhdSQbeLgc7SYNA23FgcE08OPfRnmwSXxpcOC0nRf4urPtV6L4m2LrL7uSoNRm6kuUlkvzaxdp2W2FC1hXpj95K+Au4qbcjH8omPnWvGRqDD3IhBW2vkt+Hkv82pJmCUDJcxUKRVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715220762; c=relaxed/simple;
	bh=/uVroRiOxF+R0oE6nrBdHJHTO1ppc5bIKNcNE0c6FIE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WNsmndNQRnijfStSiTQNnrxfX2okLlfBNAFQBqzIX845cxcA6kZmxhXroejPgiPFdI11LSzvSYcmRhDYc9HiJy2VMMZGhRYmJD7fieccqmFFqJx5nT/j8IZKsxGyLP0gk8ucqx74BqCkZkFFQAIv3CypoQ1DYo1o91Cvsi8FWew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=c7BUuaKc; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="c7BUuaKc"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a59a609dd3fso68956566b.0;
        Wed, 08 May 2024 19:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1715220759; x=1715825559; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:references:cc:to:content-language
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/uVroRiOxF+R0oE6nrBdHJHTO1ppc5bIKNcNE0c6FIE=;
        b=c7BUuaKcFMfa6QpdF3ZqCl8dz0Aev+btZn+4UfWJHfQrHsnb3PXrjir6AvYH3ZzSnG
         DHYaaKPQGfT+t3tcxjlkwak9OnQUCJhUviIcpKDu5InTli1Oo9AVKflAI+UGHYrla79t
         TpSA0GNEgmfDSUB0cWQYdRoh8IODlOjV8lgVbS6UzFzyrzgwxzCCkuInRVgyG5+5EPY5
         soanAzQlsSG/oaGfwX70Rt9I9vbmn8aebux0k/OQotnQxOL1/Jsgkbhm0VR57sgDMIXx
         CIMyHiTKrLIR0AG3mhhYWOm6Mg4BPOyKfoEkRzjIxpUXYWKlsFRt5wXOB5lacIoSeNxz
         Jf9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715220759; x=1715825559;
        h=in-reply-to:autocrypt:from:references:cc:to:content-language
         :subject:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/uVroRiOxF+R0oE6nrBdHJHTO1ppc5bIKNcNE0c6FIE=;
        b=EmSrTFoGSvuMWhP0on6R593FqZHVRoquyMsBJJw8qf85PtFiByqEu12G2SSk2J3/dJ
         wqcu4Qkqgp2KqJxxLWiUcI8e+Ng12yV0/hjYi7QpNqpI7xxC7Y4skJZfvljf/bUp82v7
         ya3RAhqcWEdVEHrPNWTQsnxuBloUMcvSBEVOcZas+qrXlioumLn/8O5wmmKyrLtUrQOk
         OcwZ1I+5YPdz8+LgPEMErQ7F8/xntn2e2z6Lo+7a8tIDBPDiGz+E98+WsS2n1l2dPhin
         4w+N1Nuk4GXhl+tLv5MiOzcCOwHl8d7FM39Oj9/jNwNmCR3YEjUUhtzzV9c6UnrXgtgx
         c5hg==
X-Forwarded-Encrypted: i=1; AJvYcCUvtFmRIeFRJizinST+o0K2VUT71FVzSP0ziox+xZ6UUUE3sl3mHL0EEdsupnOpMKpA7XHcgmyh0c9xlnhyguq+njt+Pw/ZzQJaY/GONAUspWRad20w/y9n0YfX5PsX0WBC+jFv
X-Gm-Message-State: AOJu0YxXfizH3LeMItXJvKWq1V7WagQWCg06JGL6UwQBUygQxRzog1t5
	MJcgwxy88z6MtbN6ckhA4av4KtSWxiQzBYE2ElZMZxxWdetaqMM=
X-Google-Smtp-Source: AGHT+IEv1To3WKcCXF4IZYX+eZGt5q9jhPlEMNAhblrtluvAEEmhPegE1njyo4Th1V9WHIGFeovlVw==
X-Received: by 2002:a17:907:76f4:b0:a59:a85c:a5ca with SMTP id a640c23a62f3a-a5a115bd150mr96847266b.7.1715220759028;
        Wed, 08 May 2024 19:12:39 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b48dd.dip0.t-ipconnect.de. [91.43.72.221])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a5a1781d548sm22676966b.34.2024.05.08.19.12.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 May 2024 19:12:38 -0700 (PDT)
Message-ID: <5c354987-e373-4d6c-aa55-4030f1a31503@googlemail.com>
Date: Thu, 9 May 2024 04:12:36 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: Kernel 6.8.4 regression: aacraid controller not initialized any
 more, system boot hangs
Content-Language: de-DE
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, stable@vger.kernel.org,
 linux-kernel@vger.kernel.org, regressions@leemhuis.info,
 regressions@lists.linux.dev
References: <eec6ebbf-061b-4a7b-96dc-ea748aa4d035@googlemail.com>
 <yq1cypvwz5o.fsf@ca-mkp.ca.oracle.com>
From: Peter Schneider <pschneider1968@googlemail.com>
Autocrypt: addr=pschneider1968@googlemail.com; keydata=
 xjMEY58biBYJKwYBBAHaRw8BAQdADPnoGTrfCUCyH7SZVkFtnlzsFpeKANckofR4WVLMtMzN
 L1BldGVyIFNjaG5laWRlciA8cHNjaG5laWRlcjE5NjhAZ29vZ2xlbWFpbC5jb20+wpwEExYK
 AEQCGyMFCQW15qgFCwkIBwICIgIGFQoJCAsCBBYCAwECHgcCF4AWIQSjgovXlszhGoyt6IZu
 OpLJLD/yRAUCY58b8AIZAQAKCRBuOpLJLD/yRIeIAQD0+/LMdKHM6AJdPCt+e9Z92BMybfnN
 RtGqkdZWtvdhDQD9FJkGh/3PFtDinimB8UOB7Gi6AGxt9Nu9ne7PvHa0KQXOOARjnxuIEgor
 BgEEAZdVAQUBAQdAw2GRwTf5HJlO6CCigzqH6GUKOjqR1xJ+3nR5EbBze0sDAQgHwn4EGBYK
 ACYWIQSjgovXlszhGoyt6IZuOpLJLD/yRAUCY58biAIbDAUJBbXmqAAKCRBuOpLJLD/yRONS
 AQCwB9qiEQoSnxHodu8kRuvUxXKIqN7701W+INXtFGtJygEAyPZH3/vSBJ4A7GUG7BZyQRcr
 ryS0CUq77B7ZkcI1Nwo=
In-Reply-To: <yq1cypvwz5o.fsf@ca-mkp.ca.oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------0vf3HL9Ft144MVPrbYb3Y7ZK"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------0vf3HL9Ft144MVPrbYb3Y7ZK
Content-Type: multipart/mixed; boundary="------------6sr3i0pFB7m39sU7z2d4VxOW";
 protected-headers="v1"
From: Peter Schneider <pschneider1968@googlemail.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, stable@vger.kernel.org,
 linux-kernel@vger.kernel.org, regressions@leemhuis.info,
 regressions@lists.linux.dev
Message-ID: <5c354987-e373-4d6c-aa55-4030f1a31503@googlemail.com>
Subject: Re: Kernel 6.8.4 regression: aacraid controller not initialized any
 more, system boot hangs
References: <eec6ebbf-061b-4a7b-96dc-ea748aa4d035@googlemail.com>
 <yq1cypvwz5o.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1cypvwz5o.fsf@ca-mkp.ca.oracle.com>

--------------6sr3i0pFB7m39sU7z2d4VxOW
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkgTWFydGluLA0KDQpBbSAwOS4wNS4yMDI0IHVtIDAzOjM4IHNjaHJpZWIgTWFydGluIEsu
IFBldGVyc2VuOg0KID4NCiA+IEhpIFBldGVyIQ0KID4NCiA+IFRoYW5rcyBmb3IgdGhlIGRl
dGFpbGVkIGJ1ZyByZXBvcnQuDQoNClRoYW5rcyB0aGF0IHlvdSBhcmUgbG9va2luZyBpbnRv
IHRoZSBpc3N1ZSEgSSB0aG91Z2h0IEknZCBiZSBhbHNvIENDJ2luZyB0aGUgcmVsZXZhbnQg
DQpyZWdyZXNzaW9ucyB0cmFja2VyK21haWxpbmcgbGlzdC4gRm9yIHJlZmVyZW5jZSwgbXkg
b3JpZ2luYWwgbWVzc2FnZSBjYW4gYmUgZm91bmQgaGVyZToNCg0KaHR0cHM6Ly9sb3JlLmtl
cm5lbC5vcmcvYWxsL2VlYzZlYmJmLTA2MWItNGE3Yi05NmRjLWVhNzQ4YWE0ZDAzNUBnb29n
bGVtYWlsLmNvbS8NCg0KWy4uLl0NCg0KID4gQ2FuIHlvdSBwbGVhc2Ugc2VuZCBtZSB0aGUg
b3V0cHV0IG9mOg0KID4NCiA+ICMgc2dfdnBkIC1hIC9kZXYvc2RhDQogPiAjIHNnX3JlYWRj
YXAgLWwgL2Rldi9zZGENCiA+DQogPiB3aGVyZSBzZGEgaXMgb25lIG9mIHRoZSBhYWNyYWlk
IHZvbHVtZXMuDQoNCg0KSGVyZSB5b3UgZ28uLi4gc2RhIGlzIHRoZSAxVGlCIFJBSUQxIGFy
cmF5LCBzZGIgaXMgdGhlIDVUaUIgUkFJRDUgYXJyYXkuDQoNCg0Kcm9vdEBsaW51czp+IyB1
bmFtZSAtcg0KNi41LjEzLTUtcHZlDQpyb290QGxpbnVzOn4jIHNnX3ZwZCAtYSAvZGV2L3Nk
YQ0KU3VwcG9ydGVkIFZQRCBwYWdlcyBWUEQgcGFnZToNCiAgIFN1cHBvcnRlZCBWUEQgcGFn
ZXMgW3N2XQ0KICAgVW5pdCBzZXJpYWwgbnVtYmVyIFtzbl0NCiAgIERldmljZSBpZGVudGlm
aWNhdGlvbiBbZGldDQoNClVuaXQgc2VyaWFsIG51bWJlciBWUEQgcGFnZToNCiAgIFVuaXQg
c2VyaWFsIG51bWJlcjogNTBDMEI4MkQNCg0KRGV2aWNlIElkZW50aWZpY2F0aW9uIFZQRCBw
YWdlOg0KICAgQWRkcmVzc2VkIGxvZ2ljYWwgdW5pdDoNCiAgICAgZGVzaWduYXRvciB0eXBl
OiBUMTAgdmVuZG9yIGlkZW50aWZpY2F0aW9uLCAgY29kZSBzZXQ6IEFTQ0lJDQogICAgICAg
dmVuZG9yIGlkOiBBREFQVEVDDQogICAgICAgdmVuZG9yIHNwZWNpZmljOiBBUlJBWSAgICAg
ICAgICAgNTBDMEI4MkQNCiAgICAgZGVzaWduYXRvciB0eXBlOiBFVUktNjQgYmFzZWQsICBj
b2RlIHNldDogQmluYXJ5DQogICAgICAgMHgyZGI4YzA1MDAwZDAwMDAwDQpyb290QGxpbnVz
On4jIHNnX3JlYWRjYXAgLWwgL2Rldi9zZGENClJlYWQgQ2FwYWNpdHkgcmVzdWx0czoNCiAg
ICBQcm90ZWN0aW9uOiBwcm90X2VuPTAsIHBfdHlwZT0wLCBwX2lfZXhwb25lbnQ9MA0KICAg
IExvZ2ljYWwgYmxvY2sgcHJvdmlzaW9uaW5nOiBsYnBtZT0wLCBsYnByej0wDQogICAgTGFz
dCBMQkE9MTk5ODU2NTM3NSAoMHg3NzFmYWZmZiksIE51bWJlciBvZiBsb2dpY2FsIGJsb2Nr
cz0xOTk4NTY1Mzc2DQogICAgTG9naWNhbCBibG9jayBsZW5ndGg9NTEyIGJ5dGVzDQogICAg
TG9naWNhbCBibG9ja3MgcGVyIHBoeXNpY2FsIGJsb2NrIGV4cG9uZW50PTANCiAgICBMb3dl
c3QgYWxpZ25lZCBMQkE9MA0KSGVuY2U6DQogICAgRGV2aWNlIHNpemU6IDEwMjMyNjU0NzI1
MTIgYnl0ZXMsIDk3NTg2Mi4wIE1pQiwgMTAyMy4yNyBHQg0Kcm9vdEBsaW51czp+IyBzZ192
cGQgLWEgL2Rldi9zZGINClN1cHBvcnRlZCBWUEQgcGFnZXMgVlBEIHBhZ2U6DQogICBTdXBw
b3J0ZWQgVlBEIHBhZ2VzIFtzdl0NCiAgIFVuaXQgc2VyaWFsIG51bWJlciBbc25dDQogICBE
ZXZpY2UgaWRlbnRpZmljYXRpb24gW2RpXQ0KDQpVbml0IHNlcmlhbCBudW1iZXIgVlBEIHBh
Z2U6DQogICBVbml0IHNlcmlhbCBudW1iZXI6IDg3MTgxNjJEDQoNCkRldmljZSBJZGVudGlm
aWNhdGlvbiBWUEQgcGFnZToNCiAgIEFkZHJlc3NlZCBsb2dpY2FsIHVuaXQ6DQogICAgIGRl
c2lnbmF0b3IgdHlwZTogVDEwIHZlbmRvciBpZGVudGlmaWNhdGlvbiwgIGNvZGUgc2V0OiBB
U0NJSQ0KICAgICAgIHZlbmRvciBpZDogQURBUFRFQw0KICAgICAgIHZlbmRvciBzcGVjaWZp
YzogQVJSQVkgICAgICAgICAgIDg3MTgxNjJEDQogICAgIGRlc2lnbmF0b3IgdHlwZTogRVVJ
LTY0IGJhc2VkLCAgY29kZSBzZXQ6IEJpbmFyeQ0KICAgICAgIDB4MmQxNjE4ODcwMGQwMDAw
MA0Kcm9vdEBsaW51czp+IyBzZ19yZWFkY2FwIC1sIC9kZXYvc2RiDQpSZWFkIENhcGFjaXR5
IHJlc3VsdHM6DQogICAgUHJvdGVjdGlvbjogcHJvdF9lbj0wLCBwX3R5cGU9MCwgcF9pX2V4
cG9uZW50PTANCiAgICBMb2dpY2FsIGJsb2NrIHByb3Zpc2lvbmluZzogbGJwbWU9MCwgbGJw
cno9MA0KICAgIExhc3QgTEJBPTk3NjIyMjIwNzkgKDB4MjQ1ZGZhZmZmKSwgTnVtYmVyIG9m
IGxvZ2ljYWwgYmxvY2tzPTk3NjIyMjIwODANCiAgICBMb2dpY2FsIGJsb2NrIGxlbmd0aD01
MTIgYnl0ZXMNCiAgICBMb2dpY2FsIGJsb2NrcyBwZXIgcGh5c2ljYWwgYmxvY2sgZXhwb25l
bnQ9MA0KICAgIExvd2VzdCBhbGlnbmVkIExCQT0wDQpIZW5jZToNCiAgICBEZXZpY2Ugc2l6
ZTogNDk5ODI1NzcwNDk2MCBieXRlcywgNDc2NjcxMC4wIE1pQiwgNDk5OC4yNiBHQiwgNS4w
MCBUQg0KDQoNCkJlc3RlIEdyw7zDn2UsDQpQZXRlciBTY2huZWlkZXINCg0KLS0gDQpDbGlt
YiB0aGUgbW91bnRhaW4gbm90IHRvIHBsYW50IHlvdXIgZmxhZywgYnV0IHRvIGVtYnJhY2Ug
dGhlIGNoYWxsZW5nZSwNCmVuam95IHRoZSBhaXIgYW5kIGJlaG9sZCB0aGUgdmlldy4gQ2xp
bWIgaXQgc28geW91IGNhbiBzZWUgdGhlIHdvcmxkLA0Kbm90IHNvIHRoZSB3b3JsZCBjYW4g
c2VlIHlvdS4gICAgICAgICAgICAgICAgICAgIC0tIERhdmlkIE1jQ3VsbG91Z2ggSnIuDQoN
Ck9wZW5QR1A6ICAweEEzODI4QkQ3OTZDQ0UxMUE4Q0FERTg4NjZFM0E5MkM5MkMzRkYyNDQN
CkRvd25sb2FkOiBodHRwczovL3d3dy5wZXRlcnMtbmV0enBsYXR6LmRlL2Rvd25sb2FkL3Bz
Y2huZWlkZXIxOTY4X3B1Yi5hc2MNCmh0dHBzOi8va2V5cy5tYWlsdmVsb3BlLmNvbS9wa3Mv
bG9va3VwP29wPWdldCZzZWFyY2g9cHNjaG5laWRlcjE5NjhAZ29vZ2xlbWFpbC5jb20NCmh0
dHBzOi8va2V5cy5tYWlsdmVsb3BlLmNvbS9wa3MvbG9va3VwP29wPWdldCZzZWFyY2g9cHNj
aG5laWRlcjE5NjhAZ21haWwuY29tDQoNCg==

--------------6sr3i0pFB7m39sU7z2d4VxOW--

--------------0vf3HL9Ft144MVPrbYb3Y7ZK
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wnsEABYIACMWIQSjgovXlszhGoyt6IZuOpLJLD/yRAUCZjwxFAUDAAAAAAAKCRBuOpLJLD/yRHt8
AP0ZMUE5HT5W4eXGolfab8zPa3WiCAdmmPE/CexEU5ZSFAD9HlRhacx4D5/jl6naYaKlBMRJevmv
RpcTxqTjrT3oYg0=
=rNP1
-----END PGP SIGNATURE-----

--------------0vf3HL9Ft144MVPrbYb3Y7ZK--
