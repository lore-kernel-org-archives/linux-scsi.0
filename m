Received: from gw.rozsnyo.com (gw.rozsnyo.com [77.240.102.234])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E00D1F61E
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jan 2024 22:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=77.240.102.234
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705443996; cv=none; b=fq7yMKaJc0XcvHPolBnWD8c8itQMjNXWjmU0r2HfwJ2BSz7LW7AirbEMCVc06/I++tFqprNfnmC//WQva5ea9XMCwzLA2y6TTNyP48ONztiTQO7nZxQpKUgcWeVDPhnM+p9H7smMS8F0p4CwmjQ+H6ANp8s2w2ZBFLcOWHZ89F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705443996; c=relaxed/simple;
	bh=dmyt4YPCc518S7nIuysuzL2FJtq+SwwVxu5mBFH0/VE=;
	h=Received:X-Virus-Scanned:Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:To:Content-Language:From:Subject:
	 Content-Type:Content-Transfer-Encoding; b=GDPfZ5Yscl42AsgQ5Xv5irxUg8HPaM8NoF3R5hSFDXlad+DRtDzXdP62lCeuqqteWp9uQ/OmJ8lwir6a3LBYUDixCC30WG0q0smFaaWS2g7ZX87cPUNumXdb9B7OZAB+UwoJjdeHiaXrjrWy7MWgorrgHjrVPASLHyQslNaRvUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rozsnyo.com; spf=pass smtp.mailfrom=rozsnyo.com; arc=none smtp.client-ip=77.240.102.234
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rozsnyo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rozsnyo.com
Received: from localhost (localhost [127.0.0.1])
	by gw.rozsnyo.com (Postfix) with ESMTP id 4B904115CC78
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jan 2024 23:19:12 +0100 (CET)
X-Virus-Scanned: amavisd-new at rozsnyo.com
Received: from gw.rozsnyo.com ([127.0.0.1])
	by localhost (hosting.rozsnyo.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7CN562TYv1SE for <linux-scsi@vger.kernel.org>;
	Tue, 16 Jan 2024 23:19:12 +0100 (CET)
Received: from [192.168.68.7] (gw.rozsnyo.com [77.240.102.234])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by gw.rozsnyo.com (Postfix) with ESMTPSA id D1B7B115CC70
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jan 2024 23:19:11 +0100 (CET)
Message-ID: <3a18893d-4a71-49e1-8eec-d1450291f0f3@rozsnyo.com>
Date: Tue, 16 Jan 2024 23:19:09 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: linux-scsi@vger.kernel.org
Content-Language: en-US
From: =?UTF-8?Q?Daniel_Rozsny=C3=B3?= <daniel@rozsnyo.com>
Subject: I/O tracing and access logging
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGVsbG8sDQoNCiDCoMKgIGNhbiB5b3UgcGxlYXNlIGFkdmljZSB3aGF0IHRvIHR1cm4gb24s
IG9yIHdoYXQgaXMgdGhlIGNvcnJlY3QgcGxhY2UgdG8gcHV0IHByaW50aydzIGluIG9yZGVy
IHRvIHRyYWNlIGFsbCB0aGUgYWNjZXNzIHRvIGEgU0FUQSBkcml2ZT8NCg0KIMKgwqAgSSB3
b3VsZCBkZWZpbml0ZWx5IHdhbnQgdGhlIGJsb2NrIGRhdGEgYW5kIHRoZWlyIGhlYWRlciAo
anVzdCBhbiBMQkEgYWRkcmVzcyArIHJlYWQvd3JpdGUpLCBhbmQgdGhlIHBpY2sgYWxzbyBv
dGhlciBzaWRlIGNoYW5uZWwgbGlrZSBhY2Nlc3NlcyAtIGxpa2Ugd2hhdCB0aGUgc21hcnRj
dGwgZG9lcy4gQmFzaWNhbGx5IGFsbCBvdXRib3VuZCByZXF1ZXN0cyB3aXRoIGRhdGEgYW5k
IGFsbCByZXNwb25zZXMgd2l0aCBkYXRhLiBJIGRvIG5vdCBjYXJlIGlmIGl0IGNvbWVzIGlu
IGZvcm0gb2YgaGV4ZHVtcCwgaSBjYW4gDQpkbyBkZWNvZGluZyBhbmQgYW5hbHlzaXMgaW4g
cG9zdCAvIG9mZmxpbmUuIFRoYXQgd291bGQgYmUgYW4gaW9jdGwsIHJpZ2h0Pw0KDQogwqDC
oCBUaGUgcHJlZmVycmVkIGxvY2F0aW9uIGlzIHJhdGhlciBvbiBrZXJuZWwgc2lkZSwgdW5k
ZXIgZnVsbCBjb250cm9sIG9mIG1pbmUgLSB1bmxlc3MgdGhlcmUgaXMgc29tZSBtYWdpYyBv
cHRpb24gZm9yIHN0cmFjZSwgdGhhdCB3b3VsZCBtYWtlIGl0IGVub3VnaCB2ZXJib3NlIHRv
IGhhdmUgYWxsIHRoZSBwaWVjZXMgZHVtcGVkLg0KDQogwqDCoCBJIHdhcyBob3BpbmcgdGhh
dCBzb21lIGRldmVsb3BlciBvcHRpb24gaW4gdGhlIFNDU0kgbGF5ZXIgbWlnaHQgYWxyZWFk
eSBkbyB0aGF0Lg0KDQoNCiDCoMKgIFRoZSBnb2FsIGhlcmUgaXMgdG8gc2VlIHdoYXQgYSBu
b24tc3RhbmRhcmQgZmlybXdhcmUgZmxhc2hpbmcgcHJvY2VzcyBsb29rcyBsaWtlIC0gdGhl
IHRvb2wgaW4gcXVlc3Rpb24gaXMgZm9yIGFuY2llbnQgU2FuZEZvcmNlIFNTRCdzIHRoYXQg
ZGllIGJlY2F1c2Ugb2YgcG9vciBmaXJtd2FyZSBkZXNpZ24uIFdoaWxlIEkgaGF2ZSBhIGJ1
bmNoIG9mIGdlbnVpbmUgU2FuZEZvcmNlIFNGLTIyODEgZXF1aXBwZWQgZHJpdmVzIHdoaWNo
IEkgd2FzIGFibGUgdG8gZml4LCB0aGUgcmVjZW50IGFjcXVpc2l0aW9uIG9mIA0KZG96ZW4g
SW50ZWwgMjUwMCBQcm8ncyBhbmQgYSBiaXQgb2Ygd29yayByZXZlYWxlZCB0aGF0IHRoZXkg
aGF2ZSBsaWNlbnNlZCB0aGUgY29udHJvbGxlciAtIGluY2x1ZGluZyBpdHMgYnVnZ3kgYmVo
YXZpb3IsIG1hcmtpbmcgaXQgQkYyOUFTNDFCQjAuIFRoZSBqdW1wZXIgb24gYm9hcmQgZGlk
IGJyaW5nIHRoZSBkcml2ZSBpbnRvIFNhZmVtb2RlIGFuZCByZXBvcnRpbmcgaXRzZWxmIGFz
IGEgMzJLaUIgZGV2aWNlIG5hbWVkIFNhbmRGb3JjZXsyMDAwMjYgLSBzbyBJIGFtIG5leHQg
dG8gdHJ5IHRvIHJlY292ZXJpbmcgdGhlc2UuDQoNCiDCoMKgIEFuZCB3aGlsZSBkb2luZyBz
bywgSSB3YW50IHRvIGtlZXAgdGhlIGNvbW11bmljYXRpb24gdHJhY2VzIGluIG9yZGVyIHRv
IGV2ZW50dWFsbHkgcmVwbGFjZSB0aGF0IG9ic2N1cmUgMzItYml0IHByb3ByaWV0YXJ5IHNv
ZnR3YXJlIHdpdGggbXkgb3duIHRvb2wgLSB0byByZXZpdmUgdGhlIGRyaXZlcyBtdWNoIG1v
cmUgZWFzaWx5IHdoZW4gdGhleSBmYWlsIGFnYWluLg0KDQogwqDCoCBZZXMsIHRoZSB3b3Js
ZCB3b3VsZCBiZSBuaWNlciBpZiB3ZSBnZXQgc3VjaCBmYWN0b3J5LXJlc2V0IC8gZmFjdG9y
eS1yZWNvdmVyeSB0b29scyBmb3IgZGVhZCBkcml2ZXMgZnJvbSBtYW51ZmFjdHVyZXJzIGJ1
dCAtIHdoYXQgd2UgY2FuIGRvLiBJIGFtIHdpbGxpbmcgdG8gc3BlbmQgc29tZSB0aW1lIG9u
IHRoaXMuDQoNCg0KVGhhbmtzLA0KDQpEYW5pZWwgUm96c255bw0KDQoNCg0K
