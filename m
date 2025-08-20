Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D43D8239E7E;
	Wed, 20 Aug 2025 01:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755653936; cv=none; b=ONhmbX989dlBFInkTijOZeHE0n7G/nM7QmYZbya2gsPlctxrBJAY3hTR5u7sjVSDfDhDQKVUlsadMv/ZfPse7Fhg7R+biHYj795KBBB2Jhhiu14ux2/4OJNO5ByVhv6iZFjcTcK+MpaoMXSafms3yViTy8nrUYZ2btdf2x1JbL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755653936; c=relaxed/simple;
	bh=TAW7flq3odbpxOKxdegduWOQsDnkI26xnJjpizE46E8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID; b=ThY870gRRjqz5hvKmAJ5bMX3/E/U+0rGuNUihXVQZJHfy+iQyJo1FjTnJVzdd/frO1mY4DX5BA6WganM4RO8egVF9df1s47mF92I03y/+Qxtov05QLpN8EEHXY82uO3dMuXGj4fVg1x9XOVbH3KCc9wDPEPRP0AreG8cp9gnOp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=fail (1024-bit key) header.d=163.com header.i=@163.com header.b=HAEHZleU reason="signature verification failed"; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=163.com header.i=@163.com header.b="HAEHZleU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=X8n9XOhTr/5EqrhTQUQKFTnJVTGCwvmFcxw+kiU580Q=; b=H
	AEHZleUijo5bYPESCGarRZNzKU0FiEaqZQHUN19wiecE3iu4qwiO142rEPvkFg3c
	H+2XPdb/+rNs9d49QMA7U2XkP0LUt3R2HibiOhhVRTDm6nCF9xgtv8bx0k2r0NEi
	IEKhnx+gXyplKgfgkRGZogKYBa5Z6+pdyHyUTvAyJ4=
Received: from 00107082$163.com ( [111.35.190.191] ) by
 ajax-webmail-wmsvr-40-144 (Coremail) ; Wed, 20 Aug 2025 09:38:29 +0800
 (CST)
Date: Wed, 20 Aug 2025 09:38:29 +0800 (CST)
From: "David Wang" <00107082@163.com>
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: phil@philpotter.co.uk, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Subject: Re: [BUG] general protection fault when connecting an old mp3/usb
 device
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.14 build 20250519(9504565a)
 Copyright (c) 2002-2025 www.mailtech.cn 163com
In-Reply-To: <2899b7cb-106b-48dc-890f-9cc80f1d1f8b@acm.org>
References: <20250818095008.6473-1-00107082@163.com>
 <2899b7cb-106b-48dc-890f-9cc80f1d1f8b@acm.org>
X-NTES-SC: AL_Qu2eB/qevEEr7yOZZOkZnEYQheY4XMKyuPkg1YJXOp80tSbq/wsCW3BGO3/32cORCxGSvxeoVCJCxP9YUYNATrxSw802TTnFI3x3woSVGliG
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <35a7ef9b.1401.198c520ab44.Coremail.00107082@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:kCgvCgC3FuEWJ6Vot3UdAA--.6184W
X-CM-SenderInfo: qqqrilqqysqiywtou0bp/1tbiMxyuqmikxnzFMwADso
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==

CkF0IDIwMjUtMDgtMjAgMDM6MjA6NTEsICJCYXJ0IFZhbiBBc3NjaGUiIDxidmFuYXNzY2hlQGFj
bS5vcmc+IHdyb3RlOgo+T24gOC8xOC8yNSAyOjUwIEFNLCBEYXZpZCBXYW5nIHdyb3RlOgo+PiBb
U2F0IEF1ZyAyMyAwMzo1NjowOSAyMDI1XSBPb3BzOiBnZW5lcmFsIHByb3RlY3Rpb24gZmF1bHQs
IHByb2JhYmx5IGZvciBub24tY2Fub25pY2FsIGFkZHJlc3MgMHgyZTJlMmYyZTJlMmYzMDhlOiAw
MDAwIFsjMV0gU01QIE5PUFRJCj4+IFtTYXQgQXVnIDIzIDAzOjU2OjA5IDIwMjVdIENhbGwgVHJh
Y2U6Cj4+IFtTYXQgQXVnIDIzIDAzOjU2OjA5IDIwMjVdICA8VEFTSz4KPj4gW1NhdCBBdWcgMjMg
MDM6NTY6MDkgMjAyNV0gIHNyX2RvX2lvY3RsKzB4NWIvMHgxYzAgW3NyX21vZF0KPj4gW1NhdCBB
dWcgMjMgMDM6NTY6MDkgMjAyNV0gIHNyX3BhY2tldCsweDJjLzB4NTAgW3NyX21vZF0KPj4gW1Nh
dCBBdWcgMjMgMDM6NTY6MDkgMjAyNV0gIGNkcm9tX2dldF9kaXNjX2luZm8rMHg2MC8weGUwIFtj
ZHJvbV0KPj4gW1NhdCBBdWcgMjMgMDM6NTY6MDkgMjAyNV0gIGNkcm9tX21yd19leGl0KzB4Mjkv
MHhiMCBbY2Ryb21dCj4+IFtTYXQgQXVnIDIzIDAzOjU2OjA5IDIwMjVdICA/IHhhX2Rlc3Ryb3kr
MHhhYS8weDEyMAo+PiBbU2F0IEF1ZyAyMyAwMzo1NjowOSAyMDI1XSAgdW5yZWdpc3Rlcl9jZHJv
bSsweDc2LzB4YzAgW2Nkcm9tXQo+PiBbU2F0IEF1ZyAyMyAwMzo1NjowOSAyMDI1XSAgc3JfZnJl
ZV9kaXNrKzB4NDQvMHg1MCBbc3JfbW9kXQo+PiBbU2F0IEF1ZyAyMyAwMzo1NjowOSAyMDI1XSAg
ZGlza19yZWxlYXNlKzB4YjAvMHhlMAo+PiBbU2F0IEF1ZyAyMyAwMzo1NjowOSAyMDI1XSAgZGV2
aWNlX3JlbGVhc2UrMHgzNy8weDkwCj4+IFtTYXQgQXVnIDIzIDAzOjU2OjA5IDIwMjVdICBrb2Jq
ZWN0X3B1dCsweDhlLzB4MWQwCj4+IFtTYXQgQXVnIDIzIDAzOjU2OjA5IDIwMjVdICBibGtkZXZf
cmVsZWFzZSsweDExLzB4MjAKPj4gW1NhdCBBdWcgMjMgMDM6NTY6MDkgMjAyNV0gIF9fZnB1dCsw
eGUzLzB4MmEwCj4+IFtTYXQgQXVnIDIzIDAzOjU2OjA5IDIwMjVdICB0YXNrX3dvcmtfcnVuKzB4
NTkvMHg5MAo+PiBbU2F0IEF1ZyAyMyAwMzo1NjowOSAyMDI1XSAgZXhpdF90b191c2VyX21vZGVf
bG9vcCsweGQ2LzB4ZTAKPj4gW1NhdCBBdWcgMjMgMDM6NTY6MDkgMjAyNV0gIGRvX3N5c2NhbGxf
NjQrMHgxYzEvMHgxZTAKPj4gW1NhdCBBdWcgMjMgMDM6NTY6MDkgMjAyNV0gIGVudHJ5X1NZU0NB
TExfNjRfYWZ0ZXJfaHdmcmFtZSsweDc2LzB4N2UKPgo+UGhpbGxpcCwgaXMgdGhpcyBiZWhhdmlv
ciBwZXJoYXBzIGludHJvZHVjZWQgYnkgY29tbWl0IDVlYzlkMjZiNzhjNAo+KCJjZHJvbTogQ2Fs
bCBjZHJvbV9tcndfZXhpdCBmcm9tIGNkcm9tX3JlbGVhc2UgZnVuY3Rpb24iKT8gUGxlYXNlIGRv
CgpJIGNhdWdodCB0aGlzIG9uIDYuMTYuMCB3aGljaCBkb2VzIG5vdCBoYXZlIHRoaXMgY29tbWl0
LCBhbmQgb24gdGhlIGNvbnRyYXJ5LCBiYXNlCm9uIHRoZSBjb21taXQgbWVzc2FnZSwgdGhpcyBj
b21taXQgbWF5IGhlbHAgaW4gdGhlIHBvc2l0aXZlIGRpcmVjdGlvbi4KCkkgd2lsbCB0cnkgdG8g
ZmlndXJlIG91dCBhIHByb2NlZHVyZSB0byByZXByb2R1Y2UgdGhpcyBvbiBteSBsYXB0b3AsIGFu
ZCBpZiB0aGF0IHBvc3NpYmxlLApJIHdpbGwgdXBncmFkZSBteSBsYXB0b3AgdG8gNi4xNy1yYzEg
dG8gZ2l2ZSBpdCBhIHRyaWFsLgpBbmQgdXBkYXRlIGxhdGVyLgoKVGhhbmtzCkRhdmlkIAoKPm5v
dCBjYWxsIGNvZGUgdGhhdCBpbnZva2VzIGlvY3RscyBmcm9tIHRoZSBkaXNrX3JlbGVhc2UoKSBj
YWxsYmFjay4KPgo+VGhhbmtzLAo+Cj5CYXJ0Lgo=
