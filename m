From: Tobias Lieber <little.tobias@gmx.de>
Subject: Patch for iriver-mp3player
Date: Sun, 30 May 2004 01:42:55 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040530014255.3876eea3.little.tobias@gmx.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Sun__30_May_2004_01_42_55_+0200_UenZ84/HHprINkvQ"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.de ([213.165.64.20]:38547 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S261206AbUE2XnV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 May 2004 19:43:21 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

--Multipart=_Sun__30_May_2004_01_42_55_+0200_UenZ84/HHprINkvQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi

i Javier Marcet wrote in January 2004 a patch for linux-2.6.3, to make a i-River-mp3-Player mounting. It was on lkml: http://lkml.org/lkml/2004/1/6/170
i was suprised, that it was not in the kernel, and no other soulution, too. So i read his patch for getting mouted the player, and rewrote it for linux-2.6.7-rc1-bk7. I attached it. It would be nice, if it would be possible mounting the mp3-player without patching the Kernel, so i would greet it, if this or an other solution woulg com into the Kernel.

greetings

Tobias Lieber

--Multipart=_Sun__30_May_2004_01_42_55_+0200_UenZ84/HHprINkvQ
Content-Type: application/octet-stream;
 name="patch-iriver"
Content-Disposition: attachment;
 filename="patch-iriver"
Content-Transfer-Encoding: base64

LS0tIGxpbnV4LTIuNi42L2luY2x1ZGUvc2NzaS9zY3NpX2RldmluZm8uaAkyMDA0LTA1LTMwIDAw
OjEyOjEwLjA1MDc0NjY5NiArMDIwMAorKysgbGludXhfcGF0Y2hlZC9pbmNsdWRlL3Njc2kvc2Nz
aV9kZXZpbmZvLmgJMjAwNC0wNS0zMCAwMDoxOToyMy44OTg3OTE3NjggKzAyMDAKQEAgLTI0LDQg
KzI0LDUgQEAKICNkZWZpbmUgQkxJU1RfUkVQT1JUTFVOMgkweDIwMDAwCS8qIHRyeSBSRVBPUlRf
TFVOUyBldmVuIGZvciBTQ1NJLTIgZGV2cwogIAkJCQkJICAgKGlmIEhCQSBzdXBwb3J0cyBtb3Jl
IHRoYW4gOCBMVU5zKSAqLwogI2RlZmluZSBCTElTVF9OT1JFUE9SVExVTgkweDQwMDAwCS8qIGRv
bid0IHRyeSBSRVBPUlRfTFVOUyBzY2FuIChTQ1NJLTMgZGV2cykgKi8KKyNkZWZpbmUgQkxJU1Rf
Tk9STUIgICAgICAgICAgICAgMHg4MDAwMCAvKiBLbm93biB0byBiZSBub3QgcmVtb3ZhYmxlKi8K
ICNlbmRpZgotLS0gbGludXgtMi42LjYvZHJpdmVycy9zY3NpL3Njc2lfZGV2aW5mby5jCTIwMDQt
MDUtMTAgMDQ6MzI6MjcuMDAwMDAwMDAwICswMjAwCisrKyBsaW51eF9wYXRjaGVkL2RyaXZlcnMv
c2NzaS9zY3NpX2RldmluZm8uYwkyMDA0LTA1LTMwIDAwOjE0OjAwLjM4Mjk3MzY0OCArMDIwMApA
QCAtMTgzLDYgKzE4Myw3IEBACiAJeyJUT1NISUJBIiwgIkNEUk9NIiwgTlVMTCwgQkxJU1RfSVNS
T019LAogCXsiVE9TSElCQSIsICJDRC1ST00iLCBOVUxMLCBCTElTVF9JU1JPTX0sCiAJeyJYWVJB
VEVYIiwgIlJTIiwgIioiLCBCTElTVF9TUEFSU0VMVU4gfCBCTElTVF9MQVJHRUxVTn0sCisgICAg
ICAgIHsiaVJpdmVyIiwgImlGUCBNYXNzIERyaXZlciIsIE5VTEwsIEJMSVNUX05PUk1CfSwKIAl7
Ilp6eXp4IiwgIlJvY2tldFN0b3IgNTAwUyIsIE5VTEwsIEJMSVNUX1NQQVJTRUxVTn0sCiAJeyJa
enl6eCIsICJSb2NrZXRTdG9yIDIwMDAiLCBOVUxMLCBCTElTVF9TUEFSU0VMVU59LAogCXsgTlVM
TCwgTlVMTCwgTlVMTCwgMCB9LAotLS0gbGludXgtMi42LjYvZHJpdmVycy9zY3NpL3Njc2lfc2Nh
bi5jCTIwMDQtMDUtMzAgMDA6MTI6MDcuOTExMDcxOTc2ICswMjAwCisrKyBsaW51eF9wYXRjaGVk
L2RyaXZlcnMvc2NzaS9zY3NpX3NjYW4uYwkyMDA0LTA1LTMwIDAwOjE4OjMwLjY5NDg3OTk5MiAr
MDIwMApAQCAtNTY1LDcgKzU2NSw3IEBACiAJICovIAogCiAJc2Rldi0+aW5xX3BlcmlwaF9xdWFs
ID0gKGlucV9yZXN1bHRbMF0gPj4gNSkgJiA3OwotCXNkZXYtPnJlbW92YWJsZSA9ICgweDgwICYg
aW5xX3Jlc3VsdFsxXSkgPj4gNzsKKwlzZGV2LT5yZW1vdmFibGUgPSAoKCgweDgwICYgaW5xX3Jl
c3VsdFsxXSkgPj4gNykgJiYgISgqYmZsYWdzICZCTElTVF9OT1JNQikpOwogCXNkZXYtPmxvY2th
YmxlID0gc2Rldi0+cmVtb3ZhYmxlOwogCXNkZXYtPnNvZnRfcmVzZXQgPSAoaW5xX3Jlc3VsdFs3
XSAmIDEpICYmICgoaW5xX3Jlc3VsdFszXSAmIDcpID09IDIpOwogCg==

--Multipart=_Sun__30_May_2004_01_42_55_+0200_UenZ84/HHprINkvQ--
