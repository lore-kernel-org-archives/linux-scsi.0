Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792946408;
	b=GHKvuKupbFkrZVd96ldQhDb8GU0GxDme1HbkW2aLoctmtmcVKq30zTzVa9e5kyEyZ3Re
	 2YRozfBzi8XfNUpyu4OLPX68RvZYYeMsuindrPa8uJVDz0oW+b6dELoMn+9kWwcRmhcs8
	 idKPRXarqEom8bRuJ8cSB4IOUmxhsedbYqGYVHz7XGqiopJ+yJUavzC7tYCcIN5kpJ+Dm
	 Z6RYvFWJR+GEl6+0JqrvXa34IcrFggBopW8Fxy01rx9qEJrJ7gwktyEiFTtodT6sSRcjt
	 0PQsD3vzLSI0yYSh7vuFClTUpwxTEcHig7TvZ7KU+PEuOxJxYYK/IFgME3OHwGm3wnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792946408;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Content-Type:Message-ID:Date:MIME-Version:User-Agent:Subject:
	 To:Cc:References:Content-Language:From:In-Reply-To;
	bh=Uh/jV+RKdu40i5W3iEKoOk51H35K6TRUWCc2sdumjMw=;
	b=y1oSUw3/XTgYu2Vtw/6esFzjXkIna5iiIU8EmlxE+xIQ4l5OU3RE0uUjthC1caOINjiY
	 wGlgXPCoh3VpMMFPwL1e1rZN2MessJc+6tig7YVAG14W5kD/Ez72gaAfMphVTZ+XQBZe7
	 YWO7Q4/EdoPjcZ2ukA4psRWo+I/qAZiF4eE3mhTi7RIo7I2nQ3gYp/0fnjkvp+IwlVRbu
	 TKb3s00ieAvh8xZuJf8SHLo1c2DAbBN6teWWJQHHjIowHWT5HqmdaB2VuFrEwijsoLLmE
	 +nKG2A8CU6wQ7bPymL+8F9RpLUI5DC571A8lplRZgRMLJKV7UUbTz7mOQYltWPUaH4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=RFQh4fhu;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952F2606A31A;
	Sun, 25 Oct 2026 16:40:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 952F2606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=RFQh4fhu
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4jCMtb0MgWzlfvps;
	Sun, 25 Oct 2026 16:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	in-reply-to:from:from:content-language:references:subject
	:subject:user-agent:mime-version:date:date:message-id
	:content-type:content-type:received:received; s=mr01; t=
	1792946402; x=1795538403; bh=Uh/jV+RKdu40i5W3iEKoOk51H35K6TRUWCc
	2sdumjMw=; b=RFQh4fhuq4AoaRVGEDY8S6S9/iSNXg1uPbaStbtRKzLK62rvU/5
	kZEPMYs+Lt/mVqRVhKtSZp1haNTDQol4mGc+z5jmEt/DVDZKO7GAmeajsTZtqlEh
	RlcUmoZ0k62jJGWgqP/C+r+5ILKhpYXaemk0vEa+d7pW365W59vannmG59SnETNy
	IltqgGl3ppF0HZYmsqaOCxD0S9a6NbvwditXceYhxdHmU/kS9/eJIZfFdbt5Amoc
	G/27sDNcJPveruy0QnGCr4IMs3ncUr7r3Q9VvmEAadgjBUvgUasQe+M8xSFBvr02
	Pu62PmliHdA2TNfqhPMlCnb5c6g4hXpSP7Q==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id OvQEV815hSJE; Sun, 25 Oct 2026 16:40:02 +0000 (UTC)
Received: from [192.168.51.14] (c-24-6-239-25.hsd1.ca.comcast.net [24.6.239.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4jCMtV1NRszlfvpN;
	Sun, 25 Oct 2026 16:40:01 +0000 (UTC)
Content-Type: multipart/mixed; boundary="------------s8Ey6hFPBGWnSQfWbkDzsdy9"
Message-ID: <8a702a89-ad21-425e-9850-d9771fcf7c31@acm.org>
Date: Sun, 25 Oct 2026 09:40:00 -0700
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] scsi: target: iscsi: fix stalled aborted WRITE
 commands
To: Laurence Oberman <loberman@redhat.com>, mkp@kernel.org
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
 mlombard@redhat.com, michael.christie@oracle.com,
 linux-kernel@vger.kernel.org
References: <20261016175351.126373-1-loberman@redhat.com>
 <60cf407142a0663a811a2ccd64cf387cb71808ab.camel@redhat.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <60cf407142a0663a811a2ccd64cf387cb71808ab.camel@redhat.com>

This is a multi-part message in MIME format.
--------------s8Ey6hFPBGWnSQfWbkDzsdy9
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/25/26 7:43 AM, Laurence Oberman wrote:
> Gentle ping:
Please take a look at the attached review report. The report has been
generated by an LLM. As known LLMs may make mistakes.

Bart.
--------------s8Ey6hFPBGWnSQfWbkDzsdy9
Content-Type: text/markdown; charset=UTF-8; name="review.md"
Content-Disposition: attachment; filename="review.md"
Content-Transfer-Encoding: base64

UmV2aWV3IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC8yMDI2MTAxNjE3NTM1MS4xMjYz
NzMtMS1sb2Jlcm1hbkByZWRoYXQuY29tLwoKSSd2ZSByZXZpZXdlZCB2MiBvZiBMYXVyZW5j
ZSBPYmVybWFuJ3MgdHdvLXBhdGNoIHNlcmllcyB0aGF0IGZpeGVzIHN0YWxsZWQgYWJvcnRl
ZCBpU0NTSSBXUklURSBjb21tYW5kcywgcGx1cyB0aGUgU2FzaGlrbyBib3QncyByZXZpZXcg
YW5kIHRoZSBhdXRob3IncyByZXBseS4gSSBjaGVja2VkIGl0IGFnYWluc3QgdGhlIGxvY2Fs
IHRyZWUsIHdoaWNoIGFscmVhZHkgY29udGFpbnMgdGhlIHByZXJlcXVpc2l0ZSBjb21taXQg
ZDU4NjlkYWU1MDgwLgoKKipPdmVyYWxsOioqIHRoZSBkaWFnbm9zaXMgZm9yIHBhdGNoIDEg
bG9va3MgcmlnaHQsIGFuZCB0aGUgImNsYWltIHRoZSBjb21wbGV0aW9uIG9uY2UiIGlkZWEg
aXMgcmVhc29uYWJsZS4gQnV0IHRoZSBjbGFpbSBpcyBvbmx5IGFwcGxpZWQgaW4gc29tZSBv
ZiB0aGUgcGxhY2VzIHRoYXQgY29tcGxldGUgYW4gYWJvcnRlZCBjb21tYW5kLiBTbyB0aGUg
ZG91YmxlLWNvbXBsZXRpb24gcHJvYmxlbSB0aGUgc2VyaWVzIGRlc2NyaWJlcyBpcyBvbmx5
IHBhcnRseSBmaXhlZCwgYW5kIHBhcnQgb2YgdGhhdCBwcm9ibGVtIHdhcyBpbnRyb2R1Y2Vk
IGJ5IGQ1ODY5ZGFlNTA4MCBpdHNlbGYuCgojIyBNYWluIGlzc3VlcwoKKioxLiBOb3QgZXZl
cnkgY29tcGxldGlvbiBzaXRlIHRha2VzIHRoZSBjbGFpbSwgYW5kIG9uZSBvZiB0aGUgZ2Fw
cyBpcyBhIHJlY2VudCByZWdyZXNzaW9uLioqCi0gQWZ0ZXIgZDU4NjlkYWU1MDgwLCBgX19p
c2NzaXRfY2hlY2tfZGF0YW91dF9oZHIoKWAgY2FsbHMgYHRhcmdldF9jb21wbGV0ZV9jbWQo
KWAgb24gYW4gYWJvcnRlZCBgVFJBTlNQT1JUX1dSSVRFX1BFTkRJTkdgIGNvbW1hbmQgd2l0
aG91dCB0YWtpbmcgdGhlIGNsYWltLgotIFdoZW4gdGhlIGFib3J0IGlzIHRoZSBhc3luY2hy
b25vdXMga2luZCAoYHRhcmdldF9jbWRfaW50ZXJydXB0ZWQoKWAg4oaSIGB0YXJnZXRfYWJv
cnRfd29ya2ApLCBgdF9zdGF0ZWAgaXMgbmV2ZXIgY2hhbmdlZC4gU28gaWYgdGhlIGNvbm5l
Y3Rpb24gZHJvcHMgYmVmb3JlIHRoZSBjb21tYW5kIGlzIGZyZWVkLCBgaXNjc2l0X3JlbGVh
c2VfY29tbWFuZHNfZnJvbV9jb25uKClgIGNvbXBsZXRlcyBpdCBhIHNlY29uZCB0aW1lLgot
IFRoYXQgc2Vjb25kIGNvbXBsZXRpb24gaXMgdGhlIHNhbWUgYElOSVRfV09SSygpYC9gcXVl
dWVfd29yaygpYCBvbiBhIHN0aWxsLXF1ZXVlZCBgc2VfY21kLT53b3JrYCB0aGF0IHRoZSBj
b3ZlciBsZXR0ZXIgZGVzY3JpYmVzIGFzIHRoZSBmYWlsdXJlIG9mIHRoZSBlYXJsaWVyIGF0
dGVtcHQuCi0gZDU4NjlkYWU1MDgwIGlzIG9ubHkgaW4gNy4zL3Njc2ktc3RhZ2luZyBzbyBm
YXIuIFRoZSBmaXggYmVsb25ncyBpbiB0aGlzIHNlcmllcywgd2l0aCBgRml4ZXM6IGQ1ODY5
ZGFlNTA4MGAsIG5vdCBpbiBhIGxhdGVyIGZvbGxvdy11cC4KLSBgaXNjc2l0X2NoZWNrX2Rh
dGFvdXRfcGF5bG9hZCgpYCDihpIgYERBVEFPVVRfU0VORF9UT19UUkFOU1BPUlRgIOKGkiBg
dGFyZ2V0X2V4ZWN1dGVfY21kKClgIGhhcyB0aGUgc2FtZSBwcm9ibGVtLiBJdCBpcyBvbGRl
ciAoaXQgZGF0ZXMgZnJvbSBlYTg3OTgxYTBlZTgpLCBidXQgb25jZSB0aGUgY2xhaW0gaGVs
cGVyIGV4aXN0cyBpdCBpcyBhIHR3by1saW5lIGNoYW5nZS4gUGxlYXNlIGluY2x1ZGUgaXQg
dG9vLgoKKioyLiBUaGUgYXV0aG9yJ3MgYW5zd2VyIHRvIFNhc2hpa28ncyBzZWNvbmQgcG9p
bnQgcmVsaWVzIG9uIHRoZSBnYXAgYWJvdmUuKioKLSBIZSBzYXlzIHRoYXQgaWYgYG91dHN0
YW5kaW5nX3IydHNgIGlzIHJlYWQgbG93LCAidGhlIGxhdGVyIGNvbXBsZXRpb24gaW4gYF9f
aXNjc2l0X2NoZWNrX2RhdGFvdXRfaGRyKClgIGJlY29tZXMgYSBuby1vcCIuIEluIHYyIHRo
YXQgcGF0aCBkb2VzIG5vdCBjaGVjayB0aGUgY2xhaW0sIHNvIHRoZSBzdGF0ZW1lbnQgaXMg
ZmFsc2UgYXMgcG9zdGVkLgotIFRoZSByYWNlIGl0c2VsZiBpcyB1bmxpa2VseTogYm90aCBh
Y2Nlc3NlcyBoYXBwZW4gb24gdGhlIHNhbWUgY29ubmVjdGlvbidzIFJYIHRocmVhZC4gVGhl
IG9ubHkgd3JpdGVycyBvbiBvdGhlciB0aHJlYWRzIGFyZSB0aGUgcXVldWUtZnVsbCByZXRy
eSAoYHFmX3dvcmtgKSBhbmQgdGhlIEVSTDIgdGFzay1yZWFzc2lnbiBjb2RlLgotIE9uY2Ug
aXNzdWUgMSBpcyBmaXhlZCwgdGhlIHJlYXNvbmluZyBob2xkcy4gVW50aWwgdGhlbiwgdGhl
IHJlcGx5IHNob3VsZCBub3QgYmUgYWNjZXB0ZWQgYXMgYSBqdXN0aWZpY2F0aW9uLgoKKioz
LiBDb25zaWRlciBhIGZpeCBpbiB0YXJnZXQgY29yZSBpbnN0ZWFkLioqCi0gVGhlIHJlYWwg
Y2F1c2UgaXMgdGhhdCBgdGFyZ2V0X2NtZF9pbnRlcnJ1cHRlZCgpYCBxdWV1ZXMgYHRhcmdl
dF9hYm9ydF93b3JrYCBidXQgcmVjb3JkcyBub3RoaW5nIHVuZGVyIGB0X3N0YXRlX2xvY2tg
LgotIEEgdGVzdC1hbmQtc2V0IGZsYWcgaW4gYHRyYW5zcG9ydF9zdGF0ZWAgdGhlcmUgKHdp
dGggYSBXQVJOIG9uIGEgc2Vjb25kIGNhbGwpIHdvdWxkIGNvdmVyIGV2ZXJ5IHNpdGUgaW4g
ZXZlcnkgZmFicmljLCBpbmNsdWRpbmcgaVNFUiBhbmQgY3hnYml0LCB3aGljaCBhbHNvIHJl
YWNoIGBpc2NzaXRfY2hlY2tfZGF0YW91dF9wYXlsb2FkKClgLgotIFRoYXQgd291bGQgYmUg
YmV0dGVyIHRoYW4gYSBwcml2YXRlIGlTQ1NJIGZsYWcgdGhhdCBlYWNoIGNhbGwgc2l0ZSBo
YXMgdG8gcmVtZW1iZXIgdG8gY2hlY2suIEF0IHRoZSB2ZXJ5IGxlYXN0LCB0aGUgYXV0aG9y
IHNob3VsZCBzYXkgd2h5IGhlIGNob3NlIG5vdCB0byBkbyB0aGlzLgoKIyMgU21hbGxlciBw
b2ludHMKCi0gKipNaXNzaW5nIGBGaXhlczpgIGFuZCBgQ2M6IHN0YWJsZWAgdGFncyoqIG9u
IHBhdGNoIDEuIENhbmRpZGF0ZXMgYXJlIGVhODc5ODFhMGVlOCAoInNjc2k6IHRhcmdldDog
aXNjc2k6IEhhbmRsZSBhYm9ydCBmb3IgV1JJVEVfUEVORElORyBjbWRzIikgYW5kIGFhYTAw
Y2M5M2MxZCwgd2hpY2ggYWRkZWQgdGhlIGJhcmUgYHJldHVybiAwYCBpbiBgaXNjc2l0X2V4
ZWN1dGVfY21kKClgLiBOb3RlIHRoYXQgYWFhMDBjYzkzYzFkIGlzIHlvdXIgb3duIDIwMTgg
VEFTIGNoYW5nZS4KLSAqKkNvbW1pdCBtZXNzYWdlIGZvciBwYXRjaCAyOioqICJVbmxpa2Ug
cGF0Y2ggMSBvZiB0aGlzIHNlcmllc+KApiIgYW5kIHRoZSBwYXJhZ3JhcGggYWJvdXQgd2hh
dCB3YXMgc2VlbiBpbiB0aGUgZmllbGQgc2hvdWxkIG5vdCBlbmQgdXAgaW4gZ2l0IGhpc3Rv
cnkuIE1vdmUgdGhlbSBiZWxvdyB0aGUgYC0tLWAgbGluZSBvciBpbnRvIHRoZSBjb3ZlciBs
ZXR0ZXIuCi0gKipDb21tZW50IGluIGBpc2NzaV90YXJnZXRfY29yZS5oYDoqKiBpdCBzYXlz
IGBjb21wbGV0aW9uX2NsYWltZWRgIGlzIHNldCAib25jZSB0aGUgZmFicmljIGhhcyBjYWxs
ZWQgYHRhcmdldF9jb21wbGV0ZV9jbWQoKWAiLiBJdCBpcyBhY3R1YWxseSBzZXQgYmVmb3Jl
IHRoZSBjYWxsLiBSZXdvcmQgaXQgdG8gImhhcyBjbGFpbWVkIHRoZSBjb21wbGV0aW9uIi4K
LSAqKlBhdGNoIDIgaXMgdW50ZXN0ZWQgYnkgdGhlIGF1dGhvcidzIG93biBhY2NvdW50Lioq
IEl0IGxvb2tzIGNvcnJlY3QgdG8gbWUsIGluY2x1ZGluZyB0aGUgYGlzY3NpdF9zdG9wX2Rh
dGFvdXRfdGltZXIoKWAgY2FsbCwgd2hpY2ggbWF0dGVycyBvbiB0aGlzIHBhdGguIEFzayBm
b3IgYXQgbGVhc3QgYSBmYXVsdC1pbmplY3Rpb24gdGVzdCwgb3IgYSB0ZXN0IHdpdGggYE1h
eE91dHN0YW5kaW5nUjJUID4gMWAsIGJlZm9yZSB0YWtpbmcgaXQuCi0gKipUZXN0aW5nIHdh
cyBvbiBhIDUuMTQtYmFzZWQgZGlzdHJvIGJhY2twb3J0LioqIEFzayBmb3IgYSBydW4gb24g
dXBzdHJlYW0gKDcuMy1yYyBwbHVzIHNjc2ktc3RhZ2luZykgYXMgd2VsbC4KLSAqKk5pdDoq
KiB0aGUgdW5sb2NrZWQgYHRyYW5zcG9ydF9zdGF0ZSAmIENNRF9UX0FCT1JURURgIHJlYWRz
IGluIGBpc2NzaXRfZXhlY3V0ZV9jbWQoKWAgc2hvdWxkIHVzZSBgUkVBRF9PTkNFKClgLiBU
aGlzIHByZWRhdGVzIHRoZSBzZXJpZXMuCgojIyBTdWdnZXN0ZWQgdmVyZGljdAoKQXNrIGZv
ciBhIHYzIHRoYXQ6Ci0gc2VuZHMgZXZlcnkgY29tcGxldGlvbiBvZiBhbiBhYm9ydGVkIFdS
SVRFX1BFTkRJTkcgY29tbWFuZCB0aHJvdWdoIGBpc2NzaXRfY29tcGxldGVfYWJvcnRlZF9j
bWQoKWAsIGluY2x1ZGluZyB0aGUgZDU4NjlkYWU1MDgwIHNpdGUgYW5kIGBEQVRBT1VUX1NF
TkRfVE9fVFJBTlNQT1JUYCwgb3IgZWxzZSBtb3ZlcyB0aGUgb25lLXNob3QgZ3VhcmQgaW50
byB0YXJnZXQgY29yZTsKLSBhZGRzIHRoZSBgRml4ZXM6YC9zdGFibGUgdGFnczsKLSBjbGVh
bnMgdXAgdGhlIGNvbW1pdCBtZXNzYWdlIGZvciBwYXRjaCAyLgoKUGF0Y2ggMSdzIGNvcmUg
Y2hhbmdlIChjb21wbGV0aW5nIHRoZSBjb21tYW5kIGluc3RlYWQgb2YgcmV0dXJuaW5nIHdo
ZW4gbm8gUjJUIGhhcyBiZWVuIHNlbnQgeWV0KSBpcyBmaW5lIG9uIGl0cyBvd24gbWVyaXRz
Lgo=

--------------s8Ey6hFPBGWnSQfWbkDzsdy9--
