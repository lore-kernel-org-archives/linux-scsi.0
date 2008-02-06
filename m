From: "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>
Subject: [PATCH 1/1] aacraid: pci_set_dma_max_seg_size opened up for late
 model controllers (take 2)
Date: Wed, 6 Feb 2008 10:08:11 -0800
Message-ID: <532ABFBDAAC3A34EB12EBA6CEC2838F439829D14@ADPE2K703.adaptec.com>
References: <532ABFBDAAC3A34EB12EBA6CEC2838F4397D643D@ADPE2K703.adaptec.com>
	 <20080205234912B.tomof@acm.org>
	 <532ABFBDAAC3A34EB12EBA6CEC2838F4397D6932@ADPE2K703.adaptec.com>
	 <20080206101148L.fujita.tomonori@lab.ntt.co.jp>
	 <532ABFBDAAC3A34EB12EBA6CEC2838F439829BBB@ADPE2K703.adaptec.com>
 <1202320497.3112.92.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_532ABFBDAAC3A34EB12EBA6CEC2838F439829D14ADPE2K703adapte_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([162.62.93.58]:48496 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbYBFSIR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Feb 2008 13:08:17 -0500
In-Reply-To: <1202320497.3112.92.camel@localhost.localdomain>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "tomof@acm.org" <tomof@acm.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, "jeff@garzik.org" <jeff@garzik.org>, "jens.axboe@oracle.com" <jens.axboe@oracle.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

--_002_532ABFBDAAC3A34EB12EBA6CEC2838F439829D14ADPE2K703adapte_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Merde, excuse my english. No idea how those spaces snuck in, a last minute =
vi fumble finger?! Updated patch enclosed. My apologies for the gaff!

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

 drivers/scsi/aacraid/linit.c |   42 ++++++++++++++++++++------------------=
----
 1 file changed, 20 insertions(+), 22 deletions(-)

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
> Sent: Wednesday, February 06, 2008 12:55 PM
> To: Salyzyn, Mark
> Cc: FUJITA Tomonori; tomof@acm.org;
> akpm@linux-foundation.org; torvalds@linux-foundation.org;
> jeff@garzik.org; jens.axboe@oracle.com; 'linux-scsi@vger.kernel.org'
> Subject: Re: [PATCH 1/1] aacraid: pci_set_dma_max_seg_size
> opened up for late model controllers
>
> On Wed, 2008-02-06 at 09:00 -0800, Salyzyn, Mark wrote:
> > This patch depends on 'RE: [patch 048/265] iommu sg
> merging: aacraid: use pci_set_dma_max_seg_size' and ensures
> that the modern adapters get a maximum sg segment size on par
> with the maximum transfer size. Added some localized janitor
> fixes to the discussion patch I used with Fujita.
> >
> > FUJITA Tomonori [mailto:fujita.tomonori@lab.ntt.co.jp] sez:
> > > I think that setting the proper maximum segment size for the late
> > > model cards (as you did above) makes sense.
> >
> > This attached patch is against current linux-2.6. It will
> not apply to current scsi-misc-2.6 without the above
> mentioned dependency.
> >
> > ObligatoryDisclaimer: Please accept my condolences
> regarding Outlook's handling of patch attachments. Please use
> the attached file to patch
> >
> > Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>
>
> OK, I have this, but someone really needs to do a little more
> checkpatch
> love:
>
> jejb@mulgrave> ./scripts/checkpatch.pl ~/tmp.mail
> ERROR: use tabs not spaces
> #44: FILE: drivers/scsi/aacraid/linit.c:1138:
> + ^I^Ishost->sg_tablesize =3D 34;$
>
> ERROR: use tabs not spaces
> #45: FILE: drivers/scsi/aacraid/linit.c:1139:
> + ^I^Ishost->max_sectors =3D (shost->sg_tablesize * 8) + 112;$
>
> ERROR: use tabs not spaces
> #54: FILE: drivers/scsi/aacraid/linit.c:1144:
> + ^I^Ishost->sg_tablesize =3D 17;$
>
> ERROR: use tabs not spaces
> #55: FILE: drivers/scsi/aacraid/linit.c:1145:
> + ^I^Ishost->max_sectors =3D (shost->sg_tablesize * 8) + 112;$
>
> ERROR: use tabs not spaces
> #60: FILE: drivers/scsi/aacraid/linit.c:1150:
> + ^I^I^I(shost->max_sectors << 9) : 65536);$
>
> total: 5 errors, 0 warnings, 44 lines checked
>
> Your patch has style problems, please review.  If any of these errors
> are false positives report them to the maintainer, see
> CHECKPATCH in MAINTAINERS.
>
> James

--_002_532ABFBDAAC3A34EB12EBA6CEC2838F439829D14ADPE2K703adapte_
Content-Type: application/octet-stream; name="aacraid_pci_set_dma1.patch"
Content-Description: aacraid_pci_set_dma1.patch
Content-Disposition: attachment; filename="aacraid_pci_set_dma1.patch";
	size=1984; creation-date="Wed, 06 Feb 2008 10:00:24 GMT";
	modification-date="Wed, 06 Feb 2008 10:00:24 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtcnUgYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9saW5pdC5jIGIvZHJpdmVycy9zY3NpL2Fh
Y3JhaWQvbGluaXQuYwotLS0gYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9saW5pdC5jCTIwMDgtMDIt
MDYgMTE6MzU6NTUuMTExNjMxNTkxIC0wNTAwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2xp
bml0LmMJMjAwOC0wMi0wNiAxMjo1OTozNC42MDY1NjE4MzQgLTA1MDAKQEAgLTExMzAsMzggKzEx
MzAsMzYgQEAKIAlpZiAoZXJyb3IgPCAwKQogCQlnb3RvIG91dF9kZWluaXQ7CiAKLQlpZiAoIShh
YWMtPmFkYXB0ZXJfaW5mby5vcHRpb25zICYgQUFDX09QVF9ORVdfQ09NTSkpIHsKLQkJZXJyb3Ig
PSBwY2lfc2V0X2RtYV9tYXhfc2VnX3NpemUocGRldiwgNjU1MzYpOwotCQlpZiAoZXJyb3IpCi0J
CQlnb3RvIG91dF9kZWluaXQ7Ci0JfQotCiAJLyoKLSAJICogTGV0cyBvdmVycmlkZSBuZWdvdGlh
dGlvbnMgYW5kIGRyb3AgdGhlIG1heGltdW0gU0cgbGltaXQgdG8gMzQKLSAJICovCisJICogTGV0
cyBvdmVycmlkZSBuZWdvdGlhdGlvbnMgYW5kIGRyb3AgdGhlIG1heGltdW0gU0cgbGltaXQgdG8g
MzQKKwkgKi8KIAlpZiAoKGFhY19kcml2ZXJzW2luZGV4XS5xdWlya3MgJiBBQUNfUVVJUktfMzRT
RykgJiYKLQkJCShhYWMtPnNjc2lfaG9zdF9wdHItPnNnX3RhYmxlc2l6ZSA+IDM0KSkgewotIAkJ
YWFjLT5zY3NpX2hvc3RfcHRyLT5zZ190YWJsZXNpemUgPSAzNDsKLSAJCWFhYy0+c2NzaV9ob3N0
X3B0ci0+bWF4X3NlY3RvcnMKLSAJCSAgPSAoYWFjLT5zY3NpX2hvc3RfcHRyLT5zZ190YWJsZXNp
emUgKiA4KSArIDExMjsKLSAJfQotCi0gCWlmICgoYWFjX2RyaXZlcnNbaW5kZXhdLnF1aXJrcyAm
IEFBQ19RVUlSS18xN1NHKSAmJgotCQkJKGFhYy0+c2NzaV9ob3N0X3B0ci0+c2dfdGFibGVzaXpl
ID4gMTcpKSB7Ci0gCQlhYWMtPnNjc2lfaG9zdF9wdHItPnNnX3RhYmxlc2l6ZSA9IDE3OwotIAkJ
YWFjLT5zY3NpX2hvc3RfcHRyLT5tYXhfc2VjdG9ycwotIAkJICA9IChhYWMtPnNjc2lfaG9zdF9w
dHItPnNnX3RhYmxlc2l6ZSAqIDgpICsgMTEyOwotIAl9CisJCQkoc2hvc3QtPnNnX3RhYmxlc2l6
ZSA+IDM0KSkgeworCQlzaG9zdC0+c2dfdGFibGVzaXplID0gMzQ7CisJCXNob3N0LT5tYXhfc2Vj
dG9ycyA9IChzaG9zdC0+c2dfdGFibGVzaXplICogOCkgKyAxMTI7CisJfQorCisJaWYgKChhYWNf
ZHJpdmVyc1tpbmRleF0ucXVpcmtzICYgQUFDX1FVSVJLXzE3U0cpICYmCisJCQkoc2hvc3QtPnNn
X3RhYmxlc2l6ZSA+IDE3KSkgeworCQlzaG9zdC0+c2dfdGFibGVzaXplID0gMTc7CisJCXNob3N0
LT5tYXhfc2VjdG9ycyA9IChzaG9zdC0+c2dfdGFibGVzaXplICogOCkgKyAxMTI7CisJfQorCisJ
ZXJyb3IgPSBwY2lfc2V0X2RtYV9tYXhfc2VnX3NpemUocGRldiwKKwkJKGFhYy0+YWRhcHRlcl9p
bmZvLm9wdGlvbnMgJiBBQUNfT1BUX05FV19DT01NKSA/CisJCQkoc2hvc3QtPm1heF9zZWN0b3Jz
IDw8IDkpIDogNjU1MzYpOworCWlmIChlcnJvcikKKwkJZ290byBvdXRfZGVpbml0OwogCiAJLyoK
LQkgKiBGaXJ3YXJlIHByaW50ZiB3b3JrcyBvbmx5IHdpdGggb2xkZXIgZmlybXdhcmUuCisJICog
RmlybXdhcmUgcHJpbnRmIHdvcmtzIG9ubHkgd2l0aCBvbGRlciBmaXJtd2FyZS4KIAkgKi8KIAlp
ZiAoYWFjX2RyaXZlcnNbaW5kZXhdLnF1aXJrcyAmIEFBQ19RVUlSS18zNFNHKQogCQlhYWMtPnBy
aW50Zl9lbmFibGVkID0gMTsKIAllbHNlCiAJCWFhYy0+cHJpbnRmX2VuYWJsZWQgPSAwOwogCi0g
CS8qCisJLyoKIAkgKiBtYXggY2hhbm5lbCB3aWxsIGJlIHRoZSBwaHlzaWNhbCBjaGFubmVscyBw
bHVzIDEgdmlydHVhbCBjaGFubmVsCiAJICogYWxsIGNvbnRhaW5lcnMgYXJlIG9uIHRoZSB2aXJ0
dWFsIGNoYW5uZWwgMCAoQ09OVEFJTkVSX0NIQU5ORUwpCiAJICogcGh5c2ljYWwgY2hhbm5lbHMg
YXJlIGFkZHJlc3MgYnkgdGhlaXIgYWN0dWFsIHBoeXNpY2FsIG51bWJlcisxCg==

--_002_532ABFBDAAC3A34EB12EBA6CEC2838F439829D14ADPE2K703adapte_--
