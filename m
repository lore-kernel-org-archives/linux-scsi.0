Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 207752FDC27;
	Sun, 22 Mar 2026 13:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774186625; cv=pass; b=WRmlUIkeVa7cTF99Wv84LevH7XbpfvEcDbi8qw3YbZkOl122VBuFVUHuRR0d/UNCGktAqcCCJgHRwno1AxumK38LxjgjEkwNtPOWZ79sAtYYYe3827/LPM12Lq5oV9w9dsUE4q1KYuKi211CdSch7q2IRfCle/peqt68ELTf324=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774186625; c=relaxed/simple;
	bh=ACoy/jfrP+n+2iGlp5+L17flC1n89Wrs46GRKI62Wqo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=H11UDNeHwhb2KnXKFnbHEp0PY/4kOUPViVj44NZ5+IZSjMCExYoLGsRIXy005FPAQdGZ4HMQI2adtKXGUUCYxKsAwnZkW1fDaVREZMimQ5qib3Eftv005jGmeeKtRIbsSoGco6Kz5dWu/Ms6qOdbF8KAZSY5V43Q8v3BHpvfMgs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=TtTlkb8/; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=fBik3YA+; arc=pass smtp.client-ip=85.215.255.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="TtTlkb8/";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="fBik3YA+"
ARC-Seal: i=1; a=rsa-sha256; t=1774186595; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=AHpq40x9KKnQDgerLZwpXdZ9/EFpVpqKfJTJ5YHuIqESnbRTeYA5WoM+LmkPWxQTa2
    MpW+xD4orlN7TxQETy7gdcEf5SAyYBa5X94YmN2O7aNeqbY+WJzvMKWhnzZwpaG/jfPs
    8WUohQWEW/GHQXM05Q7mjgvummjnvI8u/mlFWug7pT+h/Cn/156KyHwg7OhjLmXIi+dO
    DZU7lWGbTFppEfOUGqOEv6JOsxWo1b7GCUcgcdUl4j9l1oV/ObBOjcwwzCSUuzX2OLBU
    mE39Tl+E/2CT81+mgZBctnnJjcp7VHuvOTfX1g0gVcMcUg3PJL6vqij7Sp2HFL7rFn9h
    T+rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1774186595;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=ACoy/jfrP+n+2iGlp5+L17flC1n89Wrs46GRKI62Wqo=;
    b=bO9hQ7Rzy6Z6xG/equv+1yKFBC4BneH6YA5LxolEESD3EgOMQRP0hiY3ixgpMbkAuf
    LX5od3fp1AemLgh/CzcP32zb1lLEN8R9/fmWiIvvPfKhJldKQxAXJo9Ip3W6+NLR/v2P
    IMedi6PsW28jMSUQkbjlCalIF/N0E7mEXk5Vldsb85vK3QO390IngQxK4IQwete0jtM6
    ySfXQ9CcRQiLMrode3pUaL2u80n+yYEBJDIT+iPrG3HgIhr6Fe/vRKyk0NUBzTvs3lkf
    0VpCnFzJ0Bf4z3sOz47BeBhqssw3zdC53G5vPEet1UDDm76ustqTXCUEpGOnVXz7w0dQ
    is6w==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1774186595;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=ACoy/jfrP+n+2iGlp5+L17flC1n89Wrs46GRKI62Wqo=;
    b=TtTlkb8/tALVFySBuwQPn9ETvSz+9eveveIpHMjg88/TPEfH1sQA7pFD3fYiS45Cy8
    AsfA/9H94IIStu6U/JNBYbc6y3dPjgJvK4WI1+f53hsrdr5sii/OgTE0cNfGl02j7oPA
    Tds/mH8iV1gDOXaIVdDE9lB+R9IZD+FqgEofJoFU+RqNSKMk+aiZc5O4BRwC/xIaIRGi
    7Loa2INxOpH6uuVsiV+G6Q7AbFbutjGueO5aPh3Q/0jAr49uDyGHHe9twUCQ7TOGes9+
    1AwRc1X53YoAvxk4gh7dJ+g5bnNSrPbLd9xeS7VTbFxKzz487g/1PqBzzwAFusjlZPJn
    U8ww==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1774186595;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=ACoy/jfrP+n+2iGlp5+L17flC1n89Wrs46GRKI62Wqo=;
    b=fBik3YA+achNC1HKy8OflFkBPvwvZHy78K2TX0qO6aKsTDXgYSWRU3FOsx4UgwZbYP
    93UkEL59Fo4CQlAenUBA==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0zNriHg+YfT0rGeZpN+2uZ9u6NXwc+xxSp1B7gPOmqAfDJALLZE="
Received: from p200300c58739f14ca91b8693d570ac68.dip0.t-ipconnect.de
    by smtp.strato.de (RZmta 55.0.1 AUTH)
    with ESMTPSA id z7934522MDaXNtH
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Sun, 22 Mar 2026 14:36:33 +0100 (CET)
Message-ID: <7ef32c7c4f9c2220b04e9d0ce55d45a7e3373da8.camel@iokpp.de>
Subject: Re: [PATCH v4 07/12] scsi: ufs: core: Add support to retrain TX
 Equalization via debugfs
From: Bean Huo <beanhuo@iokpp.de>
To: Can Guo <can.guo@oss.qualcomm.com>, avri.altman@wdc.com,
 bvanassche@acm.org,  beanhuo@micron.com, peter.wang@mediatek.com,
 martin.petersen@oracle.com,  mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Bao D.
 Nguyen" <quic_nguyenb@quicinc.com>, Adrian Hunter
 <adrian.hunter@intel.com>, open list <linux-kernel@vger.kernel.org>
Date: Sun, 22 Mar 2026 14:36:33 +0100
In-Reply-To: <20260321031021.1722459-8-can.guo@oss.qualcomm.com>
References: <20260321031021.1722459-1-can.guo@oss.qualcomm.com>
	 <20260321031021.1722459-8-can.guo@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gRnJpLCAyMDI2LTAzLTIwIGF0IDIwOjEwIC0wNzAwLCBDYW4gR3VvIHdyb3RlOgo+ICsvKioK
PiArICogdWZzaGNkX3JldHJhaW5fdHhfZXEgLSBSZXRyYWluIFRYIEVxdWFsaXphdGlvbiBhbmQg
YXBwbHkgbmV3IHNldHRpbmdzCj4gKyAqIEBoYmE6IHBlci1hZGFwdGVyIGluc3RhbmNlCj4gKyAq
IEBnZWFyOiB0YXJnZXQgSGlnaC1TcGVlZCAoSFMpIGdlYXIgZm9yIHJldHJhaW5pbmcKPiArICoK
PiArICogVGhpcyBmdW5jdGlvbiBpbml0aWF0ZXMgYSByZWZyZXNoIG9mIHRoZSBUWCBFcXVhbGl6
YXRpb24gc2V0dGluZ3MgZm9yIGEKPiArICogc3BlY2lmaWMgSFMgZ2Vhci4gSXQgc2NhbGVzIHRo
ZSBjbG9ja3MgdG8gbWF4aW11bSBmcmVxdWVuY3ksIG5lZ290aWF0ZXMKPiB0aGUKPiArICogcG93
ZXIgbW9kZSB3aXRoIHRoZSBkZXZpY2UsIHJldHJhaW5zIFRYIEVRIGFuZCBhcHBsaWVzIG5ldyBU
WCBFUSBzZXR0aW5ncwo+ICsgKiBieSBjb25kdWN0aW5nIGEgUG93ZXIgTW9kZSBjaGFuZ2UuCj4g
KyAqCj4gKyAqIFJldHVybnMgMCBvbiBzdWNjZXNzLCBub24temVybyBlcnJvciBjb2RlIG90aGVy
d2lzZQo+ICsgKi8KPiAraW50IHVmc2hjZF9yZXRyYWluX3R4X2VxKHN0cnVjdCB1ZnNfaGJhICpo
YmEsIHUzMiBnZWFyKQo+ICt7Cj4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IHVmc19wYV9sYXllcl9h
dHRyIG5ld19wd3JfaW5mbywgZmluYWxfcGFyYW1zID0ge307Cj4gK8KgwqDCoMKgwqDCoMKgaW50
IHJldDsKPiArCj4gK8KgwqDCoMKgwqDCoMKgaWYgKCF1ZnNoY2RfaXNfdHhfZXFfc3VwcG9ydGVk
KGhiYSkgfHwgIXVzZV9hZGFwdGl2ZV90eGVxKQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqByZXR1cm4gLUVPUE5PVFNVUFA7Cj4gKwo+ICvCoMKgwqDCoMKgwqDCoGlmIChnZWFyIDwg
YWRhcHRpdmVfdHhlcV9nZWFyKQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1
cm4gLUVSQU5HRTsKPiArCj4gK8KgwqDCoMKgwqDCoMKgdWZzaGNkX2hvbGQoaGJhKTsKPiArCj4g
K8KgwqDCoMKgwqDCoMKgcmV0ID0gdWZzaGNkX3BhdXNlX2NvbW1hbmRfcHJvY2Vzc2luZyhoYmEs
IDEgKiBVU0VDX1BFUl9TRUMpOwo+ICvCoMKgwqDCoMKgwqDCoGlmIChyZXQpIHsKPiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgdWZzaGNkX3JlbGVhc2UoaGJhKTsKPiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIHJldDsKPiArwqDCoMKgwqDCoMKgwqB9Cj4gKwo+
ICvCoMKgwqDCoMKgwqDCoC8qIHNjYWxlIHVwIGNsb2NrcyB0byBtYXggZnJlcXVlbmN5IGJlZm9y
ZSBUWCBFUVRSICovCj4gK8KgwqDCoMKgwqDCoMKgaWYgKHVmc2hjZF9pc19jbGtzY2FsaW5nX3N1
cHBvcnRlZChoYmEpKQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB1ZnNoY2Rfc2Nh
bGVfY2xrcyhoYmEsIFVMT05HX01BWCwgdHJ1ZSk7Cj4gKwo+ICvCoMKgwqDCoMKgwqDCoG5ld19w
d3JfaW5mbyA9IGhiYS0+cHdyX2luZm87Cj4gK8KgwqDCoMKgwqDCoMKgbmV3X3B3cl9pbmZvLmdl
YXJfdHggPSBnZWFyOwo+ICvCoMKgwqDCoMKgwqDCoG5ld19wd3JfaW5mby5nZWFyX3J4ID0gZ2Vh
cjsKPiArCj4gK8KgwqDCoMKgwqDCoMKgcmV0ID0gdWZzaGNkX3ZvcHNfbmVnb3RpYXRlX3B3cl9t
b2RlKGhiYSwgJm5ld19wd3JfaW5mbywKPiAmZmluYWxfcGFyYW1zKTsKPiArwqDCoMKgwqDCoMKg
wqBpZiAocmV0KQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBtZW1jcHkoJmZpbmFs
X3BhcmFtcywgJm5ld19wd3JfaW5mbywgc2l6ZW9mKGZpbmFsX3BhcmFtcykpOwo+ICsKPiArwqDC
oMKgwqDCoMKgwqBpZiAoZmluYWxfcGFyYW1zLmdlYXJfdHggIT0gZ2Vhcikgewo+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBkZXZfZXJyKGhiYS0+ZGV2LCAiTmVnb3RpYXRlZCBHZWFy
ICgldSkgZG9lcyBub3QgbWF0Y2ggdGFyZ2V0Cj4gR2VhciAoJXUpXG4iLAo+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZmluYWxfcGFyYW1zLmdlYXJfdHgs
IGdlYXIpO1wKCm1pZ2h0IGJlIHJldCA9IC1FSU5WQUw7IGJlZm9yZSBnb3RvPwoKCj4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGdvdG8gb3V0Owo+ICvCoMKgwqDCoMKgwqDCoH0KCg==

