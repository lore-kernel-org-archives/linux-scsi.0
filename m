From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] fix comment in scsi_host.h
Date: Wed, 26 May 2004 21:37:44 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0405262134400.4272-200000@poirot.grange>
References: <20040526114521.GA24166@infradead.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-812310198-1085600264=:4272"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imap.gmx.net ([213.165.64.20]:34481 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S265804AbUEZVKS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 May 2004 17:10:18 -0400
In-Reply-To: <20040526114521.GA24166@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Linux SCSI list <linux-scsi@vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
  Send mail to mime@docserver.cac.washington.edu for more info.

---1463811839-812310198-1085600264=:4272
Content-Type: TEXT/PLAIN; charset=US-ASCII

On Wed, 26 May 2004, Christoph Hellwig wrote:

> On Sun, May 23, 2004 at 11:19:58PM +0200, Guennadi Liakhovetski wrote:
> > diff -u -r1.1.1.3 scsi_host.h
...

> This looks okay, but can you please send it to the list as a separate patch?

Attached.

Thanks
Guennadi
---
Guennadi Liakhovetski


---1463811839-812310198-1085600264=:4272
Content-Type: TEXT/PLAIN; charset=US-ASCII; name="scsi_host.h.patch"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.44.0405262137440.4272@poirot.grange>
Content-Description: 
Content-Disposition: attachment; filename="scsi_host.h.patch"

ZGlmZiAtdSBhL2luY2x1ZGUvc2NzaS9zY3NpX2hvc3QuaCBiL2luY2x1ZGUv
c2NzaS9zY3NpX2hvc3QuaA0KLS0tIGEvaW5jbHVkZS9zY3NpL3Njc2lfaG9z
dC5oCTE5IE1heSAyMDA0IDE2OjA4OjQ5DQorKysgYi9pbmNsdWRlL3Njc2kv
c2NzaV9ob3N0LmgJMjMgTWF5IDIwMDQgMjA6MTg6MzENCkBAIC0xNTEsNyAr
MTUxLDcgQEANCiAJICogaGVyZSB0aGVuIHlvdSB3aWxsIGdldCBhIGNhbGwg
dG8gc2xhdmVfY29uZmlndXJlKCksIHRoZW4gdGhlDQogCSAqIGRldmljZSB3
aWxsIGJlIHVzZWQgZm9yIGhvd2V2ZXIgbG9uZyBpdCBpcyBrZXB0IGFyb3Vu
ZCwgdGhlbiB3aGVuDQogCSAqIHRoZSBkZXZpY2UgaXMgcmVtb3ZlZCBmcm9t
IHRoZSBzeXN0ZW0gKG9yICogcG9zc2libHkgYXQgcmVib290DQotCSAqIHRp
bWUpLCB5b3Ugd2lsbCB0aGVuIGdldCBhIGNhbGwgdG8gc2xhdmVfZGV0YWNo
KCkuICBUaGlzIGlzDQorCSAqIHRpbWUpLCB5b3Ugd2lsbCB0aGVuIGdldCBh
IGNhbGwgdG8gc2xhdmVfZGVzdHJveSgpLiAgVGhpcyBpcw0KIAkgKiBhc3N1
bWluZyB5b3UgaW1wbGVtZW50IHNsYXZlX2NvbmZpZ3VyZSBhbmQgc2xhdmVf
ZGVzdHJveS4NCiAJICogSG93ZXZlciwgaWYgeW91IGFsbG9jYXRlIG1lbW9y
eSBhbmQgaGFuZyBpdCBvZmYgdGhlIGRldmljZSBzdHJ1Y3QsDQogCSAqIHRo
ZW4geW91IG11c3QgaW1wbGVtZW50IHRoZSBzbGF2ZV9kZXN0cm95KCkgcm91
dGluZSBhdCBhIG1pbmltdW0NCkBAIC0xODUsNyArMTg1LDcgQEANCiAJICog
ICAgIHNwZWNpZmljIHNldHVwIGJhc2lzLi4uDQogCSAqIDYuICBSZXR1cm4g
MCBvbiBzdWNjZXNzLCBub24tMCBvbiBlcnJvci4gIFRoZSBkZXZpY2Ugd2ls
bCBiZSBtYXJrZWQNCiAJICogICAgIGFzIG9mZmxpbmUgb24gZXJyb3Igc28g
dGhhdCBubyBhY2Nlc3Mgd2lsbCBvY2N1ci4gIElmIHlvdSByZXR1cm4NCi0J
ICogICAgIG5vbi0wLCB5b3VyIHNsYXZlX2RldGFjaCByb3V0aW5lIHdpbGwg
bmV2ZXIgZ2V0IGNhbGxlZCBmb3IgdGhpcw0KKwkgKiAgICAgbm9uLTAsIHlv
dXIgc2xhdmVfZGVzdHJveSByb3V0aW5lIHdpbGwgbmV2ZXIgZ2V0IGNhbGxl
ZCBmb3IgdGhpcw0KIAkgKiAgICAgZGV2aWNlLCBzbyBkb24ndCBsZWF2ZSBh
bnkgbG9vc2UgbWVtb3J5IGhhbmdpbmcgYXJvdW5kLCBjbGVhbg0KIAkgKiAg
ICAgdXAgYWZ0ZXIgeW91cnNlbGYgYmVmb3JlIHJldHVybmluZyBub24tMA0K
IAkgKg0K
---1463811839-812310198-1085600264=:4272--
