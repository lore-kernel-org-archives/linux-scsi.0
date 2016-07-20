From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH v2 2/3] xen-scsiback: Rename jump labels in
 scsiback_device_action()
Date: Wed, 20 Jul 2016 13:34:20 +0200
Message-ID: <639f00cc-5041-7ec0-b7f2-6ddb81129d15@users.sourceforge.net>
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
OiBXZWQsIDIwIEp1bCAyMDE2IDEzOjAzOjE2ICswMjAwCgoqIEFkanVzdCBqdW1wIHRhcmdldHMg
YWNjb3JkaW5nIHRvIHRoZSBMaW51eCBjb2Rpbmcgc3R5bGUgY29udmVudGlvbi4KCiogQSBiaXQg
b2YgcmVmYWN0b3JpbmcgZm9yIHRoZSBjb250cm9sIGZsb3cKClN1Z2dlc3RlZC1ieTogSsO8cmdl
biBHcm/DnyA8amdyb3NzQHN1c2UuY29tPgpTaWduZWQtb2ZmLWJ5OiBNYXJrdXMgRWxmcmluZyA8
ZWxmcmluZ0B1c2Vycy5zb3VyY2Vmb3JnZS5uZXQ+Ci0tLQp2MjogUmViYXNlZCBvbiBzb3VyY2Ug
ZmlsZXMgZnJvbSAiTGludXggbmV4dC0yMDE2MDcxOSIKICAgIENoYW5nZXMgZnJvbSBhIGJpdCBv
ZiBjb2RlIHJldmlldwoKIGRyaXZlcnMveGVuL3hlbi1zY3NpYmFjay5jIHwgMTIgKysrKysrLS0t
LS0tCiAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQoKZGlm
ZiAtLWdpdCBhL2RyaXZlcnMveGVuL3hlbi1zY3NpYmFjay5jIGIvZHJpdmVycy94ZW4veGVuLXNj
c2liYWNrLmMKaW5kZXggNGE0OGMwNi4uZWIyNzRkZiAxMDA2NDQKLS0tIGEvZHJpdmVycy94ZW4v
eGVuLXNjc2liYWNrLmMKKysrIGIvZHJpdmVycy94ZW4veGVuLXNjc2liYWNrLmMKQEAgLTYwNCwx
MCArNjA0LDggQEAgc3RhdGljIHZvaWQgc2NzaWJhY2tfZGV2aWNlX2FjdGlvbihzdHJ1Y3QgdnNj
c2lia19wZW5kICpwZW5kaW5nX3JlcSwKIAlpbnQgcmMsIGVyciA9IEZBSUxFRDsKIAogCXRtciA9
IGt6YWxsb2Moc2l6ZW9mKHN0cnVjdCBzY3NpYmFja190bXIpLCBHRlBfS0VSTkVMKTsKLQlpZiAo
IXRtcikgewotCQl0YXJnZXRfcHV0X3Nlc3NfY21kKHNlX2NtZCk7Ci0JCWdvdG8gZXJyOwotCX0K
KwlpZiAoIXRtcikKKwkJZ290byBwdXRfY21kOwogCiAJaW5pdF93YWl0cXVldWVfaGVhZCgmdG1y
LT50bXJfd2FpdCk7CiAKQEAgLTYxNiw3ICs2MTQsNyBAQCBzdGF0aWMgdm9pZCBzY3NpYmFja19k
ZXZpY2VfYWN0aW9uKHN0cnVjdCB2c2NzaWJrX3BlbmQgKnBlbmRpbmdfcmVxLAogCQkJICAgICAg
IHVucGFja2VkX2x1biwgdG1yLCBhY3QsIEdGUF9LRVJORUwsCiAJCQkgICAgICAgdGFnLCBUQVJH
RVRfU0NGX0FDS19LUkVGKTsKIAlpZiAocmMpCi0JCWdvdG8gZXJyOworCQlnb3RvIGZyZWVfdG1y
OwogCiAJd2FpdF9ldmVudCh0bXItPnRtcl93YWl0LCBhdG9taWNfcmVhZCgmdG1yLT50bXJfY29t
cGxldGUpKTsKIApAQCAtNjI2LDcgKzYyNCw5IEBAIHN0YXRpYyB2b2lkIHNjc2liYWNrX2Rldmlj
ZV9hY3Rpb24oc3RydWN0IHZzY3NpYmtfcGVuZCAqcGVuZGluZ19yZXEsCiAJc2NzaWJhY2tfZG9f
cmVzcF93aXRoX3NlbnNlKE5VTEwsIGVyciwgMCwgcGVuZGluZ19yZXEpOwogCXRyYW5zcG9ydF9n
ZW5lcmljX2ZyZWVfY21kKCZwZW5kaW5nX3JlcS0+c2VfY21kLCAxKTsKIAlyZXR1cm47Ci1lcnI6
CitwdXRfY21kOgorCXRhcmdldF9wdXRfc2Vzc19jbWQoc2VfY21kKTsKK2ZyZWVfdG1yOgogCWtm
cmVlKHRtcik7CiAJc2NzaWJhY2tfZG9fcmVzcF93aXRoX3NlbnNlKE5VTEwsIGVyciwgMCwgcGVu
ZGluZ19yZXEpOwogfQotLSAKMi45LjIKCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwpYZW4tZGV2ZWwgbWFpbGluZyBsaXN0Clhlbi1kZXZlbEBsaXN0cy54
ZW4ub3JnCmh0dHBzOi8vbGlzdHMueGVuLm9yZy94ZW4tZGV2ZWwK
