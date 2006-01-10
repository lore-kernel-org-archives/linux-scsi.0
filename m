From: Ashutosh Naik <ashutosh.naik@gmail.com>
Subject: [PATCH] scsi/pcmcia/fdomain_stub.c: Handle scsi_add_host failure
Date: Tue, 10 Jan 2006 18:28:39 +0530
Message-ID: <81083a450601100458u683a3d57g8fb74ebe06c4f2b4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_300_30611764.1136897919708"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zproxy.gmail.com ([64.233.162.201]:9672 "EHLO zproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1750868AbWAJM6l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jan 2006 07:58:41 -0500
Received: by zproxy.gmail.com with SMTP id 14so4510286nzn
        for <linux-scsi@vger.kernel.org>; Tue, 10 Jan 2006 04:58:41 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org

------=_Part_300_30611764.1136897919708
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Add scsi_add_host() failure handling for the  Future Domain-compatible
PCMCIA SCSI driver.

Signed-off-by: Ashutosh Naik <ashutosh.naik@gmail.com>

------=_Part_300_30611764.1136897919708
Content-Type: text/plain; name="pcmcia-fdomain.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="pcmcia-fdomain.txt"

ZGlmZiAtTmF1cnAgbGludXgtMi42LjE1LWdpdDUtdmFuaWxsYS9kcml2ZXJzL3Njc2kvcGNtY2lh
L2Zkb21haW5fc3R1Yi5jIGxpbnV4LTIuNi4xNS1naXQ1L2RyaXZlcnMvc2NzaS9wY21jaWEvZmRv
bWFpbl9zdHViLmMKLS0tIGxpbnV4LTIuNi4xNS1naXQ1LXZhbmlsbGEvZHJpdmVycy9zY3NpL3Bj
bWNpYS9mZG9tYWluX3N0dWIuYwkyMDA2LTAxLTEwIDE2OjI0OjA2LjAwMDAwMDAwMCArMDUzMAor
KysgbGludXgtMi42LjE1LWdpdDUvZHJpdmVycy9zY3NpL3BjbWNpYS9mZG9tYWluX3N0dWIuYwky
MDA2LTAxLTEwIDE4OjE3OjQ3LjAwMDAwMDAwMCArMDUzMApAQCAtMTQzLDYgKzE0Myw3IEBAIHN0
YXRpYyB2b2lkIGZkb21haW5fY29uZmlnKGRldl9saW5rX3QgKmwKICAgICB1X2NoYXIgdHVwbGVf
ZGF0YVs2NF07CiAgICAgY2hhciBzdHJbMTZdOwogICAgIHN0cnVjdCBTY3NpX0hvc3QgKmhvc3Q7
CisgICAgaW50IHJldHZhbDsKIAogICAgIERFQlVHKDAsICJmZG9tYWluX2NvbmZpZygweCVwKVxu
IiwgbGluayk7CiAKQEAgLTE4OCw3ICsxODksMTMgQEAgc3RhdGljIHZvaWQgZmRvbWFpbl9jb25m
aWcoZGV2X2xpbmtfdCAqbAogCWdvdG8gY3NfZmFpbGVkOwogICAgIH0KICAKLSAgICBzY3NpX2Fk
ZF9ob3N0KGhvc3QsIE5VTEwpOyAvKiBYWFggaGFuZGxlIGZhaWx1cmUgKi8KKyAgICByZXR2YWwg
PSBzY3NpX2FkZF9ob3N0KGhvc3QsIE5VTEwpOworICAgIGlmIChyZXR2YWwpIHsKKwlwcmludGso
S0VSTl9XQVJOSU5HICJmZG9tYWluX2NzOiBzY3NpX2FkZF9ob3N0IGZhaWxlZFxuIik7CisJc2Nz
aV9ob3N0X3B1dChob3N0KTsKKwlyZXR1cm4gcmV0dmFsOworICAgIH0KKwogICAgIHNjc2lfc2Nh
bl9ob3N0KGhvc3QpOwogCiAgICAgc3ByaW50ZihpbmZvLT5ub2RlLmRldl9uYW1lLCAic2NzaSVk
IiwgaG9zdC0+aG9zdF9ubyk7Cg==
------=_Part_300_30611764.1136897919708--
