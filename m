From: "Alexander Stohr" <Alexander.Stohr@gmx.de>
Subject: Patch for LSI Logic Fusion MPT
Date: Tue, 9 Mar 2004 18:51:52 +0100 (MET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <14878.1078854712@www53.gmx.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="========GMXBoundary148781078854712"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.de ([213.165.64.20]:20907 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S261892AbUCIRvy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Mar 2004 12:51:54 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: mpt_linux_developer@lsil.com, sjralston1@netscape.net

This is a MIME encapsulated multipart message -
please use a MIME-compliant e-mail program to open it.

Dies ist eine mehrteilige Nachricht im MIME-Format -
bitte verwenden Sie zum Lesen ein MIME-konformes Mailprogramm.

--========GMXBoundary148781078854712
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

Hello,

the below attached patch does fix a warning
when the LSI MPT  driver is compiled into the kernel.
The patch is made against Kernel 2.6.4-rc2.
Please apply. Thanks.

-Alex.

-- 
+++ NEU bei GMX und erstmalig in Deutschland: TÜV-geprüfter Virenschutz +++
100% Virenerkennung nach Wildlist. Infos: http://www.gmx.net/virenschutz
--========GMXBoundary148781078854712
Content-Type: application/octet-stream; name="mpt-module-fix.diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="mpt-module-fix.diff"

LS0tIGxpbnV4LTIuNi40LXJjMi5vcmlnL2RyaXZlcnMvbWVzc2FnZS9mdXNpb24vbXB0c2NzaWgu
YwkyMDA0LTAzLTA0IDEwOjMyOjAzLjAwMDAwMDAwMCArMDEwMAorKysgbGludXgtMi42LjQtcmMy
L2RyaXZlcnMvbWVzc2FnZS9mdXNpb24vbXB0c2NzaWguYwkyMDA0LTAzLTA4IDEyOjA2OjQ5LjAw
MDAwMDAwMCArMDEwMApAQCAtMTk0LDcgKzE5NCw5IEBACiBzdGF0aWMgdm9pZAltcHRzY3NpaF9k
dl9wYXJtcyhNUFRfU0NTSV9IT1NUICpoZCwgRFZQQVJBTUVURVJTICpkdix2b2lkICpwUGFnZSk7
CiBzdGF0aWMgdm9pZAltcHRzY3NpaF9maWxsYnVmKGNoYXIgKmJ1ZmZlciwgaW50IHNpemUsIGlu
dCBpbmRleCwgaW50IHdpZHRoKTsKICNlbmRpZgorI2lmZGVmIE1PRFVMRQogc3RhdGljIGludAlt
cHRzY3NpaF9zZXR1cChjaGFyICpzdHIpOworI2VuZGlmCiAKIC8qIG1vZHVsZSBlbnRyeSBwb2lu
dCAqLwogc3RhdGljIGludCAgX19pbml0ICAgbXB0c2NzaWhfaW5pdCAgKHZvaWQpOwpAQCAtNzA4
MywxNyArNzA4NSwyMCBAQAogI2RlZmluZQlBUkdfU0VQCScsJwogI2VuZGlmCiAKKyNpZmRlZiBN
T0RVTEUKIHN0YXRpYyBjaGFyIHNldHVwX3Rva2VuW10gX19pbml0ZGF0YSA9CiAJImR2OiIKIAki
d2lkdGg6IgogCSJmYWN0b3I6IgogICAgICAgIDsJLyogRE9OTk9UIFJFTU9WRSBUSElTICc7JyAq
LworI2VuZGlmCiAKICNkZWZpbmUgT1BUX0RWCQkJMQogI2RlZmluZSBPUFRfTUFYX1dJRFRICQky
CiAjZGVmaW5lIE9QVF9NSU5fU1lOQ19GQUNUT1IJMwogCiAvKj0tPS09LT0tPS09LT0tPS09LT0t
PS09LT0tPS09LT0tPS09Ki8KKyNpZmRlZiBNT0RVTEUKIHN0YXRpYyBpbnQKIGdldF9zZXR1cF90
b2tlbihjaGFyICpwKQogewpAQCAtNzE1OCw2ICs3MTYzLDcgQEAKIAl9CiAJcmV0dXJuIDE7CiB9
CisjZW5kaWYKIAogLyo9LT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09
LT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0qLwogCg==

--========GMXBoundary148781078854712--

