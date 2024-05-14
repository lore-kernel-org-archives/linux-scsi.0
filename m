Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92CABF9D4;
	Tue, 14 May 2024 07:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715670481; cv=none; b=CZE19RMadOPp0dgCc7NWV9YCIqWjMNABNkBO72WvgbATa1YY4H9enAMYG570IBeIHw2uvRo+pOevQl8+/2wrvdGbvCrlO4bi2zzooUcT154pszgMY8bkVcyR/AJjFGUP4D2104i4vnCgL3aIeGylBJi7U6Tmj7W1UbxMWRuE0+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715670481; c=relaxed/simple;
	bh=X+YkrXgyWzVE1vkaFzWg3Tm00enAzXXtdq+NMhAjH/M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MavnWkbP3bCm+CJe63upFhLdgFu0N+QEr1C0jcARyUlGsW8sEQYqlLI0NAuOzcHwhEEjJHNhRwMJKniehp+2N3Ly9BuVHTOzFN5hXCmGfRMVBapjXqvunk3wZSkH5bjBMcAolFxoiJLWFoBRgdXmvEE7xi7GnVtwWd7BVLSScXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=evv0SBhD; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="evv0SBhD"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-41ffad2426eso36674825e9.3;
        Tue, 14 May 2024 00:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1715670478; x=1716275278; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=X+YkrXgyWzVE1vkaFzWg3Tm00enAzXXtdq+NMhAjH/M=;
        b=evv0SBhDWUZd9BGlOo8xhU5F+bFnr/Yg6MbO0B3suAdHjc8R1ottIGxd83TosT/Gmb
         EekuFr1dbrYErDfFwgWQzOw4J2xsh+sjfHdNOJpdcmiNmXQiBCxRkrsXhLanukjYoRN+
         pKmpfYYsDhTMkKAFAzMJ01SFKJzOO8qoMhlvMlyEYGmk2y2KnSXxlYjup5td/VLpyq0K
         4TKxCv5saL9shvQAZX3HI1iGNadNdsYjy5OYMgxAE6oruULVkG8veldC/4w6ZHMQA9BY
         KQc1+2Cs75niQto+hLvY3wfzBd2H8ag1JalX5uF2zjzG8dXNwGrNVBRFo+MfTt8XZ65N
         T6LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715670478; x=1716275278;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X+YkrXgyWzVE1vkaFzWg3Tm00enAzXXtdq+NMhAjH/M=;
        b=YaAXd1iTWjevBZSQY7LAVq1qmslWXMiclGSooLWdia1R2NSgJjoo4Hr7XFT1eOY5Rh
         yqW2tkHCgXnR/f3YeivuF7DCd7VmtceJs/hOWh2Ye1/iqcDcfH7m9RUoSYJipyy9DZVd
         7s7Ze96I65cKlsqKEwqLAUyimtC0YMAh4vR6ZQyeDCB9xT8ZxQZjxJlYrVxbEXC/iZ1R
         ELCDdoXOivHu2pgTEnRYtll/rvgo+4gewAKscOEa88Zxg3I6SlJlSnEYC5uEdSLN6hO/
         Z2rjVHT81pLZdJdtGaUCpHnF34b3fjGAvzgJrrbhb1L4ArWgJjFNF6xYlrQaG2/Y8WKf
         wi/g==
X-Forwarded-Encrypted: i=1; AJvYcCXSMEr5i4PhhK7C5Hc9CyrjKgrUNFwTM9JcTbQr+tsCWjywstx7HuKBaX7ob9z6FQrdTWtNtbBTv0d/bfvoFhJC3SKgEehZbKRGuGEIuPG8HaLdrdtL644/vXoaF0R82OMM1sQn
X-Gm-Message-State: AOJu0YxVnjtvUUUIk3KIs01oCaA9ti9dQGd0RZc3pRCV2XIXooj0PY5y
	c3uQDVYv4AFSysP4yvZTrWB1uWnN2hAZnxnjMNaK6M9ox53z8NHld3kgHTI=
X-Google-Smtp-Source: AGHT+IEsS63TXT+CNUHhfxEjLBmwVUfEfHU7Zb1RUnpJaRDD56Nb3r+lUE0Fx0YW+PSVfdn2LDRVhA==
X-Received: by 2002:a05:600c:5252:b0:420:f8:23d6 with SMTP id 5b1f17b1804b1-42000f82681mr109286795e9.36.1715670477628;
        Tue, 14 May 2024 00:07:57 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b40c2.dip0.t-ipconnect.de. [91.43.64.194])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42012d9ace5sm79279885e9.2.2024.05.14.00.07.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 May 2024 00:07:56 -0700 (PDT)
Message-ID: <c4e8e0b5-fc32-4e26-8c0e-27a996769903@googlemail.com>
Date: Tue, 14 May 2024 09:07:55 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: Kernel 6.8.4 regression: aacraid controller not initialized any
 more, system boot hangs
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, stable@vger.kernel.org,
 linux-kernel@vger.kernel.org, regressions@leemhuis.info,
 regressions@lists.linux.dev
References: <eec6ebbf-061b-4a7b-96dc-ea748aa4d035@googlemail.com>
 <yq1cypvwz5o.fsf@ca-mkp.ca.oracle.com>
Content-Language: de-DE
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
 boundary="------------3k07hvzCU80C7y4hrWzdZar0"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------3k07hvzCU80C7y4hrWzdZar0
Content-Type: multipart/mixed; boundary="------------XgrnrIbEqmkVi01629oNH2n6";
 protected-headers="v1"
From: Peter Schneider <pschneider1968@googlemail.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, stable@vger.kernel.org,
 linux-kernel@vger.kernel.org, regressions@leemhuis.info,
 regressions@lists.linux.dev
Message-ID: <c4e8e0b5-fc32-4e26-8c0e-27a996769903@googlemail.com>
Subject: Re: Kernel 6.8.4 regression: aacraid controller not initialized any
 more, system boot hangs
References: <eec6ebbf-061b-4a7b-96dc-ea748aa4d035@googlemail.com>
 <yq1cypvwz5o.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1cypvwz5o.fsf@ca-mkp.ca.oracle.com>

--------------XgrnrIbEqmkVi01629oNH2n6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkgTWFydGluLA0KDQptZWFud2hpbGUsIHNvbWUgbW9yZSBwZW9wbGUgd2hvIGZhY2UgdGhl
IHNhbWUgcHJvYmxlbSBoYXZlIGJlZW4gZ2F0aGVyaW5nIGluIHRoaXMgdGhyZWFkIA0KaW4g
dGhlIFByb3htb3ggdXNlciBmb3J1bToNCg0KaHR0cHM6Ly9mb3J1bS5wcm94bW94LmNvbS90
aHJlYWRzL3B2ZS04LTIta2VybmVsLTYtOC00LTItZG9lcy1ub3QtYm9vdC1jYW5ub3QtZmlu
ZC1yb290LWRldmljZS4xNDU3NjQvDQoNClR3byBvZiB0aGVtIGFsc28gaGF2ZSBhbiBBZGFw
dGVjIGNvbnRyb2xsZXIsIHdoaWxlIGFub3RoZXIgb25lIGhhcyBhIFBFUkMgSDMxMCBNaW5p
IChMU0kgDQpiYXNlZCkuDQoNCkRpZCB5b3UgaGF2ZSBhbnkgY2hhbmNlIHRvIGxvb2sgaW50
byB0aGlzIGluIG1vcmUgZGVwdGg/IERvIHlvdSBuZWVkIG1vcmUgaW5mb3JtYXRpb24gZnJv
bSANCm1lIHRvIHRhY2tsZSB0aGlzIGlzc3VlPyBJJ20gbm90IGEga2VybmVsIGRldmVsb3Bl
ciwganVzdCBhIHVzZXIsIGJ1dCBJIGd1ZXNzIHdpdGggcHJvcGVyIA0KaW5zdHJ1Y3Rpb24g
SSB3b3VsZCBiZSBhYmxlIHRvIGNvbXBpbGUgYW5kIHRlc3QgcGF0Y2hlcy4NCg0KQmVzdGUg
R3LDvMOfZSwNClBldGVyIFNjaG5laWRlcg0KDQotLSANCkNsaW1iIHRoZSBtb3VudGFpbiBu
b3QgdG8gcGxhbnQgeW91ciBmbGFnLCBidXQgdG8gZW1icmFjZSB0aGUgY2hhbGxlbmdlLA0K
ZW5qb3kgdGhlIGFpciBhbmQgYmVob2xkIHRoZSB2aWV3LiBDbGltYiBpdCBzbyB5b3UgY2Fu
IHNlZSB0aGUgd29ybGQsDQpub3Qgc28gdGhlIHdvcmxkIGNhbiBzZWUgeW91LiAgICAgICAg
ICAgICAgICAgICAgLS0gRGF2aWQgTWNDdWxsb3VnaCBKci4NCg0KT3BlblBHUDogIDB4QTM4
MjhCRDc5NkNDRTExQThDQURFODg2NkUzQTkyQzkyQzNGRjI0NA0KRG93bmxvYWQ6IGh0dHBz
Oi8vd3d3LnBldGVycy1uZXR6cGxhdHouZGUvZG93bmxvYWQvcHNjaG5laWRlcjE5NjhfcHVi
LmFzYw0KaHR0cHM6Ly9rZXlzLm1haWx2ZWxvcGUuY29tL3Brcy9sb29rdXA/b3A9Z2V0JnNl
YXJjaD1wc2NobmVpZGVyMTk2OEBnb29nbGVtYWlsLmNvbQ0KaHR0cHM6Ly9rZXlzLm1haWx2
ZWxvcGUuY29tL3Brcy9sb29rdXA/b3A9Z2V0JnNlYXJjaD1wc2NobmVpZGVyMTk2OEBnbWFp
bC5jb20NCg0KDQoNCg0KQW0gMDkuMDUuMjAyNCB1bSAwMzozOCBzY2hyaWViIE1hcnRpbiBL
LiBQZXRlcnNlbjoNCj4gDQo+IEhpIFBldGVyIQ0KPiANCj4gVGhhbmtzIGZvciB0aGUgZGV0
YWlsZWQgYnVnIHJlcG9ydC4NCj4gDQo+PiA2LjguOCsgICAgICAgICAgV09SS1MgICBSZXZl
cnQgInNjc2k6IGNvcmU6IENvbnN1bHQgc3VwcG9ydGVkIFZQRCBwYWdlDQo+PiBsaXN0IHBy
aW9yIHRvIGZldGNoaW5nIHBhZ2UiIC0gVGhpcyByZXZlcnRzIGNvbW1pdA0KPj4gYjVmYzA3
YTVmYjU2MjE2YTQ5ZTZjMWQwYjE3MmQ1NDY0ZDk5YTg5YiAodGhpcyBpcyB0aGUgZmlyc3Qg
YmFkIGNvbW1pdA0KPj4gb2YgbXkgYmlzZWN0IHNlc3Npb24sIHNlZSBiZWxvdywgYW5kIGEg
c2luZ2xlIHBhdGNoIGFzIHBhcnQgb2YgdGhlDQo+PiBhYm92ZSBtZXJnZWQgdGFnICdzY3Np
LWZpeGVzJykNCj4gDQo+IFRoZSBwdXp6bGluZyB0aGluZyBpcyB0aGF0IHRoZSBwYXRjaCBp
biBxdWVzdGlvbiByZXN0b3JlcyB0aGUgb3JpZ2luYWwNCj4gYmVoYXZpb3IgaW4gd2hpY2gg
d2UgZG8gbm90IGF0dGVtcHQgdG8gcXVlcnkgYW55IHBhZ2VzIG5vdCBleHBsaWNpdGx5DQo+
IHJlcG9ydGVkIGJ5IHRoZSBkZXZpY2UuDQo+IA0KPiBDYW4geW91IHBsZWFzZSBzZW5kIG1l
IHRoZSBvdXRwdXQgb2Y6DQo+IA0KPiAjIHNnX3ZwZCAtYSAvZGV2L3NkYQ0KPiAjIHNnX3Jl
YWRjYXAgLWwgL2Rldi9zZGENCj4gDQo+IHdoZXJlIHNkYSBpcyBvbmUgb2YgdGhlIGFhY3Jh
aWQgdm9sdW1lcy4NCj4gDQo+IFRoYW5rcyENCj4gDQo=

--------------XgrnrIbEqmkVi01629oNH2n6--

--------------3k07hvzCU80C7y4hrWzdZar0
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wnsEABYIACMWIQSjgovXlszhGoyt6IZuOpLJLD/yRAUCZkMNywUDAAAAAAAKCRBuOpLJLD/yRCwp
AQCQ7e+Eq4H8veOUlyQswf1miAnfnUuv6gJHx8fzCKZitgEA+ZQiQ7a7hoNcNvVQkvkExdTsC207
mtXOQ/byiSnliAc=
=WPgk
-----END PGP SIGNATURE-----

--------------3k07hvzCU80C7y4hrWzdZar0--
