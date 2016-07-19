From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: Re: [PATCH 2/3] xen-scsiback: One function call less in
 scsiback_device_action() after error detection
Date: Tue, 19 Jul 2016 16:56:35 +0200
Message-ID: <8806e9cb-4200-8154-7914-6735805dfbe0@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net>
 <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6>
 <530A086E.8010901@users.sourceforge.net>
 <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>
 <530A72AA.3000601@users.sourceforge.net>
 <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
 <530B5FB6.6010207@users.sourceforge.net>
 <alpine.DEB.2.10.1402241710370.2074@hadrien>
 <530C5E18.1020800@users.sourceforge.net>
 <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <59e51c7d-f7bb-c55f-d2fe-06dccfef6a99@users.sourceforge.net>
 <87e55a72-71ad-d0a1-b936-12565bbc6508@users.sourceforge.net>
 <fb5824ad-fb09-e471-7dc4-3e32564cc334@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <xen-devel-bounces@lists.xen.org>
In-Reply-To: <fb5824ad-fb09-e471-7dc4-3e32564cc334@suse.com>
List-Unsubscribe: <https://lists.xen.org/cgi-bin/mailman/options/xen-devel>,
 <mailto:xen-devel-request@lists.xen.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xen.org>
List-Help: <mailto:xen-devel-request@lists.xen.org?subject=help>
List-Subscribe: <https://lists.xen.org/cgi-bin/mailman/listinfo/xen-devel>,
 <mailto:xen-devel-request@lists.xen.org?subject=subscribe>
Errors-To: xen-devel-bounces@lists.xen.org
Sender: "Xen-devel" <xen-devel-bounces@lists.xen.org>
To: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Cc: linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Julia Lawall <julia.lawall@lip6.fr>, David Vrabel <david.vrabel@citrix.com>, xen-devel@lists.xenproject.org, Boris Ostrovsky <boris.ostrovsky@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Pj4gQEAgLTYwNiw3ICs2MDYsNyBAQCBzdGF0aWMgdm9pZCBzY3NpYmFja19kZXZpY2VfYWN0aW9u
KHN0cnVjdCB2c2NzaWJrX3BlbmQgKnBlbmRpbmdfcmVxLAo+PiAgCXRtciA9IGt6YWxsb2Moc2l6
ZW9mKHN0cnVjdCBzY3NpYmFja190bXIpLCBHRlBfS0VSTkVMKTsKPj4gIAlpZiAoIXRtcikgewo+
PiAgCQl0YXJnZXRfcHV0X3Nlc3NfY21kKHNlX2NtZCk7Cj4+IC0JCWdvdG8gZXJyOwo+PiArCQln
b3RvIGRvX3Jlc3A7Cj4+ICAJfQo+IAo+IEhtbSwgSSdtIG5vdCBjb252aW5jZWQgdGhpcyBpcyBh
biBpbXByb3ZlbWVudC4KPiAKPiBJJ2QgcmF0aGVyIHJlbmFtZSB0aGUgbmV3IGVycm9yIGxhYmVs
IHRvICJwdXRfY21kIiBhbmQgZ2V0IHJpZCBvZiB0aGUKPiBicmFjZXMgaW4gYWJvdmUgaWYgc3Rh
dGVtZW50Ogo+IAo+IC0JaWYgKCF0bXIpIHsKPiAtCQl0YXJnZXRfcHV0X3Nlc3NfY21kKHNlX2Nt
ZCk7Cj4gLQkJZ290byBlcnI7Cj4gLQl9Cj4gKwlpZiAoIXRtcikKPiArCQlnb3RvIHB1dF9jbWQ7
Cj4gCj4gYW5kIHRoZW4gaW4gdGhlIGVycm9yIHBhdGg6Cj4gCj4gLWVycjoKPiArcHV0X2NtZDoK
PiArCXRhcmdldF9wdXRfc2Vzc19jbWQoc2VfY21kKTsKCkkgYW0gdW5zdXJlIG9uIHRoZSByZWxl
dmFuY2Ugb2YgdGhpcyBmdW5jdGlvbiBvbiBzdWNoIGEgc291cmNlIHBvc2l0aW9uLgpXb3VsZCBp
dCBtYWtlIHNlbnNlIHRvIG1vdmUgaXQgZnVydGhlciBkb3duIGF0IHRoZSBlbmQ/CgoKPiArZnJl
ZV90bXI6Cj4gCWtmcmVlKHRtcik7CgpIb3cgZG8geW91IHRoaW5rIGFib3V0IHRvIHNraXAgdGhp
cyBmdW5jdGlvbiBjYWxsIGFmdGVyIGEgbWVtb3J5CmFsbG9jYXRpb24gZmFpbHVyZT8KClJlZ2Fy
ZHMsCk1hcmt1cwoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X18KWGVuLWRldmVsIG1haWxpbmcgbGlzdApYZW4tZGV2ZWxAbGlzdHMueGVuLm9yZwpodHRwczov
L2xpc3RzLnhlbi5vcmcveGVuLWRldmVsCg==
