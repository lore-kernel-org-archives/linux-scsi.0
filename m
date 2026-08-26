Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE3A45A287;
	Wed, 26 Aug 2026 20:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.165
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787777966; cv=pass; b=jBo5BwF8WHkFU0kpsuV6tNGx1xmHBrvq8JPsO22JExcJW160O666TM6gWKDV9WA6QT4fELNz7kG7MGRUWeKUnl8axd3mrBaBj9CwF59DhZhiNosm/IxMpfIu7BcIV+rLrpcFfjBmlZp0t3HnbcIwsyCsrWo5BBxhKvmI3dcgHS0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787777966; c=relaxed/simple;
	bh=7TimULhYK4Q/vDyDhA4QIg1dUsow0FpgWnuFD1qPrvw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JULe+ns4z0pmKoFMEO4sKOldZkMSyWbzj/tH2EXaAuowRfIaEmKvWtULN2sjVqvQhOnHpe5DXXftgBowCBA/wYoUS5y6QVbw3auZrL/k3GRsHm+xwbiuO/EP+2Wsd2WiS/F26afConxJWCPKQwseF6USPZ9PApnpO4ME900UD3w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=ouKJtkks; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=RNA4YzA0; arc=pass smtp.client-ip=81.169.146.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="ouKJtkks";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="RNA4YzA0"
ARC-Seal: i=1; a=rsa-sha256; t=1787777948; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=Hx3gHhNe5JnoZ0oHLDRpkwvyukEAbWIoeYD/SyWTo/QdJrO8/MuZh1uv5ucMzXBHxM
    K3z7odOPnQIiofYoRdyc1gmHHicN+2HQMBrJ8dTZwkJJ73BkNUeuBv/Qsy3auDo6cyrI
    YpAblI/IfcUlqI3sSA0Ny4dlYNIaPRQNeCCSj8aWC5JQVzyTCtK+Au1Apl422upIfCZQ
    S9txYWTruma3rCJ++IWMzDDEKyhDhdHHBbICWjVsmtAiYnzDHwZGgVCNDrLcALzMpsUA
    jOP8GiVdgL28c7XLjwbiP4xv84av3BuzvKBAn6QvAOFlIFd04ZrqPs+rSFuzwgIdYTUT
    gCEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1787777948;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=7TimULhYK4Q/vDyDhA4QIg1dUsow0FpgWnuFD1qPrvw=;
    b=ZKSLZN9BQWb8uRB8WGYbyRj6DctuOAP9/ZUdzttfxgHxN03OhnXpR8OsoRdw1keQpi
    TZR3UCEo6awPzy6nxjNx2BHKY6Q0TO2p2CJFO6r9QYLz5SBbQbGuA5sW3GcrHrOOvek9
    lGTrIqOxKRHsQGEGInUfr3wEm0jcOnv627zYpTFqTpMJcu7MaBnFxvq3A1gMt/ePGS/2
    MU5AEoyDUjf4658UB6FSHsn+bYf7U/eRPZTHQnsOgg0yUsopwmAHvvKuQKybcqFP57jO
    y1qDcNWxqqNrowtDrTRZF8d5oUZw4Z3HCKfv5OIibGzMmyhWBJrzWJpeaYsoHCtFnwDW
    DdqQ==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1787777948;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=7TimULhYK4Q/vDyDhA4QIg1dUsow0FpgWnuFD1qPrvw=;
    b=ouKJtkksG0W0UQN0fNCa/0uOUQXYyTnzO9+AWSDsBwa5z616OxNcAZluBGyq+0W9Ew
    ++MI7G//EAJYArAOZ7i1mtjS9V9Y11P70ZTXGXcpfbEzPzZJSYNAd2QDc/PxYJYI3WYg
    rjvFmS36XxjIZZvrXXMZ4Tmp1tbHBD6sHa7euUnokom55Bm5qQ2J7iWyBHX8o8C7KB6Y
    bDsC/OctzG1IfgUXPfkHphPfPIygU4a7OzQEXtXqKOQz4JLRg40gLemXXM2zipqNHPvO
    LkWAYUrBqmGSPlA281thprv+rVc+0/eI2j+jXq0yJzkg5g4xXcz3OSU9H38IK3tZrUKB
    LX9A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1787777948;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=7TimULhYK4Q/vDyDhA4QIg1dUsow0FpgWnuFD1qPrvw=;
    b=RNA4YzA0zmSJkdGF7xUN6nGBxQMMSklmB5HcVyP3ateEoLZh7DQOU+kRlAADOJK17p
    JZO9h7KgDr5R9pym0hBQ==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0zNriHg+YfT0rGaZpI+/4nexcz3kdO/c/hqkiDQr7/41mCC1SnA="
Received: from p200300c58729688cd608b20553b67495.dip0.t-ipconnect.de
    by smtp.strato.de (RZmta 55.6.2 AUTH)
    with ESMTPSA id ze37e127QKx7VEc
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Wed, 26 Aug 2026 22:59:07 +0200 (CEST)
Message-ID: <6ae9f526476cfce73c118c946f005753dd2d00b0.camel@iokpp.de>
Subject: Re: [PATCH v3 1/2] ufs: rpmb: retry power-on UNIT ATTENTION on the
 RPMB WLUN
From: Bean Huo <beanhuo@iokpp.de>
To: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>, 
	James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, 
	alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org, 
	beanhuo@micron.com, can.guo@oss.qualcomm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 op-tee@lists.trustedfirmware.org, jenswi@kernel.org,
 sumit.garg@oss.qualcomm.com
Date: Wed, 26 Aug 2026 22:59:07 +0200
In-Reply-To: <20260821150612.3944782-2-jorge.ramirez@oss.qualcomm.com>
References: <20260821150612.3944782-1-jorge.ramirez@oss.qualcomm.com>
	 <20260821150612.3944782-2-jorge.ramirez@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gRnJpLCAyMDI2LTA4LTIxIGF0IDE3OjA2ICswMjAwLCBKb3JnZSBSYW1pcmV6LU9ydGl6IHdy
b3RlOgo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Vmcy9jb3JlL3Vmcy1ycG1iLmMgYi9kcml2ZXJz
L3Vmcy9jb3JlL3Vmcy1ycG1iLmMKPiBpbmRleCBmZmFkMDQ5ODcyYjkuLmQwYzdlYTdhMzZmNCAx
MDA2NDQKPiAtLS0gYS9kcml2ZXJzL3Vmcy9jb3JlL3Vmcy1ycG1iLmMKPiArKysgYi9kcml2ZXJz
L3Vmcy9jb3JlL3Vmcy1ycG1iLmMKPiBAQCAtNDAsNiArNDAsMjMgQEAgc3RydWN0IHVmc19ycG1i
X2RldiB7Cj4gwqBzdGF0aWMgaW50IHVmc19zZWNfc3VibWl0KHN0cnVjdCB1ZnNfaGJhICpoYmEs
IHUxNiBzcHNwLCB2b2lkICpidWZmZXIsIHNpemVfdAo+IGxlbiwgYm9vbCBzZW5kKQo+IMKgewo+
IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3Qgc2NzaV9kZXZpY2UgKnNkZXYgPSBoYmEtPnVmc19ycG1i
X3dsdW47Cj4gK8KgwqDCoMKgwqDCoMKgLyogUmV0cnkgdGhlIHBvd2VyLW9uIFVOSVQgQVRURU5U
SU9OIChBU0MgMHgyOSk7IHRoZSBTQ1NJIGNvcmUgZG9lcwo+IG5vdC4gKi8KPiArwqDCoMKgwqDC
oMKgwqBzdHJ1Y3Qgc2NzaV9mYWlsdXJlIGZhaWx1cmVfZGVmc1tdID0gewo+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqB7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAuc2Vuc2UgPSBVTklUX0FUVEVOVElPTiwKPiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoC5hc2MgPSAweDI5LAo+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgLmFzY3EgPSBTQ01EX0ZBSUxVUkVf
QVNDUV9BTlksCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAuYWxsb3dlZCA9IDMsCgoKLmFsbG93ZWQgPSAzIGlzIGEgZmluZSB2YWx1ZSwgSSBjaGVja2Vk
IGNoLmMgKzE5NyB1c2VzIDMsIGFuZCBzZC5jIHVzZXMgNSwgc28gbm8KY29tcGxhaW50IGFib3V0
IHRoZSBudW1iZXIgaXRzZWxmLiBCdXQgdGhlIG90aGVyIGFzYyA9IDB4MjkgdXNlcnMgZ2l2ZSBp
dCBhCm1lYW5pbmdmdWwgbmFtZToKCmZvciBleGFtcGxlLCBzZXMuYyBoYXMgU0VTX1JFVFJJRVMg
YW5kIHNkLmMgaGFzIFJFQURfQ0FQQUNJVFlfUkVUUklFU19PTl9SRVNFVC4KYSBVRlNfUlBNQl9V
QV9SRVRSSUVTIChvciBvdGhlcikgd291bGQgbWF0Y2ggdGhhdCBtZWFuaW5nZnVsLgoKCm90aGVy
cyBsb29rIGdvb2QgdG8gbWUuCgpLaW5kIHJlZ2FyZHMsCkJlYW4KCg==

