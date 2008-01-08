From: "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>
Subject: RE: [PATCH 1/1] aacraid: multiple definition of automatic variable
 warning.
Date: Tue, 8 Jan 2008 13:08:04 -0800
Message-ID: <532ABFBDAAC3A34EB12EBA6CEC2838F40DC67A@ADPE2K703.adaptec.com>
References: <20071031150216.88cecc21.sfr@canb.auug.org.au><20071101173221.2e1fea42.sfr@canb.auug.org.au>
 <jefxzqqeha.fsf@sykes.suse.de>
 <AE4F746F2AECFC4DA4AADD66A1DFEF01F95EF7@otce2k301.adaptec.com>
 <532ABFBDAAC3A34EB12EBA6CEC2838F40FE734@ADPE2K703.adaptec.com>
 <532ABFBDAAC3A34EB12EBA6CEC2838F40FE735@ADPE2K703.adaptec.com>
 <532ABFBDAAC3A34EB12EBA6CEC2838F40FE736@ADPE2K703.adaptec.com>
 <532ABFBDAAC3A34EB12EBA6CEC2838F40FE738@ADPE2K703.adaptec.com>
 <532ABFBDAAC3A34EB12EBA6CEC2838F40DC66A@ADPE2K703.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_532ABFBDAAC3A34EB12EBA6CEC2838F40DC67AADPE2K703adaptecc_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ts.adaptec.com ([162.62.93.58]:45502 "EHLO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696AbYAHVII (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Jan 2008 16:08:08 -0500
Received: from ADPE2K701.adaptec.com (adpe2k701.adaptec.com [10.25.8.25])
	by mail-gw3.adaptec.com (Spam Firewall) with ESMTP id C47D02215DE
	for <linux-scsi@vger.kernel.org>; Tue,  8 Jan 2008 13:08:07 -0800 (PST)
In-Reply-To: <532ABFBDAAC3A34EB12EBA6CEC2838F40DC66A@ADPE2K703.adaptec.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

--_002_532ABFBDAAC3A34EB12EBA6CEC2838F40DC67AADPE2K703adaptecc_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Missed the patch attachment 8-}

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Salyzyn, Mark
> Sent: Tuesday, January 08, 2008 3:58 PM
> To: 'linux-scsi@vger.kernel.org'
> Subject: [PATCH 1/1] aacraid: multiple definition of
> automatic variable warning.
>
> The 'entry' automatic variable was defined at the top and
> within a block that uses it, removed the definition from the
> block that uses it. Some cosmetic changes were made while in
> the same file. This patch should be inert.
>
> This attached patch is against current scsi-misc-2.6.
>
> ObligatoryDisclaimer: Please accept my condolences regarding
> Outlook's handling of patch attachments.
>
> Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>
>
> This attached patch is against current scsi-misc-2.6.
>
>  commctrl.c |    9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
>
> Sincerely -- Mark Salyzyn

--_002_532ABFBDAAC3A34EB12EBA6CEC2838F40DC67AADPE2K703adaptecc_
Content-Type: application/octet-stream;
	name="aacraid_multiple_definition.patch"
Content-Description: aacraid_multiple_definition.patch
Content-Disposition: attachment;
	filename="aacraid_multiple_definition.patch"; size=1706;
	creation-date="Tue, 08 Jan 2008 12:53:49 GMT";
	modification-date="Tue, 08 Jan 2008 12:53:49 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtcnUgYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9jb21tY3RybC5jIGIvZHJpdmVycy9zY3Np
L2FhY3JhaWQvY29tbWN0cmwuYwotLS0gYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9jb21tY3RybC5j
CTIwMDgtMDEtMDggMTU6NDg6MjkuOTYyNzkzMjc4IC0wNTAwCisrKyBiL2RyaXZlcnMvc2NzaS9h
YWNyYWlkL2NvbW1jdHJsLmMJMjAwOC0wMS0wOCAxNTo1Mjo1Ny4wNDcxNDI5NzUgLTA1MDAKQEAg
LTI3NSw3ICsyNzUsNiBAQAogCSAqLwogcmV0dXJuX2ZpYjoKIAlpZiAoIWxpc3RfZW1wdHkoJmZp
YmN0eC0+ZmliX2xpc3QpKSB7Ci0JCXN0cnVjdCBsaXN0X2hlYWQgKiBlbnRyeTsKIAkJLyoKIAkJ
ICoJUHVsbCB0aGUgbmV4dCBmaWIgZnJvbSB0aGUgZmlicwogCQkgKi8KQEAgLTU4Miw3ICs1ODEs
NyBAQAogCQkJCXZvaWQqIHA7CiAJCQkJLyogRG9lcyB0aGlzIHJlYWxseSBuZWVkIHRvIGJlIEdG
UF9ETUE/ICovCiAJCQkJcCA9IGttYWxsb2ModXBzZy0+c2dbaV0uY291bnQsR0ZQX0tFUk5FTHxf
X0dGUF9ETUEpOwotCQkJCWlmKHAgPT0gMCkgeworCQkJCWlmKCFwKSB7CiAJCQkJCWRwcmludGso
KEtFUk5fREVCVUciYWFjcmFpZDogQ291bGQgbm90IGFsbG9jYXRlIFNHIGJ1ZmZlciAtIHNpemUg
PSAlZCBidWZmZXIgbnVtYmVyICVkIG9mICVkXG4iLAogCQkJCQkgIHVwc2ctPnNnW2ldLmNvdW50
LGksdXBzZy0+Y291bnQpKTsKIAkJCQkJcmNvZGUgPSAtRU5PTUVNOwpAQCAtNjI2LDcgKzYyNSw3
IEBACiAJCQkJdm9pZCogcDsKIAkJCQkvKiBEb2VzIHRoaXMgcmVhbGx5IG5lZWQgdG8gYmUgR0ZQ
X0RNQT8gKi8KIAkJCQlwID0ga21hbGxvYyh1c2ctPnNnW2ldLmNvdW50LEdGUF9LRVJORUx8X19H
RlBfRE1BKTsKLQkJCQlpZihwID09IDApIHsKKwkJCQlpZighcCkgewogCQkJCQlrZnJlZSAodXNn
KTsKIAkJCQkJZHByaW50aygoS0VSTl9ERUJVRyJhYWNyYWlkOiBDb3VsZCBub3QgYWxsb2NhdGUg
U0cgYnVmZmVyIC0gc2l6ZSA9ICVkIGJ1ZmZlciBudW1iZXIgJWQgb2YgJWRcbiIsCiAJCQkJCSAg
dXNnLT5zZ1tpXS5jb3VudCxpLHVzZy0+Y291bnQpKTsKQEAgLTY2OCw3ICs2NjcsNyBAQAogCQkJ
CXZvaWQqIHA7CiAJCQkJLyogRG9lcyB0aGlzIHJlYWxseSBuZWVkIHRvIGJlIEdGUF9ETUE/ICov
CiAJCQkJcCA9IGttYWxsb2ModXNnLT5zZ1tpXS5jb3VudCxHRlBfS0VSTkVMfF9fR0ZQX0RNQSk7
Ci0JCQkJaWYocCA9PSAwKSB7CisJCQkJaWYoIXApIHsKIAkJCQkJZHByaW50aygoS0VSTl9ERUJV
RyJhYWNyYWlkOiBDb3VsZCBub3QgYWxsb2NhdGUgU0cgYnVmZmVyIC0gc2l6ZSA9ICVkIGJ1ZmZl
ciBudW1iZXIgJWQgb2YgJWRcbiIsCiAJCQkJCSAgdXNnLT5zZ1tpXS5jb3VudCxpLHVzZy0+Y291
bnQpKTsKIAkJCQkJcmNvZGUgPSAtRU5PTUVNOwpAQCAtNjk4LDcgKzY5Nyw3IEBACiAJCQkJZG1h
X2FkZHJfdCBhZGRyOwogCQkJCXZvaWQqIHA7CiAJCQkJcCA9IGttYWxsb2ModXBzZy0+c2dbaV0u
Y291bnQsIEdGUF9LRVJORUwpOwotCQkJCWlmKHAgPT0gMCkgeworCQkJCWlmICghcCkgewogCQkJ
CQlkcHJpbnRrKChLRVJOX0RFQlVHImFhY3JhaWQ6IENvdWxkIG5vdCBhbGxvY2F0ZSBTRyBidWZm
ZXIgLSBzaXplID0gJWQgYnVmZmVyIG51bWJlciAlZCBvZiAlZFxuIiwKIAkJCQkJICB1cHNnLT5z
Z1tpXS5jb3VudCwgaSwgdXBzZy0+Y291bnQpKTsKIAkJCQkJcmNvZGUgPSAtRU5PTUVNOwo=

--_002_532ABFBDAAC3A34EB12EBA6CEC2838F40DC67AADPE2K703adaptecc_--
