Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA44525A2BB;
	Tue,  5 May 2026 06:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777963268; cv=pass; b=O/wEYY3/IqgSOsHT+EY/pRWbppm/o3Qz16MOvy5WwMOwroJZz9hF5qWCmJnPpYBsoqKAYTvSTGAGoiyzqj0j7h9TemYDTOruqTcm4Mjo31c5bNPd0scVO3G8i/U5NJPCclr0fMkrUJSBUUm+rAL/SOUARZ81ztGkXveVN7GCSh4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777963268; c=relaxed/simple;
	bh=zFc56DbKBHTaI214DNwM48EBJu18AiRX+KM8BLqrInI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=N+GhUqfduowpjZdWgjylkzJzt1i8PQbQ41beag6kHIZL14HkanWyYfYrlD1Et82aDEMJIamdSTXHQQBp+nk9z3tA6tf3G1rA84bbrSrq3fbZ82rtye2I1et2LuMOZR6WuI2UCI8kUhV41VNPkZ6Lwb3n1WFt6XmlgQq2e1J7BsA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=heO/T7KK; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=3Emi9gn3; arc=pass smtp.client-ip=85.215.255.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="heO/T7KK";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="3Emi9gn3"
ARC-Seal: i=1; a=rsa-sha256; t=1777963257; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=hihZWi5Y/ZUDh7Sk7ymhnV8reUuvMuMb7V/McGy2gyEWs593uLG3Hq4VwNl2Oq0Yn8
    9A2NDFWGx+rh8Xhp59q97BzPfOFWTc2jWyWyecZlOnbp6t5Axm1Gc4P8wHDXPIDCZaSf
    xWLxGPdRr1ZsslwATXbU3nRpvaH8grI70H3iZF6nIcOD603N1OZy3wWR/tGnpQ2AHngG
    yfhEWxTrCCEok0KgofJo21pHVI4FrbHrH1oh7ygmbRw1ejoh0oKN5BG2mCL/iTg2Noil
    7B88++uuyRD+QyjyIYQFmkk2ROe1k4HwkRwfgiSJ/s10OPxKVtv1SINnQ7FS3BtpwFSY
    POYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1777963257;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=zFc56DbKBHTaI214DNwM48EBJu18AiRX+KM8BLqrInI=;
    b=qdDZrxSD5rmeNQNV9X9yCwC6oH7YvUayfvNiDJL7ehkqqcQvS+8b5du0dBZ9xQlhCp
    ugi/BVL1xx7Ujs0CltscZAnHAQ1JZYiVNVvXi5sifTVoS9IzXZVCanM+lFwkq5tLyfxJ
    pr/DPvjG6IrAoVXu9eH6Ip4akR3GyLtLCI9f7Bu+kq9sa50191j2JmtF9bK1rCG0A7QX
    x6ZUw+mkTqVbngx0M7UJin3uiDYs2ArEZLFWkgioD5i0wpUN9Y59L4f3LGfObJ3+JJuD
    HD0RlI4wTnToNxTFVyzXThwcd+7ICddBzd0YTOpqbAqKIke7TZiUrnMvQcFRNwfBugET
    41yw==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1777963257;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=zFc56DbKBHTaI214DNwM48EBJu18AiRX+KM8BLqrInI=;
    b=heO/T7KKQBvJ6yDC1DFoWOg8r0HWrmlLDo+rHiYMvzVko8WWfe5YO0By6+bDrOj80k
    Vuu/HkENf4riA005p0tJoT19P99NYB0ooEuB1cirUyr1Yp//sRmStbyF/LFTkrCAqbqg
    4StXD82wn7LWvrZjogN42LfgtomIz86i//UbNCY5UzC7EJ0u2bzvAoSRooEBuBleshxa
    RpVZqM5WxSgVcF43ggfOuOvzd+sRO4Tru1XhyXaGhFXdOVts6hlj+YFExm/SvCt/nRSu
    yQkeqnZk+yvRrFh8ZEOdWRNs0JveIBIfsONOXdTaHEBhIDuWgaXqsOw9bVAXkOMfhUTC
    hH7A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1777963257;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=zFc56DbKBHTaI214DNwM48EBJu18AiRX+KM8BLqrInI=;
    b=3Emi9gn3qYWWa1SgMfzAIj4EXyt3nWC7B4eAlzGCfCl7QZyVQMk4ZCO3M4MFSi6IOq
    p2CW6IX/mfNGum2+0uAQ==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0DpulXBkei/nxYyYL8UZ"
Received: from [172.20.6.21]
    by smtp.strato.de (RZmta 55.0.1 AUTH)
    with ESMTPSA id z793452456euAZW
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Tue, 5 May 2026 08:40:56 +0200 (CEST)
Message-ID: <897db8bf4c82af97cd7bbb2b908bb9e2654b3103.camel@iokpp.de>
Subject: Re: [PATCH v5] scsi: ufs: core: call hibern8 notify when hibern8
 cmd failed
From: Bean Huo <beanhuo@iokpp.de>
To: Hongjie Fang <hongjiefang@asrmicro.com>, alim.akhtar@samsung.com, 
 avri.altman@wdc.com, bvanassche@acm.org,
 James.Bottomley@HansenPartnership.com,  martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 05 May 2026 08:40:55 +0200
In-Reply-To: <20260502143012.2859480-1-hongjiefang@asrmicro.com>
References: <20260502143012.2859480-1-hongjiefang@asrmicro.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gU2F0LCAyMDI2LTA1LTAyIGF0IDIyOjMwICswODAwLCBIb25namllIEZhbmcgd3JvdGU6Cj4g
K8KgwqDCoMKgwqDCoMKgZGVmYXVsdDoKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
YnJlYWs7Cj4gwqDCoMKgwqDCoMKgwqDCoH0KPiDCoAo+IMKgwqDCoMKgwqDCoMKgwqByZXR1cm4g
MDsKPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS91ZnMvdWZzaGNkLmggYi9pbmNsdWRlL3Vmcy91ZnNo
Y2QuaAo+IGluZGV4IDg1NjNiNjY0ODk3Ni4uNGY3YzYxOWRiMzI0IDEwMDY0NAo+IC0tLSBhL2lu
Y2x1ZGUvdWZzL3Vmc2hjZC5oCj4gKysrIGIvaW5jbHVkZS91ZnMvdWZzaGNkLmgKPiBAQCAtMjcw
LDYgKzI3MCw3IEBAIHN0cnVjdCB1ZnNfY2xrX2luZm8gewo+IMKgZW51bSB1ZnNfbm90aWZ5X2No
YW5nZV9zdGF0dXMgewo+IMKgwqDCoMKgwqDCoMKgwqBQUkVfQ0hBTkdFLAo+IMKgwqDCoMKgwqDC
oMKgwqBQT1NUX0NIQU5HRSwKPiArwqDCoMKgwqDCoMKgwqBST0xMQkFDS19DSEFOR0UsCj4gwqB9
Owo+IMKgCj4gwqBzdHJ1Y3QgdWZzX3BhX2xheWVyX2F0dHIgewo+IC0tCj4gMi4yNS4xCgpDb3Vs
ZCB5b3UgaW5jbHVkZSB0aGUgcGxhdGZvcm0gZHJpdmVyIHRoYXQgYWN0dWFsbHkgaGFuZGxlcyBS
T0xMQkFDS19DSEFOR0UgaW4KdGhpcyBzZXJpZXM/IEFkZGluZyAgdGhpcyBuZXcgcm9sbGJhY2tf
Y2hhbmdlIHdpdGhvdXQgYW4gdXNhZ2UgbWFrZXMgaXQgaGFyZCB0bwp2ZXJpZnkgdGhlIGRlc2ln
biBpcyBjb3JyZWN0LiAKCktpbmQgcmVnYXJkcywKQmVhbgo=

