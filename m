Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=85.215.255.82
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793823622;
	b=j6B/X7F7ZPHV73qk507EnqjhlveOlCaw4XSmqH7U82gx2N2rlzYLJODbxyB46sqRT720
	 7KaQIwW2ToJ2SfsGyajPxBAFdsg+zyJwCN48/QKNtHiitSy3LHORbrud1cBrk+Qs4a3Nu
	 4xRwWpFwiktkLCuLs1qi1YL+WknUZi5205rpOhIUj1wHWHf6Aj58KpMBcZBwsMyrVB2T3
	 cuDdK4IUFmZAEIdIZpf9wvII7QEAlyX0zKlrX8VQG04P0FTiYSrlM+cAY///txsJ0ihR5
	 aNzyXumQzQTGfoocIdRrlYz8tlhYjNBbm6ySqGuS7hLlN2jLvaODe9H/q7ErRayi5HA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793823622;
	h=DMARC-Filter:X-RZG-CLASS-ID:DKIM-Signature:DKIM-Signature:X-RZG-AUTH:
	 Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=eWatbsidhM8+RZoEGH8Yx69Y7BE5vGVsN2BWpIstpSI=;
	b=AB9ZWdqTdZSCBbSXdNY/j4GwRWQ/2BZnxvsmrgXLlfj4cTuZohp0hcRtf0snGCtXM/eP
	 kQwjclXHj7OHYEt3dPjyysXzymnXUQRHvLlY31+Ph9RCNztXL+VP/o8zih1Lje4hDxYy9
	 adl6ZHRS9gu0l1EOMba7l/0DrkP3ZZYrO4c/spNNxbeG1LNbsuGXVupJ+HZaExET1tjfE
	 zLjHSstJj4h9Fc5Xdd+tkRi8KjH6JUr95LpDTgeQeZozZPy0w0/7aOV2kt5sd5w8moV0R
	 kfhPnyznynq56ZAntXt2OqvyI3DAmZkqx5TQ5Y5xFodocFMslQi4wFkOu7y4ijTP8NA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=iokpp.de;
	spf=none smtp.mailfrom=iokpp.de;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=rsa-sha256 header.s=strato-dkim-0002 header.b=SyXBDCFH;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=ed25519-sha256 header.s=strato-dkim-0003 header.b=f+Xehvpn;
	arc=pass header.oldest-pass=0 smtp.remote-ip=85.215.255.82
Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [85.215.255.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9F46070302;
	Wed,  4 Nov 2026 20:20:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9F9F46070302
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=iokpp.de header.i=@iokpp.de header.a=rsa-sha256 header.s=strato-dkim-0002 header.b=SyXBDCFH;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=ed25519-sha256 header.s=strato-dkim-0003 header.b=f+Xehvpn
ARC-Seal: i=1; a=rsa-sha256; t=1793823594; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=bUA5qHKWv+CU7CnwycwrlyekDd+YBEiWVmX+DUVcFu5u0AOv7s7YKT2LQlK78nWwin
    RdOHHBlO1lursyDbDwQp+n/lpyR1gyJj0uvfb5yAWvCFgM8T341XFWl9BKNW+4tvaBAH
    jEbdowB4D3IDaT/kzWp5yoYD2br8+LCHMbWnYS53la4XUw7/I+3tCQyAWKkunLHqkAsC
    0XAWSpqENJVWyINkhc6GrhMpAnOiRBMT7A731J7vCSDtIjlt2V9m1nS7qNbYYTcEg481
    I91ULyUG24Udu21jFWZt70cEZ6SBd/bkz4HtZ3/kVm4teNnNJ0cT32Nh4DG8WPY3UKz4
    N6Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1793823594;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=eWatbsidhM8+RZoEGH8Yx69Y7BE5vGVsN2BWpIstpSI=;
    b=AhA1dID1VZWzoqW0AGBtw+s2Xqlrwsi0pY2bfO+Ve6GsO6wR8N+jB3WZId07UW9Igg
    ZH7jXGlB8t5DRBDdLi+m+lhZhvHXqSjxaN6L5fehhqbGvEkWVkxo1lnhajlSJuEmJRcu
    J9N0ffU6LyBKxHgTXsLX7jpmjY5j4fIKFQwJOCxiX1LCNGu2xC3BOjM6KrR8kHtSw1Ha
    3en9JmCa11qmDbFV8nTc6fOClO8KTcEQ9mW2ypb8Z9E+QRSnL2GGdDhU1jmbF3rW63rq
    g30bTCBql930gF8Kuxibllnfu25a1SjJNSMDDm38kRmhp56G6S4gt6yttXWl2i1rD9kX
    ig/Q==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1793823594;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=eWatbsidhM8+RZoEGH8Yx69Y7BE5vGVsN2BWpIstpSI=;
    b=SyXBDCFH/2cixXKS96WSUv2N17PdAdcp2KxlDNE8B4SDL+jHziQ+b7tbokRsgTi1Pt
    RxVHlGNLMx/qEiqYg2nc5DIoIM89vI1aBGS/aOaX+pZVP05pH6C8jTaqseVt1gq1RxP+
    O3XehsDpopviA0WvUFnW+lAsa+y1JLUb62L5RY9KyqnyO5MkljEceFa3mIor1NUvoI7m
    L+V58hkOlD2BqiMlap74eATGW3iWYN2TzOPFjodl2DLHwJYatDsYedptT06p2+lzhVBp
    EDNuG8NN/BBTnuGNV2c+WXO+l+c/WPmaM+MaRNeI3aqrOr2g0UwTiPwGJqhZdJif9eH8
    ttdQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1793823594;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=eWatbsidhM8+RZoEGH8Yx69Y7BE5vGVsN2BWpIstpSI=;
    b=f+XehvpnTDe8xPswDvPvFc21a350TyMKzqbRQcURecDNK+CZksczVVhy9KRhYuCWFq
    yIU750hOCbQ9wZVse+BQ==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0DpplXNpYf0i2235vA=="
Received: from [10.93.1.84]
    by smtp.strato.de (RZmta 55.6.3 AUTH)
    with ESMTPSA id z831ad2A4KJr1Yl
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Wed, 4 Nov 2026 21:19:53 +0100 (CET)
Message-ID: <187fd663f0db83b29ab90acbe1d9e0b300eba5f3.camel@iokpp.de>
Subject: Re: [PATCH v5 2/2] ufs: mcq: poll OCS after sq cleanup for device
 management commands
From: Bean Huo <beanhuo@iokpp.de>
To: Kiwoong Kim <kwmad.kim@samsung.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, alim.akhtar@samsung.com, jejb@linux.ibm.com, 
	martin.petersen@oracle.com, bvanassche@acm.org, kwangwon.min@samsung.com, 
	hy50.seo@samsung.com, cpgs@samsung.com, h10.kim@samsung.com
Cc: stable@vger.kernel.org, stanleyjhu@google.com
Date: Wed, 04 Nov 2026 21:19:53 +0100
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

