From: "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>
Subject: [PATCH 1/1] aacraid: add sysfs report of RAID level
Date: Tue, 8 Jan 2008 12:23:49 -0800
Message-ID: <532ABFBDAAC3A34EB12EBA6CEC2838F40DC637@ADPE2K703.adaptec.com>
References: <20071031150216.88cecc21.sfr@canb.auug.org.au><20071101173221.2e1fea42.sfr@canb.auug.org.au>
 <jefxzqqeha.fsf@sykes.suse.de>
 <AE4F746F2AECFC4DA4AADD66A1DFEF01F95EF7@otce2k301.adaptec.com>
 <532ABFBDAAC3A34EB12EBA6CEC2838F40FE734@ADPE2K703.adaptec.com>
 <532ABFBDAAC3A34EB12EBA6CEC2838F40FE735@ADPE2K703.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_532ABFBDAAC3A34EB12EBA6CEC2838F40DC637ADPE2K703adaptecc_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([162.62.93.58]:44296 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbYAHUXy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jan 2008 15:23:54 -0500
Received: from ADPE2K701.adaptec.com (adpe2k701.adaptec.com [10.25.8.25])
	by mail-gw3.adaptec.com (Spam Firewall) with ESMTP id 745F5221235
	for <linux-scsi@vger.kernel.org>; Tue,  8 Jan 2008 12:23:53 -0800 (PST)
In-Reply-To: <532ABFBDAAC3A34EB12EBA6CEC2838F40FE735@ADPE2K703.adaptec.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

--_002_532ABFBDAAC3A34EB12EBA6CEC2838F40DC637ADPE2K703adaptecc_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Report the RAID level string for the SCSI device representing the array. Re=
port is in /sys/class/scsi_device/#:#:#:#/device/level.

This attached patch is against current scsi-misc-2.6.

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's hand=
ling of patch attachments.

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

 drivers/scsi/aacraid/aachba.c  |    7 ++++++-
 drivers/scsi/aacraid/aacraid.h |    1 +
 drivers/scsi/aacraid/linit.c   |   25 +++++++++++++++++++++++++
 3 files changed, 32 insertions(+), 1 deletion(-)

Sincerely -- Mark Salyzyn

--_002_532ABFBDAAC3A34EB12EBA6CEC2838F40DC637ADPE2K703adaptecc_
Content-Type: application/octet-stream;
	name="aacraid_sysfs_raid_level.patch"
Content-Description: aacraid_sysfs_raid_level.patch
Content-Disposition: attachment; filename="aacraid_sysfs_raid_level.patch";
	size=2353; creation-date="Tue, 08 Jan 2008 12:17:12 GMT";
	modification-date="Tue, 08 Jan 2008 12:17:12 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtcnUgYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9hYWNoYmEuYyBiL2RyaXZlcnMvc2NzaS9h
YWNyYWlkL2FhY2hiYS5jCi0tLSBhL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2FhY2hiYS5jCTIwMDgt
MDEtMDggMTU6MTA6MDIuODk0NjczMzY4IC0wNTAwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlk
L2FhY2hiYS5jCTIwMDgtMDEtMDggMTU6MTY6MjMuNTEzOTY1Mzk2IC0wNTAwCkBAIC02OTMsNyAr
NjkzLDEyIEBACiAgICAgICAgICJVbmtub3duIgogfTsKIAotCitjaGFyICogZ2V0X2NvbnRhaW5l
cl90eXBlKHVuc2lnbmVkIHRpbmRleCkKK3sKKwlpZiAodGluZGV4ID49IEFSUkFZX1NJWkUoY29u
dGFpbmVyX3R5cGVzKSkKKwkJdGluZGV4ID0gQVJSQVlfU0laRShjb250YWluZXJfdHlwZXMpIC0g
MTsKKwlyZXR1cm4gY29udGFpbmVyX3R5cGVzW3RpbmRleF07Cit9CiAKIC8qIEZ1bmN0aW9uOiBz
ZXRpbnFzdHIKICAqCmRpZmYgLXJ1IGEvZHJpdmVycy9zY3NpL2FhY3JhaWQvYWFjcmFpZC5oIGIv
ZHJpdmVycy9zY3NpL2FhY3JhaWQvYWFjcmFpZC5oCi0tLSBhL2RyaXZlcnMvc2NzaS9hYWNyYWlk
L2FhY3JhaWQuaAkyMDA4LTAxLTA4IDE1OjEwOjAyLjg5NDY3MzM2OCAtMDUwMAorKysgYi9kcml2
ZXJzL3Njc2kvYWFjcmFpZC9hYWNyYWlkLmgJMjAwOC0wMS0wOCAxNToxNjoyMy41MTQ5NjUyNzEg
LTA1MDAKQEAgLTE4NjksNiArMTg2OSw3IEBACiBpbnQgX2FhY19yeF9pbml0KHN0cnVjdCBhYWNf
ZGV2ICpkZXYpOwogaW50IGFhY19yeF9zZWxlY3RfY29tbShzdHJ1Y3QgYWFjX2RldiAqZGV2LCBp
bnQgY29tbSk7CiBpbnQgYWFjX3J4X2RlbGl2ZXJfcHJvZHVjZXIoc3RydWN0IGZpYiAqIGZpYik7
CitjaGFyICogZ2V0X2NvbnRhaW5lcl90eXBlKHVuc2lnbmVkIHR5cGUpOwogZXh0ZXJuIGludCBu
dW1hY2I7CiBleHRlcm4gaW50IGFjYnNpemU7CiBleHRlcm4gY2hhciBhYWNfZHJpdmVyX3ZlcnNp
b25bXTsKZGlmZiAtcnUgYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9saW5pdC5jIGIvZHJpdmVycy9z
Y3NpL2FhY3JhaWQvbGluaXQuYwotLS0gYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9saW5pdC5jCTIw
MDgtMDEtMDggMTU6MTA6MDIuODk2NjczMTE4IC0wNTAwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNy
YWlkL2xpbml0LmMJMjAwOC0wMS0wOCAxNToxNjoyMy41MTU5NjUxNDUgLTA1MDAKQEAgLTQ4Nyw2
ICs0ODcsMzAgQEAKIAlyZXR1cm4gc2Rldi0+cXVldWVfZGVwdGg7CiB9CiAKK3N0YXRpYyBzc2l6
ZV90IGFhY19zaG93X3JhaWRfbGV2ZWwoc3RydWN0IGRldmljZSAqZGV2LCBzdHJ1Y3QgZGV2aWNl
X2F0dHJpYnV0ZSAqYXR0ciwgY2hhciAqYnVmKQoreworCXN0cnVjdCBzY3NpX2RldmljZSAqIHNk
ZXYgPSB0b19zY3NpX2RldmljZShkZXYpOworCWlmIChzZGV2X2NoYW5uZWwoc2RldikgIT0gQ09O
VEFJTkVSX0NIQU5ORUwpCisJCXJldHVybiBzbnByaW50ZihidWYsIFBBR0VfU0laRSwgc2Rldi0+
bm9fdWxkX2F0dGFjaAorCQkgID8gIkhpZGRlblxuIiA6ICJKQk9EIik7CisJcmV0dXJuIHNucHJp
bnRmKGJ1ZiwgUEFHRV9TSVpFLCAiJXNcbiIsCisJICBnZXRfY29udGFpbmVyX3R5cGUoKChzdHJ1
Y3QgYWFjX2RldiAqKShzZGV2LT5ob3N0LT5ob3N0ZGF0YSkpCisJICAgIC0+ZnNhX2RldltzZGV2
X2lkKHNkZXYpXS50eXBlKSk7Cit9CisKK3N0YXRpYyBzdHJ1Y3QgZGV2aWNlX2F0dHJpYnV0ZSBh
YWNfcmFpZF9sZXZlbF9hdHRyID0geworCS5hdHRyID0geworCQkubmFtZSA9ICJsZXZlbCIsCisJ
CS5tb2RlID0gU19JUlVHTywKKwl9LAorCS5zaG93ID0gYWFjX3Nob3dfcmFpZF9sZXZlbAorfTsK
Kworc3RhdGljIHN0cnVjdCBkZXZpY2VfYXR0cmlidXRlICphYWNfZGV2X2F0dHJzW10gPSB7CisJ
JmFhY19yYWlkX2xldmVsX2F0dHIsCisJTlVMTCwKK307CisKIHN0YXRpYyBpbnQgYWFjX2lvY3Rs
KHN0cnVjdCBzY3NpX2RldmljZSAqc2RldiwgaW50IGNtZCwgdm9pZCBfX3VzZXIgKiBhcmcpCiB7
CiAJc3RydWN0IGFhY19kZXYgKmRldiA9IChzdHJ1Y3QgYWFjX2RldiAqKXNkZXYtPmhvc3QtPmhv
c3RkYXRhOwpAQCAtOTQxLDYgKzk2NSw3IEBACiAJLnNob3N0X2F0dHJzCQkJPSBhYWNfYXR0cnMs
CiAJLnNsYXZlX2NvbmZpZ3VyZQkJPSBhYWNfc2xhdmVfY29uZmlndXJlLAogCS5jaGFuZ2VfcXVl
dWVfZGVwdGgJCT0gYWFjX2NoYW5nZV9xdWV1ZV9kZXB0aCwKKwkuc2Rldl9hdHRycwkJCT0gYWFj
X2Rldl9hdHRycywKIAkuZWhfYWJvcnRfaGFuZGxlcgkJPSBhYWNfZWhfYWJvcnQsCiAJLmVoX2hv
c3RfcmVzZXRfaGFuZGxlcgkJPSBhYWNfZWhfcmVzZXQsCiAJLmNhbl9xdWV1ZSAgICAgIAkJPSBB
QUNfTlVNX0lPX0ZJQiwJCg==

--_002_532ABFBDAAC3A34EB12EBA6CEC2838F40DC637ADPE2K703adaptecc_--
