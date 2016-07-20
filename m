From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH v2 1/3] xen-scsiback: Delete an unnecessary
 check before the function call "kfree"
Date: Wed, 20 Jul 2016 13:30:50 +0200
Message-ID: <62e64277-a6bc-9d9d-d80e-f3e515e7bcb3@users.sourceforge.net>
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
OiBUdWUsIDE5IEp1bCAyMDE2IDE1OjQyOjE5ICswMjAwCgpUaGUga2ZyZWUoKSBmdW5jdGlvbiB0
ZXN0cyB3aGV0aGVyIGl0cyBhcmd1bWVudCBpcyBOVUxMIGFuZCB0aGVuCnJldHVybnMgaW1tZWRp
YXRlbHkuIFRodXMgdGhlIHRlc3QgYXJvdW5kIHRoZSBjYWxsIGlzIG5vdCBuZWVkZWQuCgpUaGlz
IGlzc3VlIHdhcyBkZXRlY3RlZCBieSB1c2luZyB0aGUgQ29jY2luZWxsZSBzb2Z0d2FyZS4KClNp
Z25lZC1vZmYtYnk6IE1hcmt1cyBFbGZyaW5nIDxlbGZyaW5nQHVzZXJzLnNvdXJjZWZvcmdlLm5l
dD4KLS0tCnYyOiBSZWJhc2VkIG9uIHNvdXJjZSBmaWxlcyBmcm9tICJMaW51eCBuZXh0LTIwMTYw
NzE5IgoKIGRyaXZlcnMveGVuL3hlbi1zY3NpYmFjay5jIHwgMyArLS0KIDEgZmlsZSBjaGFuZ2Vk
LCAxIGluc2VydGlvbigrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3hl
bi94ZW4tc2NzaWJhY2suYyBiL2RyaXZlcnMveGVuL3hlbi1zY3NpYmFjay5jCmluZGV4IGQ2OTUw
ZTAuLjRhNDhjMDYgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMveGVuL3hlbi1zY3NpYmFjay5jCisrKyBi
L2RyaXZlcnMveGVuL3hlbi1zY3NpYmFjay5jCkBAIC02MjcsOCArNjI3LDcgQEAgc3RhdGljIHZv
aWQgc2NzaWJhY2tfZGV2aWNlX2FjdGlvbihzdHJ1Y3QgdnNjc2lia19wZW5kICpwZW5kaW5nX3Jl
cSwKIAl0cmFuc3BvcnRfZ2VuZXJpY19mcmVlX2NtZCgmcGVuZGluZ19yZXEtPnNlX2NtZCwgMSk7
CiAJcmV0dXJuOwogZXJyOgotCWlmICh0bXIpCi0JCWtmcmVlKHRtcik7CisJa2ZyZWUodG1yKTsK
IAlzY3NpYmFja19kb19yZXNwX3dpdGhfc2Vuc2UoTlVMTCwgZXJyLCAwLCBwZW5kaW5nX3JlcSk7
CiB9CiAKLS0gCjIuOS4yCgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18KWGVuLWRldmVsIG1haWxpbmcgbGlzdApYZW4tZGV2ZWxAbGlzdHMueGVuLm9yZwpo
dHRwczovL2xpc3RzLnhlbi5vcmcveGVuLWRldmVsCg==
