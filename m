From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH v2 3/3] xen-scsiback: Pass a failure indication
	as a constant
Date: Wed, 20 Jul 2016 13:36:38 +0200
Message-ID: <b025aa24-63c9-4b2e-5035-9da278f968e5@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net>
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
 <18256bfc-c6f9-8802-8d7d-55766f0b3624@users.sourceforge.net>
 <85b948e0-bf37-dff0-6792-77b5dacef9a0@suse.com>
 <6863b12b-9095-aaf3-6140-80968e0071e2@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <xen-devel-bounces@lists.xen.org>
In-Reply-To: <6863b12b-9095-aaf3-6140-80968e0071e2@users.sourceforge.net>
List-Unsubscribe: <https://lists.xen.org/cgi-bin/mailman/options/xen-devel>,
 <mailto:xen-devel-request@lists.xen.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xen.org>
List-Help: <mailto:xen-devel-request@lists.xen.org?subject=help>
List-Subscribe: <https://lists.xen.org/cgi-bin/mailman/listinfo/xen-devel>,
 <mailto:xen-devel-request@lists.xen.org?subject=subscribe>
Errors-To: xen-devel-bounces@lists.xen.org
Sender: "Xen-devel" <xen-devel-bounces@lists.xen.org>
To: xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org, =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>, David Vrabel <david.vrabel@citrix.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>, kernel-janitors@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

RnJvbTogTWFya3VzIEVsZnJpbmcgPGVsZnJpbmdAdXNlcnMuc291cmNlZm9yZ2UubmV0PgpEYXRl
OiBXZWQsIDIwIEp1bCAyMDE2IDEzOjEyOjMzICswMjAwCgpQYXNzIHRoZSBjb25zdGFudCAiRkFJ
TEVEIiBpbiBhIGZ1bmN0aW9uIGNhbGwgZGlyZWN0bHkgaW5zdGVhZCBvZgp1c2luZyBhbiBpbnRp
YWxpc2F0aW9uIGZvciBhIGxvY2FsIHZhcmlhYmxlLgoKU2lnbmVkLW9mZi1ieTogTWFya3VzIEVs
ZnJpbmcgPGVsZnJpbmdAdXNlcnMuc291cmNlZm9yZ2UubmV0PgotLS0KdjI6IFJlYmFzZWQgb24g
c291cmNlIGZpbGVzIGZyb20gIkxpbnV4IG5leHQtMjAxNjA3MTkiCgogZHJpdmVycy94ZW4veGVu
LXNjc2liYWNrLmMgfCA0ICsrLS0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIg
ZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy94ZW4veGVuLXNjc2liYWNrLmMgYi9k
cml2ZXJzL3hlbi94ZW4tc2NzaWJhY2suYwppbmRleCBlYjI3NGRmLi5mYTA4ZWM2IDEwMDY0NAot
LS0gYS9kcml2ZXJzL3hlbi94ZW4tc2NzaWJhY2suYworKysgYi9kcml2ZXJzL3hlbi94ZW4tc2Nz
aWJhY2suYwpAQCAtNjAxLDcgKzYwMSw3IEBAIHN0YXRpYyB2b2lkIHNjc2liYWNrX2RldmljZV9h
Y3Rpb24oc3RydWN0IHZzY3NpYmtfcGVuZCAqcGVuZGluZ19yZXEsCiAJc3RydWN0IHNlX2NtZCAq
c2VfY21kID0gJnBlbmRpbmdfcmVxLT5zZV9jbWQ7CiAJc3RydWN0IHNjc2liYWNrX3RtciAqdG1y
OwogCXU2NCB1bnBhY2tlZF9sdW4gPSBwZW5kaW5nX3JlcS0+djJwLT5sdW47Ci0JaW50IHJjLCBl
cnIgPSBGQUlMRUQ7CisJaW50IHJjLCBlcnI7CiAKIAl0bXIgPSBremFsbG9jKHNpemVvZihzdHJ1
Y3Qgc2NzaWJhY2tfdG1yKSwgR0ZQX0tFUk5FTCk7CiAJaWYgKCF0bXIpCkBAIC02MjgsNyArNjI4
LDcgQEAgcHV0X2NtZDoKIAl0YXJnZXRfcHV0X3Nlc3NfY21kKHNlX2NtZCk7CiBmcmVlX3RtcjoK
IAlrZnJlZSh0bXIpOwotCXNjc2liYWNrX2RvX3Jlc3Bfd2l0aF9zZW5zZShOVUxMLCBlcnIsIDAs
IHBlbmRpbmdfcmVxKTsKKwlzY3NpYmFja19kb19yZXNwX3dpdGhfc2Vuc2UoTlVMTCwgRkFJTEVE
LCAwLCBwZW5kaW5nX3JlcSk7CiB9CiAKIC8qCi0tIAoyLjkuMgoKCl9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fClhlbi1kZXZlbCBtYWlsaW5nIGxpc3QKWGVu
LWRldmVsQGxpc3RzLnhlbi5vcmcKaHR0cHM6Ly9saXN0cy54ZW4ub3JnL3hlbi1kZXZlbAo=
