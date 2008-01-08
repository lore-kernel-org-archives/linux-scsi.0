From: "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>
Subject: [PATCH 1/1] aacraid: variable redefinition hides earlier warning
Date: Tue, 8 Jan 2008 12:32:00 -0800
Message-ID: <532ABFBDAAC3A34EB12EBA6CEC2838F40DC64B@ADPE2K703.adaptec.com>
References: <20071031150216.88cecc21.sfr@canb.auug.org.au><20071101173221.2e1fea42.sfr@canb.auug.org.au>
 <jefxzqqeha.fsf@sykes.suse.de>
 <AE4F746F2AECFC4DA4AADD66A1DFEF01F95EF7@otce2k301.adaptec.com>
 <532ABFBDAAC3A34EB12EBA6CEC2838F40FE734@ADPE2K703.adaptec.com>
 <532ABFBDAAC3A34EB12EBA6CEC2838F40FE735@ADPE2K703.adaptec.com>
 <532ABFBDAAC3A34EB12EBA6CEC2838F40FE736@ADPE2K703.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_532ABFBDAAC3A34EB12EBA6CEC2838F40DC64BADPE2K703adaptecc_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([162.62.93.58]:44486 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbYAHUcF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jan 2008 15:32:05 -0500
Received: from ADPE2K701.adaptec.com (adpe2k701.adaptec.com [10.25.8.25])
	by mail-gw3.adaptec.com (Spam Firewall) with ESMTP id C6216220EE9
	for <linux-scsi@vger.kernel.org>; Tue,  8 Jan 2008 12:32:03 -0800 (PST)
In-Reply-To: <532ABFBDAAC3A34EB12EBA6CEC2838F40FE736@ADPE2K703.adaptec.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

--_002_532ABFBDAAC3A34EB12EBA6CEC2838F40DC64BADPE2K703adaptecc_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

The parameter 'info' is reused, renamed the second to sinfo to represent su=
pplemental adapter info, to suppress compile warning message.

This attached patch is against current scsi-misc-2.6.

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's hand=
ling of patch attachments (inline gets damaged, use attachment).

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

 drivers/scsi/aacraid/aachba.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/scsi/aacraid/aachba.c     2008-01-08 15:24:06.451870018 -0500
+++ b/drivers/scsi/aacraid/aachba.c     2008-01-08 15:25:08.971018896 -0500
@@ -1243,24 +1243,24 @@
        memcpy(&dev->adapter_info, info, sizeof(*info));

        if (dev->adapter_info.options & AAC_OPT_SUPPLEMENT_ADAPTER_INFO) {
-               struct aac_supplement_adapter_info * info;
+               struct aac_supplement_adapter_info * sinfo;

                aac_fib_init(fibptr);

-               info =3D (struct aac_supplement_adapter_info *) fib_data(fi=
bptr);
+               sinfo =3D (struct aac_supplement_adapter_info *) fib_data(f=
ibptr);


-               memset(info,0,sizeof(*info));
+               memset(sinfo,0,sizeof(*sinfo));

                rcode =3D aac_fib_send(RequestSupplementAdapterInfo,
                                 fibptr,
-                                sizeof(*info),
+                                sizeof(*sinfo),
                                 FsaNormal,
                                 1, 1,
                                 NULL,
                                 NULL);

                if (rcode >=3D 0)
-                       memcpy(&dev->supplement_adapter_info, info, sizeof(=
*info));
+                       memcpy(&dev->supplement_adapter_info, sinfo, sizeof=
(*sinfo));
        }

Sincerely -- Mark Salyzyn

--_002_532ABFBDAAC3A34EB12EBA6CEC2838F40DC64BADPE2K703adaptecc_
Content-Type: application/octet-stream;
	name="aacraid_info_var_hides_warning.patch"
Content-Description: aacraid_info_var_hides_warning.patch
Content-Disposition: attachment;
	filename="aacraid_info_var_hides_warning.patch"; size=1016;
	creation-date="Tue, 08 Jan 2008 12:25:56 GMT";
	modification-date="Tue, 08 Jan 2008 12:25:56 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtcnUgYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9hYWNoYmEuYyBiL2RyaXZlcnMvc2NzaS9h
YWNyYWlkL2FhY2hiYS5jCi0tLSBhL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2FhY2hiYS5jCTIwMDgt
MDEtMDggMTU6MjQ6MDYuNDUxODcwMDE4IC0wNTAwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlk
L2FhY2hiYS5jCTIwMDgtMDEtMDggMTU6MjU6MDguOTcxMDE4ODk2IC0wNTAwCkBAIC0xMjQzLDI0
ICsxMjQzLDI0IEBACiAJbWVtY3B5KCZkZXYtPmFkYXB0ZXJfaW5mbywgaW5mbywgc2l6ZW9mKCpp
bmZvKSk7CiAKIAlpZiAoZGV2LT5hZGFwdGVyX2luZm8ub3B0aW9ucyAmIEFBQ19PUFRfU1VQUExF
TUVOVF9BREFQVEVSX0lORk8pIHsKLQkJc3RydWN0IGFhY19zdXBwbGVtZW50X2FkYXB0ZXJfaW5m
byAqIGluZm87CisJCXN0cnVjdCBhYWNfc3VwcGxlbWVudF9hZGFwdGVyX2luZm8gKiBzaW5mbzsK
IAogCQlhYWNfZmliX2luaXQoZmlicHRyKTsKIAotCQlpbmZvID0gKHN0cnVjdCBhYWNfc3VwcGxl
bWVudF9hZGFwdGVyX2luZm8gKikgZmliX2RhdGEoZmlicHRyKTsKKwkJc2luZm8gPSAoc3RydWN0
IGFhY19zdXBwbGVtZW50X2FkYXB0ZXJfaW5mbyAqKSBmaWJfZGF0YShmaWJwdHIpOwogCi0JCW1l
bXNldChpbmZvLDAsc2l6ZW9mKCppbmZvKSk7CisJCW1lbXNldChzaW5mbywwLHNpemVvZigqc2lu
Zm8pKTsKIAogCQlyY29kZSA9IGFhY19maWJfc2VuZChSZXF1ZXN0U3VwcGxlbWVudEFkYXB0ZXJJ
bmZvLAogCQkJCSBmaWJwdHIsCi0JCQkJIHNpemVvZigqaW5mbyksCisJCQkJIHNpemVvZigqc2lu
Zm8pLAogCQkJCSBGc2FOb3JtYWwsCiAJCQkJIDEsIDEsCiAJCQkJIE5VTEwsCiAJCQkJIE5VTEwp
OwogCiAJCWlmIChyY29kZSA+PSAwKQotCQkJbWVtY3B5KCZkZXYtPnN1cHBsZW1lbnRfYWRhcHRl
cl9pbmZvLCBpbmZvLCBzaXplb2YoKmluZm8pKTsKKwkJCW1lbWNweSgmZGV2LT5zdXBwbGVtZW50
X2FkYXB0ZXJfaW5mbywgc2luZm8sIHNpemVvZigqc2luZm8pKTsKIAl9CiAKIAo=

--_002_532ABFBDAAC3A34EB12EBA6CEC2838F40DC64BADPE2K703adaptecc_--
