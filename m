Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292DCBA53;
	Tue, 21 May 2024 13:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716298372; cv=none; b=Cfu2yI14FQelstRjQw/JsMU5c5bChew0zXgYcmtIr4iDwEs5YqpPsWLgr/Vf6vgCnB+8edxbXw+PfgOi57+5VSRhfrAs6UIK84ku2iJwIXHB4/jQyQnDpllvlMve4hxLX34/B7K11gl/cyY44hquU1xxqzzh0hZqZtFMLC0nh4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716298372; c=relaxed/simple;
	bh=z6T0HVhmc6PWWm4/WnvDPQF6G+tY1KmjDUmgWneQUgE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i7lD7mnnN18lDmZ3s6hY29yY2U73Xt3ECTMmozzB2Jnp64EIYHvUse2GGf5rf2Vj+oJIvw71VgoQV5a4a/BcQ/fLC7sSjTUME2lkpIvvQBzRD2qzQ4H24UYa6rmVJpkuwYgGkkLkFIf1M3LysmfcNNJXrsq9/8G2foQDztct8fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=IND5PBmT; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="IND5PBmT"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-571ba432477so9806646a12.1;
        Tue, 21 May 2024 06:32:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1716298369; x=1716903169; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:references:cc:to:content-language
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=z6T0HVhmc6PWWm4/WnvDPQF6G+tY1KmjDUmgWneQUgE=;
        b=IND5PBmTbMItrGnpmsqkhTWBMPxPtLjVi0ZvRRuqzx4ilezht7vYlnnvhILDD4ZKNt
         wrw3L6HgonTHcs6iFf6iageb0Uffr5WkHnO24xnE+ZE+AhPWbjiWjkdeh665rUej+/mI
         faSoM2ykyiMkCd3fEc89IE7pWj8Xtk+qy6fo/wDCGNUF/qMlQuiHXKGhJ36bDRuX2biM
         03j0uA1zfJnuRbpobn1JUjNn6f7ji/AOfH5f0mB1sAuiZ62cNB+jQQIcV0Gav4V38M/V
         UqgpjJTDyb6U/9V9pEB/g0pUYQ9ZeipBvsXBqvpmFESkOXgdPPz+Dra3yD3TZ3+Jc+YF
         1xRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716298369; x=1716903169;
        h=in-reply-to:autocrypt:from:references:cc:to:content-language
         :subject:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=z6T0HVhmc6PWWm4/WnvDPQF6G+tY1KmjDUmgWneQUgE=;
        b=qdwqKQQWtdWpPioFlgNL9k3tJnNQIvzFY+AME9cg8nRjDTe5qLEoizsV3KcLfwo5a9
         eIxnBflibLocucoirKnyCKJnBKuyBcMyqRvgWs2S7qhPzDU9rcOvpif5o/jxVZcXINgw
         TbiFA7agJqjMRoOYlrP4wZMsPng0iJvzbwX3XkRq3ZerPP8Q8xZo1DEOZI2BgVBlWtIT
         JxekxujEM4CBGAusuqR1H8IAJjsLRY94gKQvXhcxb8FihYWy8ti2Nu6R6ZXOIduoFypA
         LOR9NryP3o8XWpnQtEYwMJOsAM9YHPvOdVBGeeLN9fmliY0Fic6aBjw6aftl/zMgdHYa
         FWuQ==
X-Forwarded-Encrypted: i=1; AJvYcCULA54SHqOx2AMv47PnoiYqVC8I3LI/CwJnTE4tIHkpYN/W/BXbuA0CVr/cwknv86GwBBRMytiL4zEiK8izILgiCuUBfv9t8+Akag==
X-Gm-Message-State: AOJu0YwO96++R2aqPtY4mL1aMeGWRB2zGEHE6kBP045U5x1/ypRBteso
	wbWiHyGF11dTS+73GX2Tt+U62rN1GHHopM52t1jLQvIv/hSKRzFUHPW7lwI=
X-Google-Smtp-Source: AGHT+IEIYSQJt2GpOvAoo40guDZK1jBMVRKK1i2AjxZYjMkPMUY3ppOu7AVoGiFfoXAq21ViWLVT0g==
X-Received: by 2002:a05:6402:1a4d:b0:573:50d8:3fc0 with SMTP id 4fb4d7f45d1cf-57350d84107mr20881439a12.11.1716298369133;
        Tue, 21 May 2024 06:32:49 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4433.dip0.t-ipconnect.de. [91.43.68.51])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5733bea653bsm16892463a12.1.2024.05.21.06.32.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 May 2024 06:32:48 -0700 (PDT)
Message-ID: <d6e96532-4727-4c72-9b4b-0cf0bdbf7288@googlemail.com>
Date: Tue, 21 May 2024 15:32:47 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH] scsi: core: Handle devices which return an unusually
 large VPD page count
Content-Language: de-DE
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org
Cc: stable@vger.kernel.org
References: <eec6ebbf-061b-4a7b-96dc-ea748aa4d035@googlemail.com>
 <20240521023040.2703884-1-martin.petersen@oracle.com>
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
In-Reply-To: <20240521023040.2703884-1-martin.petersen@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------OQ9gyKzdROHjwZ1bm52jIPEM"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------OQ9gyKzdROHjwZ1bm52jIPEM
Content-Type: multipart/mixed; boundary="------------Vf0anrmFofT3GWNU6AlOh46d";
 protected-headers="v1"
From: Peter Schneider <pschneider1968@googlemail.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org
Cc: stable@vger.kernel.org
Message-ID: <d6e96532-4727-4c72-9b4b-0cf0bdbf7288@googlemail.com>
Subject: Re: [PATCH] scsi: core: Handle devices which return an unusually
 large VPD page count
References: <eec6ebbf-061b-4a7b-96dc-ea748aa4d035@googlemail.com>
 <20240521023040.2703884-1-martin.petersen@oracle.com>
In-Reply-To: <20240521023040.2703884-1-martin.petersen@oracle.com>

--------------Vf0anrmFofT3GWNU6AlOh46d
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

QW0gMjEuMDUuMjAyNCB1bSAwNDozMCBzY2hyaWViIE1hcnRpbiBLLiBQZXRlcnNlbjoNCiA+
IFBldGVyIFNjaG5laWRlciByZXBvcnRlZCB0aGF0IGEgc3lzdGVtIHdvdWxkIG5vIGxvbmdl
ciBib290IGFmdGVyDQogPiB1cGRhdGluZyB0byA2LjguNC4gIFBldGVyIGJpc2VjdGVkIHRo
ZSBpc3N1ZSBhbmQgaWRlbnRpZmllZCBjb21taXQNCiA+IGI1ZmMwN2E1ZmI1NiAoInNjc2k6
IGNvcmU6IENvbnN1bHQgc3VwcG9ydGVkIFZQRCBwYWdlIGxpc3QgcHJpb3IgdG8NCiA+IGZl
dGNoaW5nIHBhZ2UiKSBhcyBiZWluZyB0aGUgY3VscHJpdC4NCiA+DQogPiBUdXJucyBvdXQg
dGhlIGVuY2xvc3VyZSBkZXZpY2UgaW4gUGV0ZXIncyBzeXN0ZW0gcmVwb3J0cyBhIGJ5dGVz
d2FwcGVkDQogPiBwYWdlIGxlbmd0aCBmb3IgVlBEIHBhZ2UgMC4gSXQgcmVwb3J0cyAiMDIg
MDAiIGFzIHBhZ2UgbGVuZ3RoIGluc3RlYWQNCiA+IG9mICIwMCAwMiIuIFRoaXMgY2F1c2Vz
IHVzIHRvIGF0dGVtcHQgdG8gYWNjZXNzIDUxNiBieXRlcyAocGFnZSBsZW5ndGgNCiA+ICsg
aGVhZGVyKSBvZiBpbmZvcm1hdGlvbiBkZXNwaXRlIG9ubHkgMiBwYWdlcyBiZWluZyBwcmVz
ZW50Lg0KID4NCiA+IExpbWl0IHRoZSBwYWdlIHNlYXJjaCBzY29wZSB0byB0aGUgc2l6ZSBv
ZiBvdXIgVlBEIGJ1ZmZlciB0byBndWFyZA0KID4gYWdhaW5zdCBkZXZpY2VzIHJldHVybmlu
ZyBhIGxhcmdlciBwYWdlIGNvdW50IHRoYW4gcmVxdWVzdGVkLg0KID4NCiA+IENjOiBzdGFi
bGVAdmdlci5rZXJuZWwub3JnDQogPiBSZXBvcnRlZC1ieTogUGV0ZXIgU2NobmVpZGVyIDxw
c2NobmVpZGVyMTk2OEBnb29nbGVtYWlsLmNvbT4NCiA+IFRlc3RlZC1ieTogUGV0ZXIgU2No
bmVpZGVyIDxwc2NobmVpZGVyMTk2OEBnb29nbGVtYWlsLmNvbT4NCiA+IEZpeGVzOiBiNWZj
MDdhNWZiNTYgKCJzY3NpOiBjb3JlOiBDb25zdWx0IHN1cHBvcnRlZCBWUEQgcGFnZSBsaXN0
IHByaW9yIHRvIGZldGNoaW5nIHBhZ2UiKQ0KID4gTGluazogaHR0cHM6Ly9sb3JlLmtlcm5l
bC5vcmcvYWxsL2VlYzZlYmJmLTA2MWItNGE3Yi05NmRjLWVhNzQ4YWE0ZDAzNUBnb29nbGVt
YWlsLmNvbS8NCiA+IFNpZ25lZC1vZmYtYnk6IE1hcnRpbiBLLiBQZXRlcnNlbiA8bWFydGlu
LnBldGVyc2VuQG9yYWNsZS5jb20+DQogPiAtLS0NCiA+ICAgZHJpdmVycy9zY3NpL3Njc2ku
YyB8IDcgKysrKysrKw0KID4gICAxIGZpbGUgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspDQog
Pg0KID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9zY3NpLmMgYi9kcml2ZXJzL3Njc2kv
c2NzaS5jDQogPiBpbmRleCAzZTBjMDM4MTI3N2EuLmYwNDY0ZGIzZjlkZSAxMDA2NDQNCiA+
IC0tLSBhL2RyaXZlcnMvc2NzaS9zY3NpLmMNCiA+ICsrKyBiL2RyaXZlcnMvc2NzaS9zY3Np
LmMNCiA+IEBAIC0zNTAsNiArMzUwLDEzIEBAIHN0YXRpYyBpbnQgc2NzaV9nZXRfdnBkX3Np
emUoc3RydWN0IHNjc2lfZGV2aWNlICpzZGV2LCB1OCBwYWdlKQ0KID4gICAJCWlmIChyZXN1
bHQgPCBTQ1NJX1ZQRF9IRUFERVJfU0laRSkNCiA+ICAgCQkJcmV0dXJuIDA7DQogPg0KID4g
KwkJaWYgKHJlc3VsdCA+IHNpemVvZih2cGQpKSB7DQogPiArCQkJZGV2X3dhcm5fb25jZSgm
c2Rldi0+c2Rldl9nZW5kZXYsDQogPiArCQkJCSAgICAgICIlczogbG9uZyBWUEQgcGFnZSAw
IGxlbmd0aDogJWQgYnl0ZXNcbiIsDQogPiArCQkJCSAgICAgIF9fZnVuY19fLCByZXN1bHQp
Ow0KID4gKwkJCXJlc3VsdCA9IHNpemVvZih2cGQpOw0KID4gKwkJfQ0KID4gKw0KID4gICAJ
CXJlc3VsdCAtPSBTQ1NJX1ZQRF9IRUFERVJfU0laRTsNCiA+ICAgCQlpZiAoIW1lbWNocigm
dnBkW1NDU0lfVlBEX0hFQURFUl9TSVpFXSwgcGFnZSwgcmVzdWx0KSkNCiA+ICAgCQkJcmV0
dXJuIDA7DQoNCg0KDQpJIGhhdmUgYnVpbHQgYW5kIHRlc3RlZCBNYXJ0aW4ncyBwYXRjaCBh
Z2FpbnN0IDYuOC40LCA2LjguMTAsIGFuZCA2LjkuMSwgYW5kIGl0IHdvcmtzIGZpbmUgDQph
bmQgZml4ZXMgbXkgaXNzdWUuDQoNClRlc3RlZC1ieTogUGV0ZXIgU2NobmVpZGVyIDxwc2No
bmVpZGVyMTk2OEBnb29nbGVtYWlsLmNvbT4NCg0KSW4gY2FzZSBhbnlib2R5IGVsc2UgaXMg
YWZmZWN0ZWQ6IFRoZSBlbmNsb3N1cmUgZGV2aWNlIGluIHF1ZXN0aW9uIHdpdGggdGhhdCBi
dWdneSANCmJlaGF2aW91ciBpcyB0aGF0IGluIGEgU3VwZXJtaWNybyA3NDVCVFEtUjkyMEIg
c2VydmVyIGNhc2luZywgd2l0aCBTQVMvU0FUQSBCYWNrcGxhbmUgDQoiNzQzwqBTQVPCoEJB
Q0tQTEFORcKgVy9BTUnCoE1HOTA3MiIsIE1HOTA3MiBiZWluZyB0aGUgY29udHJvbGxlciBj
aGlwIGJ5IEFtZXJpY2FuIE1lZ2F0cmVuZHMsIA0KSW5jLiBhY2NvcmRpbmcgdG8gdGhlIGRl
dmljZSBkb2N1bWVudGF0aW9uIHdoaWNoIGNhbiBiZSBmb3VuZCBoZXJlOg0KDQpodHRwczov
L3d3dy5zdXBlcm1pY3JvLmNvbS9kZS9wcm9kdWN0cy9jaGFzc2lzLzR1Lzc0NS9zYzc0NWJ0
cS1yOTIwYg0KDQoNCg0KQmVzdGUgR3LDvMOfZSwNClBldGVyIFNjaG5laWRlcg0KDQotLSAN
CkNsaW1iIHRoZSBtb3VudGFpbiBub3QgdG8gcGxhbnQgeW91ciBmbGFnLCBidXQgdG8gZW1i
cmFjZSB0aGUgY2hhbGxlbmdlLA0KZW5qb3kgdGhlIGFpciBhbmQgYmVob2xkIHRoZSB2aWV3
LiBDbGltYiBpdCBzbyB5b3UgY2FuIHNlZSB0aGUgd29ybGQsDQpub3Qgc28gdGhlIHdvcmxk
IGNhbiBzZWUgeW91LiAgICAgICAgICAgICAgICAgICAgLS0gRGF2aWQgTWNDdWxsb3VnaCBK
ci4NCg0KT3BlblBHUDogIDB4QTM4MjhCRDc5NkNDRTExQThDQURFODg2NkUzQTkyQzkyQzNG
RjI0NA0KRG93bmxvYWQ6IGh0dHBzOi8vd3d3LnBldGVycy1uZXR6cGxhdHouZGUvZG93bmxv
YWQvcHNjaG5laWRlcjE5NjhfcHViLmFzYw0KaHR0cHM6Ly9rZXlzLm1haWx2ZWxvcGUuY29t
L3Brcy9sb29rdXA/b3A9Z2V0JnNlYXJjaD1wc2NobmVpZGVyMTk2OEBnb29nbGVtYWlsLmNv
bQ0KaHR0cHM6Ly9rZXlzLm1haWx2ZWxvcGUuY29tL3Brcy9sb29rdXA/b3A9Z2V0JnNlYXJj
aD1wc2NobmVpZGVyMTk2OEBnbWFpbC5jb20NCg==

--------------Vf0anrmFofT3GWNU6AlOh46d--

--------------OQ9gyKzdROHjwZ1bm52jIPEM
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wnsEABYIACMWIQSjgovXlszhGoyt6IZuOpLJLD/yRAUCZkyifwUDAAAAAAAKCRBuOpLJLD/yRHn7
AP4otGQWvGg4JHdFd9LRpwhAkmxYeVHbFpQk1xB0brMhagD/XefSDLqgfPS0eCv9A+2829iG7LFK
Iw+PuLtqIkFIUQI=
=4AEU
-----END PGP SIGNATURE-----

--------------OQ9gyKzdROHjwZ1bm52jIPEM--
