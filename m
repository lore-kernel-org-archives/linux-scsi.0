From: majianpeng <majianpeng@gmail.com>
Subject: [PATCH 4/6] scsi-mq: init sg in scsi_init_io.
Date: Fri, 29 Nov 2013 16:42:12 +0800
Message-ID: <201311291642081351818@gmail.com>
Reply-To: majianpeng <majianpeng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:48008 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab3K2ImT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Nov 2013 03:42:19 -0500
Received: by mail-pd0-f180.google.com with SMTP id q10so13417664pdj.11
        for <linux-scsi@vger.kernel.org>; Fri, 29 Nov 2013 00:42:18 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

TWFrZSBzY3NpLW1xIHN1cHBvcnQgYmxrLXBjLWNvbW1hbmQuDQoNClNpZ25lZC1vZmYtYnk6IEpp
YW5wZW5nIE1hIDxtYWppYW5wZW5nQGdtYWlsLmNvbT4NCi0tLQ0KIGRyaXZlcnMvc2NzaS9zY3Np
X2xpYi5jIHwgICAgNCArKystDQogMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMSBk
ZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Njc2lfbGliLmMgYi9kcml2
ZXJzL3Njc2kvc2NzaV9saWIuYw0KaW5kZXggYmVkNTk2ZS4uNjc5ZTg0MCAxMDA2NDQNCi0tLSBh
L2RyaXZlcnMvc2NzaS9zY3NpX2xpYi5jDQorKysgYi9kcml2ZXJzL3Njc2kvc2NzaV9saWIuYw0K
QEAgLTEwNTksOSArMTA1OSwxMSBAQCBpbnQgc2NzaV9pbml0X2lvKHN0cnVjdCBzY3NpX2NtbmQg
KmNtZCwgZ2ZwX3QgZ2ZwX21hc2spDQogCS8qDQogCSAqIFVzZSBwcmUtYWxsb2NhdGlvbiBvZiBj
bWQtPnNkYiBzY2F0dGVybGlzdHMgd2l0aCBzY3NpLW1xLi4NCiAJICovDQotLy9GSVhNRTogc2Nz
aS1tcSBkaWYgZGVzY3JpcHRvciBpbml0IHdpdGhpbiBzY3NpX2luaXRfaW8NCiAJaWYgKHJxLT5t
cV9jdHgpIHsNCiAJCUJVR19PTihycS0+bnJfcGh5c19zZWdtZW50cyA+IFNDU0lfTUFYX1NHX1NF
R01FTlRTKTsNCisJCWNtZC0+c2RiLnRhYmxlLnNnbCA9IGNtZC0+bXFfc2dsOw0KKwkJY21kLT5z
ZGIudGFibGUubmVudHMgPSBycS0+bnJfcGh5c19zZWdtZW50czsNCisJCXNnX2luaXRfdGFibGUo
Y21kLT5zZGIudGFibGUuc2dsLCBycS0+bnJfcGh5c19zZWdtZW50cyk7DQogCQlzY3NpX2luaXRf
c2d0YWJsZShycSwgJmNtZC0+c2RiKTsNCiAJCXJldHVybiBCTEtQUkVQX09LOw0KIAl9DQotLSAN
CjEuNy4xMC40DQo=

