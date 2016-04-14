From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: [SCSI] pm80xx: Phy settings support for motherboard controller.
Date: Thu, 14 Apr 2016 14:52:20 +0200
Message-ID: <CAD+HZHXt=+z=+9=Uh7etj8aB3M_kk_sSB+ipc633Bc5caQuaQA@mail.gmail.com>
References: <20160413112454.GA25247@mwanda>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=047d7b3a822c6f682a0530715d5b
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:35791 "EHLO
	mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330AbcDNMwW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Apr 2016 08:52:22 -0400
Received: by mail-lf0-f65.google.com with SMTP id o124so12052661lfb.2
        for <linux-scsi@vger.kernel.org>; Thu, 14 Apr 2016 05:52:21 -0700 (PDT)
In-Reply-To: <20160413112454.GA25247@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Anand Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>, "pmchba@pmcs.com" <pmchba@pmcs.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

--047d7b3a822c6f682a0530715d5b
Content-Type: text/plain; charset=UTF-8

2016-04-13 13:24 GMT+02:00 Dan Carpenter <dan.carpenter@oracle.com>:
> Hello Anand Kumar Santhanam,
>
> The patch 279094079a44: "[SCSI] pm80xx: Phy settings support for
> motherboard controller." from Sep 18, 2013, leads to the following
> static checker warning:
>
>         drivers/scsi/pm8001/pm80xx_hwi.c:4554 mpi_set_phy_profile_req()
>         error: uninitialized symbol 'tag'.
>
Thanks for reporting, attached patch should fix the warning.

--047d7b3a822c6f682a0530715d5b
Content-Type: text/x-diff; charset=US-ASCII;
	name="0001-pm80xx-avoid-to-use-invalid-tag.patch"
Content-Disposition: attachment;
	filename="0001-pm80xx-avoid-to-use-invalid-tag.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_in0ablxn0

RnJvbSBlMzBhZjgwMWQ5ZWU5OTc5YjJhN2EyYWY4MTVjYjM5NWMyMjU1YTA5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKYWNrIFdhbmcgPGppbnB1LndhbmdAcHJvZml0YnJpY2tzLmNv
bT4KRGF0ZTogVGh1LCAxNCBBcHIgMjAxNiAxNDozODo1NyArMDIwMApTdWJqZWN0OiBbUEFUQ0hd
IHBtODB4eDogYXZvaWQgdG8gdXNlIGludmFsaWQgdGFnCgpGaXggc3RhdGljIGNoZWNrZXIgd2Fy
bmluZzoKCmRyaXZlcnMvc2NzaS9wbTgwMDEvcG04MHh4X2h3aS5jOjQ1NTQgbXBpX3NldF9waHlf
cHJvZmlsZV9yZXEoKQplcnJvcjogdW5pbml0aWFsaXplZCBzeW1ib2wgJ3RhZycuCgpSZXBvcnRl
ZC1ieTogRGFuIENhcnBlbnRlciBkYW4uY2FycGVudGVyQG9yYWNsZS5jb20KU2lnbmVkLW9mZi1i
eTogSmFjayBXYW5nIDxqaW5wdS53YW5nQHByb2ZpdGJyaWNrcy5jb20+Ci0tLQogZHJpdmVycy9z
Y3NpL3BtODAwMS9wbTgweHhfaHdpLmMgfCA4ICsrKysrKy0tCiAxIGZpbGUgY2hhbmdlZCwgNiBp
bnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9w
bTgwMDEvcG04MHh4X2h3aS5jIGIvZHJpdmVycy9zY3NpL3BtODAwMS9wbTgweHhfaHdpLmMKaW5k
ZXggZWI0ZmVlNi4uYTNjMWMwOCAxMDA2NDQKLS0tIGEvZHJpdmVycy9zY3NpL3BtODAwMS9wbTgw
eHhfaHdpLmMKKysrIGIvZHJpdmVycy9zY3NpL3BtODAwMS9wbTgweHhfaHdpLmMKQEAgLTQ1NDgs
OCArNDU0OCwxMCBAQCB2b2lkIG1waV9zZXRfcGh5X3Byb2ZpbGVfcmVxKHN0cnVjdCBwbTgwMDFf
aGJhX2luZm8gKnBtODAwMV9oYSwKIAogCW1lbXNldCgmcGF5bG9hZCwgMCwgc2l6ZW9mKHBheWxv
YWQpKTsKIAlyYyA9IHBtODAwMV90YWdfYWxsb2MocG04MDAxX2hhLCAmdGFnKTsKLQlpZiAocmMp
CisJaWYgKHJjKSB7CiAJCVBNODAwMV9GQUlMX0RCRyhwbTgwMDFfaGEsIHBtODAwMV9wcmludGso
IkludmFsaWQgdGFnXG4iKSk7CisJCXJldHVybjsKKwl9CiAJY2lyY3VsYXJRID0gJnBtODAwMV9o
YS0+aW5ibmRfcV90YmxbMF07CiAJcGF5bG9hZC50YWcgPSBjcHVfdG9fbGUzMih0YWcpOwogCXBh
eWxvYWQucHBjX3BoeWlkID0gKCgob3BlcmF0aW9uICYgMHhGKSA8PCA4KSB8IChwaHlpZCAgJiAw
eEZGKSk7CkBAIC00NTkwLDggKzQ1OTIsMTAgQEAgdm9pZCBwbTgwMDFfc2V0X3BoeV9wcm9maWxl
X3NpbmdsZShzdHJ1Y3QgcG04MDAxX2hiYV9pbmZvICpwbTgwMDFfaGEsCiAJbWVtc2V0KCZwYXls
b2FkLCAwLCBzaXplb2YocGF5bG9hZCkpOwogCiAJcmMgPSBwbTgwMDFfdGFnX2FsbG9jKHBtODAw
MV9oYSwgJnRhZyk7Ci0JaWYgKHJjKQorCWlmIChyYykgewogCQlQTTgwMDFfSU5JVF9EQkcocG04
MDAxX2hhLCBwbTgwMDFfcHJpbnRrKCJJbnZhbGlkIHRhZyIpKTsKKwkJcmV0dXJuOworCX0KIAog
CWNpcmN1bGFyUSA9ICZwbTgwMDFfaGEtPmluYm5kX3FfdGJsWzBdOwogCW9wYyA9IE9QQ19JTkJf
U0VUX1BIWV9QUk9GSUxFOwotLSAKMS45LjEKCg==
--047d7b3a822c6f682a0530715d5b--
