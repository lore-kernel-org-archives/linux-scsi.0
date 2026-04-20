Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [85.215.255.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9C034A79E;
	Mon, 20 Apr 2026 22:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776724798; cv=pass; b=lcw992t1J72pZhXl43kYRvtOweQsGQ31lVx3II6l24ni+rvnmxoVApQcosUxA8Cn+0O7HQFmNPJPUALkkV9xSKYPAGdddBb17sD+uBpUD1Bi1SQHUMKG7UqKbq+PLmulfPaiZYx1o/qsuCGkhPMvWa9qiNcEb8LW+loL4I4SQEk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776724798; c=relaxed/simple;
	bh=oxERMiGKa7EHWFA9NVjXmcj0d7q4CjYl+D4accxGqpg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SV6mVLVHnVN/B5mvOVmYWvDb2XIBQdBaL01DNwiDtqPGgA7+xVuPmWZAda5ZHCGAVzTgpk8ynOdteDCdEsQ39tGeu5JNQIYB6P1xu9hV01UKOFSrpdcw4oejJCS66fZRLiJQGnahSsJG4A5XjHw1D4gJ1MDevX7AmCL5AfvCSic=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=T+vOEtp3; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=iB4vRxnX; arc=pass smtp.client-ip=85.215.255.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="T+vOEtp3";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="iB4vRxnX"
ARC-Seal: i=1; a=rsa-sha256; t=1776722995; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=i8+rPBdL2KVeAfZEPwkEv64Crn4AsOsBRVThHSTxjKuudtB9cJk00T8lYJiStoL6eb
    CvI2l+HCjNBRWlTcKYqrUn7UtEd3r/Z09THcVkzzxLOYreaFHgz9HtGGxvw2UgP7i7ik
    w8Rp6SNAJxUxEFFNwvlxNcWDmDlSarnoVMZKsIWDQDErl10y6fTAzYgKKGh34SvRZoGW
    dPOL4EOzX/Bg+fc+hPJ/4f/evRpiV2C6L0127x8aLacgNFg4GNZ+UN5AaJRJDQ7ljVex
    Lxg8sTY/v0l88hATnOpB32gqgFRWZO9FLGYmaiZyDEwNDW+lQ23I9B30hxXR58r3g8Tv
    8Wmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1776722995;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=oxERMiGKa7EHWFA9NVjXmcj0d7q4CjYl+D4accxGqpg=;
    b=ekTPEZhEe0aFgpr240wvU9J/qvMlzlTKcmXUZpFwZ+8rxDvsVfeRqz5C+4sO++d3dG
    iJn/1+hkSfHw32+gYdsdP+T5RJsIeB9W19ozx/vmkKZraCA6smdLLQHBHz3V+WKbzGBz
    N9d4+NZmgfFyTJfLO4eybs0VNKIkMrd6hD/iNKGIwnptENgM0w2mXXMfxYcpC4tEiEw6
    c/EGRzF4fRstjq/49YQW3A7fJSj/QmlB2LTpaUj8200p82L5GwrJ7GbYaXyjvXWyu3iz
    NVWEx8/66zhAQpRJSODPz+uwFH1QMfnPSjwCeWoHy9YXBlVEA73Sznaj2ZDkCynrLalA
    Oiaw==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1776722995;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=oxERMiGKa7EHWFA9NVjXmcj0d7q4CjYl+D4accxGqpg=;
    b=T+vOEtp3zj5XKOLPtGKOLeA1b36hDQZ6/eS4+3WLH1MeiTrSjfrsnLyxnkjMH1SBFc
    zU34gtulkPNeC7yiG80RzA6gpnzAHTIReSWDPbiHuZbkgL4jIPSUIfusXUqAp0IhFQ5Q
    v5HW1zyS3+drBW4UZHem+m5syA84D5bt0tIGCExPuwpjrPVTALSNQXR7Ipzpq3JAK5iQ
    js5KLk3oYAtjDP+FKOeH2MCTBbDAmr9vQFJHuQmqpumN0LtYgclB5184JSGEA5Vng14b
    QccOkPXhl8BO9flTGmvWyV7m9gicQqX6HE59XrahA36/T1ADgE0seD/V/hyjFGlBQ59N
    9/Ww==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1776722995;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=oxERMiGKa7EHWFA9NVjXmcj0d7q4CjYl+D4accxGqpg=;
    b=iB4vRxnXnDe4iDGVvUoegSu7ibmnfci74n+549SRjeZnxsmzq8EaJQuDlM7M+VzwjH
    GbBGdzpxMmrJjK63p2Dg==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0zNriHg+YfT0rGTFpI237ww34p98HrQ21akkrKqnEi9NrkIp9jc="
Received: from p200300c5870e40f31240e069a136fb53.dip0.t-ipconnect.de
    by smtp.strato.de (RZmta 55.0.1 AUTH)
    with ESMTPSA id z7934523KM9sMTX
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Tue, 21 Apr 2026 00:09:54 +0200 (CEST)
Message-ID: <53a4d05bd15666583c1f59bff02786d320b3b1ce.camel@iokpp.de>
Subject: Re: [PATCH 2/2] scsi: ufs: core: Add support to retrieve and store
 TX Equalization settings
From: Bean Huo <beanhuo@iokpp.de>
To: Can Guo <can.guo@oss.qualcomm.com>, avri.altman@wdc.com,
 bvanassche@acm.org,  beanhuo@micron.com, peter.wang@mediatek.com,
 martin.petersen@oracle.com,  mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, vamshi
 gajjela <vamshigajjela@google.com>, "Rafael J. Wysocki"
 <rafael.j.wysocki@intel.com>, Adrian Hunter <adrian.hunter@intel.com>, open
 list <linux-kernel@vger.kernel.org>
Date: Tue, 21 Apr 2026 00:09:54 +0200
In-Reply-To: <20260419135229.1036926-3-can.guo@oss.qualcomm.com>
References: <20260419135229.1036926-1-can.guo@oss.qualcomm.com>
	 <20260419135229.1036926-3-can.guo@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Cj4gwqAvKiBXcmFwcGVyIGZ1bmN0aW9ucyBmb3Igc2FmZWx5IGNhbGxpbmcgdmFyaWFudCBvcGVy
YXRpb25zICovCj4gwqBzdGF0aWMgaW5saW5lIGNvbnN0IGNoYXIgKnVmc2hjZF9nZXRfdmFyX25h
bWUoc3RydWN0IHVmc19oYmEgKmhiYSkKPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91ZnMvY29yZS91
ZnNoY2QuYyBiL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMKPiBpbmRleCBlNWUyMmFkY2JiYzMu
LmJmNmRlYjM0YTVmZSAxMDA2NDQKPiAtLS0gYS9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jCj4g
KysrIGIvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYwo+IEBAIC05MTI4LDYgKzkxMjgsOCBAQCBz
dGF0aWMgaW50IHVmc2hjZF9kZXZpY2VfcGFyYW1zX2luaXQoc3RydWN0IHVmc19oYmEKPiAqaGJh
KQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZGV2X2VycihoYmEtPmRldiwKPiDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAiJXM6IEZhaWxl
ZCBnZXR0aW5nIG1heCBzdXBwb3J0ZWQgcG93ZXIgbW9kZVxuIiwKPiDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBfX2Z1bmNfXyk7Cj4gKwo+ICvCoMKgwqDC
oMKgwqDCoHVmc2hjZF9yZXRyaWV2ZV90eF9lcV9zZXR0aW5ncyhoYmEpOwoKbmVlZHMgdG8gY2hl
Y2sgd3NwZWN2ZXJzaW9uIGJlZm9yZSBjYWxsaW5nIGl0PwoKCgpLaW5kIHJlZ2FyZHMsCkJlYW4K


