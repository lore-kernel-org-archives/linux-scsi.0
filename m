From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: Re: [PATCH 2/3] xen-scsiback: One function call less in
 scsiback_device_action() after error detection
Date: Wed, 20 Jul 2016 07:10:24 +0200
Message-ID: <18256bfc-c6f9-8802-8d7d-55766f0b3624@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net>
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
 <8806e9cb-4200-8154-7914-6735805dfbe0@users.sourceforge.net>
 <83b0b1e2-900b-eefc-160b-7d837730571c@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <xen-devel-bounces@lists.xen.org>
In-Reply-To: <83b0b1e2-900b-eefc-160b-7d837730571c@suse.com>
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

Pj4+PiBAQCAtNjA2LDcgKzYwNiw3IEBAIHN0YXRpYyB2b2lkIHNjc2liYWNrX2RldmljZV9hY3Rp
b24oc3RydWN0IHZzY3NpYmtfcGVuZCAqcGVuZGluZ19yZXEsCj4+Pj4gIAl0bXIgPSBremFsbG9j
KHNpemVvZihzdHJ1Y3Qgc2NzaWJhY2tfdG1yKSwgR0ZQX0tFUk5FTCk7Cj4+Pj4gIAlpZiAoIXRt
cikgewo+Pj4+ICAJCXRhcmdldF9wdXRfc2Vzc19jbWQoc2VfY21kKTsKPj4+PiAtCQlnb3RvIGVy
cjsKPj4+PiArCQlnb3RvIGRvX3Jlc3A7Cj4+Pj4gIAl9Cj4+Pgo+Pj4gSG1tLCBJJ20gbm90IGNv
bnZpbmNlZCB0aGlzIGlzIGFuIGltcHJvdmVtZW50Lgo+Pj4KPj4+IEknZCByYXRoZXIgcmVuYW1l
IHRoZSBuZXcgZXJyb3IgbGFiZWwgdG8gInB1dF9jbWQiIGFuZCBnZXQgcmlkIG9mIHRoZQo+Pj4g
YnJhY2VzIGluIGFib3ZlIGlmIHN0YXRlbWVudDoKPj4+Cj4+PiAtCWlmICghdG1yKSB7Cj4+PiAt
CQl0YXJnZXRfcHV0X3Nlc3NfY21kKHNlX2NtZCk7Cj4+PiAtCQlnb3RvIGVycjsKPj4+IC0JfQo+
Pj4gKwlpZiAoIXRtcikKPj4+ICsJCWdvdG8gcHV0X2NtZDsKPj4+Cj4+PiBhbmQgdGhlbiBpbiB0
aGUgZXJyb3IgcGF0aDoKPj4+Cj4+PiAtZXJyOgo+Pj4gK3B1dF9jbWQ6Cj4+PiArCXRhcmdldF9w
dXRfc2Vzc19jbWQoc2VfY21kKTsKPj4KPj4gSSBhbSB1bnN1cmUgb24gdGhlIHJlbGV2YW5jZSBv
ZiB0aGlzIGZ1bmN0aW9uIG9uIHN1Y2ggYSBzb3VyY2UgcG9zaXRpb24uCj4+IFdvdWxkIGl0IG1h
a2Ugc2Vuc2UgdG8gbW92ZSBpdCBmdXJ0aGVyIGRvd24gYXQgdGhlIGVuZD8KPiAKPiBZb3Ugb25s
eSB3YW50IHRvIGNhbGwgaXQgaW4gdGhlIGZpcnN0IGVycm9yIGNhc2UgKGFsbG9jYXRpb24gZmFp
bHVyZSkuCgpUaGFua3MgZm9yIHlvdXIgY2xhcmlmaWNhdGlvbi4KCkkgZmluZCB0aGF0IG15IHVw
ZGF0ZSBzdWdnZXN0aW9uIChmcm9tIFNhdHVyZGF5KSBpcyBzdGlsbCBhcHByb3ByaWF0ZQppbiB0
aGlzIGNhc2UuCmh0dHBzOi8vbGttbC5vcmcvbGttbC8yMDE2LzcvMTYvMTcyCgoKPj4+ICtmcmVl
X3RtcjoKPj4+IAlrZnJlZSh0bXIpOwo+Pgo+PiBIb3cgZG8geW91IHRoaW5rIGFib3V0IHRvIHNr
aXAgdGhpcyBmdW5jdGlvbiBjYWxsIGFmdGVyIGEgbWVtb3J5Cj4+IGFsbG9jYXRpb24gZmFpbHVy
ZT8KPiAKPiBJIHRoaW5rIHRoaXMganVzdCBkb2Vzbid0IG1hdHRlci4gSWYgaXQgd2VyZSBhIGhv
dCBwYXRoLCB5ZXMuIEJ1dCB0cnlpbmcKPiB0byBkbyBtaWNyby1vcHRpbWl6YXRpb25zIGluIGFu
IGVycm9yIHBhdGggaXMganVzdCBub3Qgd29ydGggdGhlIGVmZm9ydC4KCldvdWxkIHlvdSBsaWtl
IHRvIHJlZHVjZSBhbHNvIHRoZSBhbW91bnQgb2YgZnVuY3Rpb24gY2FsbHMgaW4gc3VjaCBzcGVj
aWFsCnJ1bi10aW1lIHNpdHVhdGlvbnM/CgoKPiBJIGxpa2UgYSBsaW5lYXIgZXJyb3IgcGF0aCBj
b250YWluaW5nIGFsbCB0aGUgbmVlZGVkIGNsZWFudXBzIGJlc3QuCgpJIHdvdWxkIHByZWZlciB0
byBrZWVwIHRoZSBkaXNjdXNzZWQgc2luZ2xlIGZ1bmN0aW9uIGNhbGwgd2l0aGluCnRoZSBiYXNp
YyBibG9jayBvZiB0aGUgaWYgc3RhdGVtZW50LgoKSGF2ZSB3ZSBnb3QgZGlmZmVyZW50IG9waW5p
b25zIGFib3V0IHRoZSBzaG93biBpbXBsZW1lbnRhdGlvbiBkZXRhaWxzPwoKUmVnYXJkcywKTWFy
a3VzCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpYZW4t
ZGV2ZWwgbWFpbGluZyBsaXN0Clhlbi1kZXZlbEBsaXN0cy54ZW4ub3JnCmh0dHBzOi8vbGlzdHMu
eGVuLm9yZy94ZW4tZGV2ZWwK
