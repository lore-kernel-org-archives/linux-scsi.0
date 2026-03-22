Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [85.215.255.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8547363C4C;
	Sun, 22 Mar 2026 14:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774189954; cv=pass; b=QaTR/h60hu4VQM5/HMi86fpMlVxwlwdFMT9AGBl4sKjxu7g9ie5TAl2+hKCtSPu3bEDoiXSua4WL6ScVjTdF4QCjc4i8Pd3KwtrmAERK4eKw5RFiQi41qxk0Dax4CgqLLKXoONILfq6X/51JlE9osjvdz3V2dUeBNdkJu47IFfU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774189954; c=relaxed/simple;
	bh=5l729nS0YFNDB3fHMgEmFAmSpMdBzF8vWXtGimhx66o=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tV1WavPj840hZrt2i6NVPeVlPjVEjenS9aO/IgEyKhFothAvuA2WQYElfH3m5tAt4mR3cInOYfYeLSJVdohjqrreSD+oseHZdjGDKjdAC0K/XduiRvaVdsQJbsfzSedZndRJ6IfS9KItERXe0JjFdn7MsaRBOKbXV7hCiNAcIeQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=K5Ch7e1l; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=thQbkbgJ; arc=pass smtp.client-ip=85.215.255.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="K5Ch7e1l";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="thQbkbgJ"
ARC-Seal: i=1; a=rsa-sha256; t=1774189588; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=iPeOmyluq8MblkFmtyE/WsnfxpS2w20vpdvLreA5x7vi08hgVf/63yCKDJG50AcZuk
    PLXa6HdBft5g74IQfYUM7cMhzO6llxW3ukRMpWTGJSMbUJ8a6q81fRSDt9Wg3uKrLOMe
    g56kHgcd8BSpw1UUdjlEsQtuqaBJO1L5ovYgFUa9LL7VUt55oXJln6VUOrpH+5Qhm/K/
    elP9wkTDkuHbqOZTVDFA/T8vy007CxJaLVPl6rMWYAjuTLVE5C3HHAKgJPLuj32UJlYi
    HFZXWIy4dx3k8Joe7Hbjrwz+kJdnTEoQpwQfT1onfkWBSMxRl2/Y1nBaGN3mJtHrUYvQ
    680A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1774189588;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=5l729nS0YFNDB3fHMgEmFAmSpMdBzF8vWXtGimhx66o=;
    b=W/P22oQUm6/Mu702Wt+wsjR5Is930qQ0qhrCdL+WC7sVfgYriXDShDn/6KdRVrepOw
    d2E3h/DBJVuBLkFcdt+0GNpPiTeQdt9gDf/LG/vMJmxvyBBEOdxmAoz4eY5lZG47u0K+
    e3NTh1jLPNQ3kHTtsIetJeNZ0AANWhk9sg+gk39p6RscnBr7JMGtBrYGLXK0VC+m1+Ix
    YD9qdSeQzGfxoxxE2Vr3YDiAFT7kPMe7OY7nJdhwPPUsMnHDtZJjO0mRN42rIPBH4pUP
    Gx283hc48lwlZAWW8Xs5j/icneef7JxPdtRbeUA4OLg59kkfHv0x29UVDhfWDsxSyWyS
    7tvg==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1774189588;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=5l729nS0YFNDB3fHMgEmFAmSpMdBzF8vWXtGimhx66o=;
    b=K5Ch7e1lZWD8aL1vVHVYqXPUjHIwqXkYs313aNhzN+VO1LmKAlBIjDHIp5GJBV/ygx
    g3z5ulgHksveUhSmE6VZsEAnjkigBXwBneM81BkxI4ch/oZkbtRpJjPnGZBzb5kyR102
    jwYXs2oPd/sCRqMjsQ8kujHqw2zBezmkgPljx5NTCnd1mpYuc9B+MxoqN2Fw5k4umul8
    i5oyVukdj1OAKrsaxbNLrhc+1jvCUC9ZM+xpIiQJz5G5ZceLi78Xsx15k3ZlRUv+VLvZ
    oOqvSva0qnQaIY/YPTQh4/qC8JEfazZQwz4xcvSgFowxbZtpexdi4BgJ648s0q3yjTmO
    y/Eg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1774189588;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=5l729nS0YFNDB3fHMgEmFAmSpMdBzF8vWXtGimhx66o=;
    b=thQbkbgJIvw3RXZubBgrPew/ib0m+X9BVpNjaplKSZVJ0sL5zB3i3UQw/rTrFOqtYP
    DGuB8qyq4pRKObUwKyAw==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0zNriHg+YfT0rGeZpN+2uZ9u6NXwc+xxSp1B7gPOmqAfDJALLZE="
Received: from p200300c58739f14ca91b8693d570ac68.dip0.t-ipconnect.de
    by smtp.strato.de (RZmta 55.0.1 AUTH)
    with ESMTPSA id z7934522MEQRNxk
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Sun, 22 Mar 2026 15:26:27 +0100 (CET)
Message-ID: <652ce6ac83e1703b720a0402849e4d516abf0f25.camel@iokpp.de>
Subject: Re: [PATCH v4 04/12] scsi: ufs: core: Add support for TX
 Equalization
From: Bean Huo <beanhuo@iokpp.de>
To: Can Guo <can.guo@oss.qualcomm.com>, avri.altman@wdc.com,
 bvanassche@acm.org,  beanhuo@micron.com, peter.wang@mediatek.com,
 martin.petersen@oracle.com,  mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Bao D.
 Nguyen" <quic_nguyenb@quicinc.com>, Adrian Hunter
 <adrian.hunter@intel.com>, open list <linux-kernel@vger.kernel.org>
Date: Sun, 22 Mar 2026 15:26:27 +0100
In-Reply-To: <69a998190901b3ec63899fd89de087db9f99382a.camel@iokpp.de>
References: <20260321031021.1722459-1-can.guo@oss.qualcomm.com>
	 <20260321031021.1722459-5-can.guo@oss.qualcomm.com>
	 <69a998190901b3ec63899fd89de087db9f99382a.camel@iokpp.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gU3VuLCAyMDI2LTAzLTIyIGF0IDEwOjQ4ICswMTAwLCBCZWFuIEh1byB3cm90ZToKPiA+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZGV2X2VycihoYmEt
PmRldiwgIkZhaWxlZCB0byB0cmFpbiBUWCBFcXVhbGl6YXRpb24KPiA+IGZvcgo+ID4gSFMtRyV1
LCBSYXRlLSVzOiAlZFxuIiwKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGdlYXIsIHVmc19oc19yYXRlX3RvX3N0cihyYXRl
KSwgcmV0KTsKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgcmV0dXJuIHJldDsKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB9Cj4gPiAr
Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgLyogTWFyayBUWCBFcXVhbGl6YXRp
b24gc2V0dGluZ3MgYXMgdmFsaWQgKi8KPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqBwYXJhbXMtPmlzX3ZhbGlkID0gdHJ1ZTsKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqBwYXJhbXMtPmlzX2FwcGxpZWQgPSBmYWxzZTsKPiAKPiBhZnRlciBlcXRyIGNvbXBsZXRl
cyBoZXJlLCB0aGUgdHJhaW5lZCBzZXR0aW5ncyBhcmUgb25seSBrZXB0IGluIG1lbW9yeS4gVUZT
Cj4gNS4wCj4gaW50cm9kdWNlZCBxVHhFUUduU2V0dGluZ3MgYW5kIHdUeEVRR25TZXR0aW5nc0V4
dCBhcyBwZXJzaXN0ZW50IGRldmljZQo+IGF0dHJpYnV0ZXMgZm9yIHN0b3Jpbmcgb3B0aW1hbCBU
WCBFUSByZXN1bHRzIGFjcm9zcyBwb3dlciBjeWNsZXMuIHNob3VsZCB3ZQo+IHdyaXRlIGJhY2sg
dG8gdGhlc2UgYXR0cmlidXRlcyBhZnRlciB0cmFpbmluZywgYW5kIHJlYWQgdGhlbSBvbiBuZXh0
IGJvb3QgdG8KPiBza2lwIEVRVFIgaWYgdmFsaWQgc2V0dGluZ3MgYWxyZWFkeSBleGlzdD8gVGhh
dCB3b3VsZCBzYXZlIHRoZSB0cmFpbmluZwo+IG92ZXJoZWFkCj4gb24gZXZlcnkgYm9vdD8KCgpJ
IHNhdyB5b3VyIG5leHQgc2VjdGlvbiBwcm9wZXJseSBwb3NpdGlvbnMgcVR4RVFHblNldHRpbmdz
L3dUeEVRR25TZXR0aW5nc0V4dApwZXJzaXN0ZW50IHN0b3JhZ2UgYXMgYSBmb2xsb3ctdXAgc2Vy
aWVzIGluIGNvdmVyLWxldHRlciwgeW91IGNhbiBpZ25vcmUgdGhpcywKbGV0J3MgYWRkcmVzcyBp
dCBuZXh0IGZvbGxvd2luZyBwYXRjaC4KCktpbmQgcmVnYXJkcywKQmVhbgogCj4gCj4gS2luZCBy
ZWdhcmRzLAo+IEJlYW4KCg==

