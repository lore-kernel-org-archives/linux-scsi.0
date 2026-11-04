Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=81.169.146.164
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793823507;
	b=NykTua5tzXmDA8jkNY3+Cq6uuPL/qGc47T6lx6T+lRFRP5jOeOY4U5QwaTQ//t/nn0PU
	 Wj292lVulOo6V/JpA8LKNCga/mDJ9HfSaqRHHenK5cc8810t2epE8YHcpgl0sDfoT342O
	 pFunhBh1hOf3idAfc749WMZWKZm5rm96trBLjKGmMGtpUvLg/jFgRV9SxVFMDerTCjCZ+
	 5cgZgO3SjmF2aaA0G6L1Y44vxd+Ilyh8gFvFHKwYcbj6vx5JQFuCaECFxcf1ZUQUeLt+r
	 bCZ1Oc1UBsWLapzflQd0dYPpHzHUrFinX0DkVJkAYEJdbFyksby1+3D47Fv7mDPVuPw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793823507;
	h=DMARC-Filter:X-RZG-CLASS-ID:DKIM-Signature:DKIM-Signature:X-RZG-AUTH:
	 Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=eWatbsidhM8+RZoEGH8Yx69Y7BE5vGVsN2BWpIstpSI=;
	b=hSpyymx3dwsNzdWN7YKgmGTWw9xbE2QcXA2RRQnwGNWTfHlXmqSQfOZ/hfzxra9Ur6w+
	 gdkKmtVFdiwlDUUbWQ7BtYgHcvh73/xvHxjOzyRlCa8VAU9kQtFKyjDEKih26VS5Wsklr
	 kmjwAK4qErblzuXymZ7dUuDAQmtEwAlZKEFyk+q4ISHU5kWgnB5hOFB23E2etH/U1Q0zp
	 lQbX3wATQf7EVBwNcka3WekAm+Y8Ard4pvb/hH9+qCAAVjLTmvw8kYpWLwZiknAsuXS94
	 eAATZv3v/zsvozyQ/w7uw6XAhJ0ie5jzlvT6Ub9H7zYE2iZx02p8HW4VFJvguS/qlpg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=iokpp.de;
	spf=none smtp.mailfrom=iokpp.de;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=rsa-sha256 header.s=strato-dkim-0002 header.b=pgKawQmV;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=ed25519-sha256 header.s=strato-dkim-0003 header.b=2mW8lxf7;
	arc=pass header.oldest-pass=0 smtp.remote-ip=81.169.146.164
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.164])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C73FD606A330;
	Wed,  4 Nov 2026 20:18:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C73FD606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=iokpp.de header.i=@iokpp.de header.a=rsa-sha256 header.s=strato-dkim-0002 header.b=pgKawQmV;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=ed25519-sha256 header.s=strato-dkim-0003 header.b=2mW8lxf7
ARC-Seal: i=1; a=rsa-sha256; t=1793823479; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=kDQoDHrVRWb5adKHC2dQg+VChFn2e/y7i28IqhI961/W3gotkA5jXyTC61sxbH5Zhj
    dNKFBqgBKvV3lEeeVLgI/9ATBK9UZSDkPO0VzV2/yA9A9xmDzb3cV0xGjJDdNhXTEnoP
    QYVPPYDwnJyHZZbdo9q/hljE50fO3JcWCgHi+uxFVxG0yFLNqn8wEBRbvrnDUVa7UwDc
    NMHoKAcwTCHBrTP8sU3yUjog3i6Cfbnu7A2Z2/0ms3QEyScjx6fcdR+gDH/RODs2REvW
    uW4sqbwJD4O/seGYbSksNAnzw9hQQiBwBaQ2sSVv4VDkgmRW+yu3TQQdpPrP1lFpByQm
    xXnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1793823479;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=eWatbsidhM8+RZoEGH8Yx69Y7BE5vGVsN2BWpIstpSI=;
    b=n7p/43+Dm3gl8POl8fQmFHKKmmDuH0GHFBbRZuG+FO72yDwy+zYxXtRzyGAEzAJP1U
    eM8UF+6MlDwQ6AqxKLQ/XIzXD+o2PldLOzP6v26mZtjEmCiJrVYsDNGPIN4MC5u/D0P6
    kir3Zbn1Egsvj0l3uoXCJ9OanImRc1k+xUKfbjy+LgTydiHIFS3NT3KxqNfCImIznZjv
    CBiXzLajLxQcEnTLLq7mDw2uYeYKe44R6vBxxZO/2cbZ9yiotkAe9zUloeZGXsLxUCLD
    WzQqiQt7H423ULAv8HRUNMcbDz5xw+yd2Uphy5059HKq8cHSO5YpXmCnP+lynYwq7j8k
    3nsA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1793823479;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=eWatbsidhM8+RZoEGH8Yx69Y7BE5vGVsN2BWpIstpSI=;
    b=pgKawQmVuSYyecRwGo1LlvBEfazGdmQaKUgjPpB61VKUAaxIVCjaoTK9bmcmNCUcJY
    uNq0dV4ttljq9gulcOQ9yCwkLa7ToLQ9aPHL9ny6HCNNvt2ckievHKNWzyLdC5rcbiwn
    359zptcNdq1yJcJnUEeGYP9u5zmtauBsZ5xdH6UQW1zvsP2wwgQdh7yPzBl3CEYTHahF
    fzGz00pVVOt+f9XAF8uaaE4RNFafVWenHU5n910dtMsHJ9wxZEDnC0iJm//vOp56rbKe
    sewn+uFwCd8QdkFB6Lyjb8mheYLTkoce4NC2tQHd/HzvfNKcrVWwRWMtq9LaL/gsnMGB
    fXXg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1793823479;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=eWatbsidhM8+RZoEGH8Yx69Y7BE5vGVsN2BWpIstpSI=;
    b=2mW8lxf7bWbUvVCkulxv2dxUnJ8/vMy93TLzwr0JggRSQEJkrWgKZM4ES33xZowseK
    WUjJZN6oSuyTOmBREuCw==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0DpplXNpYf0i2235vA=="
Received: from [10.93.1.84]
    by smtp.strato.de (RZmta 55.6.3 AUTH)
    with ESMTPSA id z831ad2A4KHw1Xm
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Wed, 4 Nov 2026 21:17:58 +0100 (CET)
Message-ID: <41f787035d4a5d68b403bb0f443fe6ab533ff1ca.camel@iokpp.de>
Subject: Re: [PATCH v5 2/2] ufs: mcq: poll OCS after sq cleanup for device
 management commands
From: Bean Huo <beanhuo@iokpp.de>
To: Kiwoong Kim <kwmad.kim@samsung.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, alim.akhtar@samsung.com, jejb@linux.ibm.com, 
	martin.petersen@oracle.com, bvanassche@acm.org, kwangwon.min@samsung.com, 
	hy50.seo@samsung.com, cpgs@samsung.com, h10.kim@samsung.com
Cc: stable@vger.kernel.org, stanleyjhu@google.com
Date: Wed, 04 Nov 2026 21:17:58 +0100
In-Reply-To: <20261104094914.180788-3-kwmad.kim@samsung.com>
References: <20261104094914.180788-1-kwmad.kim@samsung.com>
	 <CGME20261104094925epcas2p1f25905de00c2548e1e1349fba5f18551@epcas2p1.samsung.com>
	 <20261104094914.180788-3-kwmad.kim@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.44.4-0ubuntu2.1 
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

T24gV2VkLCAyMDI2LTExLTA0IGF0IDE4OjQ5ICswOTAwLCBLaXdvb25nIEtpbSB3cm90ZToKPiBT
aWduZWQtb2ZmLWJ5OiBLaXdvb25nIEtpbSA8a3dtYWQua2ltQHNhbXN1bmcuY29tPgo+IC0tLQo+
IMKgZHJpdmVycy91ZnMvY29yZS91ZnMtbWNxLmMgfCAxOCArKysrKysrKysrKysrKysrKysKPiDC
oDEgZmlsZSBjaGFuZ2VkLCAxOCBpbnNlcnRpb25zKCspCj4gCj4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvdWZzL2NvcmUvdWZzLW1jcS5jIGIvZHJpdmVycy91ZnMvY29yZS91ZnMtbWNxLmMKPiBpbmRl
eCA4MTA2ZDU1ZjQwNDEuLjEwMDI5NWQwMmM2MiAxMDA2NDQKPiAtLS0gYS9kcml2ZXJzL3Vmcy9j
b3JlL3Vmcy1tY3EuYwo+ICsrKyBiL2RyaXZlcnMvdWZzL2NvcmUvdWZzLW1jcS5jCj4gQEAgLTYw
OSw2ICs2MDksMjQgQEAgaW50IHVmc2hjZF9tY3Ffc3FfY2xlYW51cChzdHJ1Y3QgdWZzX2hiYSAq
aGJhLCBpbnQKPiB0YXNrX3RhZykKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgX19mdW5jX18sIGlkLAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBGSUVMRF9HRVQoU1FfSUNVX0VSUl9DT0RFX01BU0ssIHJl
YWRsKHJlZykpKTsKPiDCoAo+ICvCoMKgwqDCoMKgwqDCoC8qCj4gK8KgwqDCoMKgwqDCoMKgICog
Rm9yIGRldmljZSBtYW5hZ2VtZW50IGNvbW1hbmRzLCB0aGVyZSBpcyBubyBvcmRlciBndWFyYW50
ZWVkCj4gYmV0d2Vlbgo+ICvCoMKgwqDCoMKgwqDCoCAqIE9DUyB1cGRhdGUgYW5kIENVUyB1cGRh
dGUsIHdoaWNoIGlzIHdoeSB3ZSBuZWVkIHRvIHdhaXQgaGVyZS4gU0NTSQo+ICvCoMKgwqDCoMKg
wqDCoCAqIGNvbW1hbmRzIGFyZSBleGNsdWRlZCBiZWNhdXNlIHRoZSBPQ1MgaW4gdGhlaXIgVVRS
RCBpcyBub3QgdXBkYXRlZAo+ICvCoMKgwqDCoMKgwqDCoCAqIGZyb20gdGhlIENRRS4KPiArwqDC
oMKgwqDCoMKgwqAgKi8KPiArwqDCoMKgwqDCoMKgwqBpZiAoIWVyciAmJiBibGtfbXFfaXNfcmVz
ZXJ2ZWRfcnEocnEpKSB7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGVudW0gdXRw
X29jcyBvY3M7Cj4gKwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBlcnIgPSByZWFk
X3BvbGxfdGltZW91dChSRUFEX09OQ0UsIG9jcywKCkJhcnQswqAKClJFQURfT05DRSgpIGlzIGVu
b3VnaCB0byByZWFkIE9DUywgYnV0IHRoZSBsb2NrIGFsc28gaXMgdG8gbWFrZSBzdXJlICAgCnVm
c2hjZF9jb21wbF9vbmVfY3FlKCkgaGFzIGZpbmlzaGVkPyAgdGhlIHdpbmRvdyBpcyB2ZXJ5IHNt
YWxsLCBhbmQgdGhlIGxvY2sKb25seSBjb3N0cyBzb21ldGhpbmcgb24gdGhpcyBlcnJvciBoYW5k
bGluZyBwYXRoLsKgCgp0ZWxsIG1lIGlmIEkgbWlzc2VkIHNvbWV0aGluZy4KCktpbmQgcmVnYXJk
cywgCkJlYW4KCgoKCg==

