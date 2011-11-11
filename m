From: Vasily Averin <vvs@parallels.com>
Subject: [patch] aacraid: controller hangs if kernel uses non-default ASPM
 policy
Date: Fri, 11 Nov 2011 13:42:16 +0400
Message-ID: <4EBCEDF8.2090403@parallels.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060209040603010901080201"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:36189 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513Ab1KKJmj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Nov 2011 04:42:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Adaptec OEM Raid Solutions <aacraid@adaptec.com>
Cc: Matthew Garrett <mjg@redhat.com>, James Bottomley <jbottomley@parallels.com>, Mark Salyzyn <mark_salyzyn@us.xyratex.com>

This is a multi-part message in MIME format.
--------------060209040603010901080201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Patch from RHEL6 kernel
- [scsi] aacraid: Disable ASPM by default (Matthew Garrett) [599735]
aacraid controller hangs if kernel uses non-default ASPM policy

Signed-off-by:	Vasily Averin <vvs@sw.ru>
CC: Matthew Garrett <mjg@redhat.com>

--------------060209040603010901080201
Content-Type: text/plain;
 name="diff-v31-aacraid-aspm-disable-20111110"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="diff-v31-aacraid-aspm-disable-20111110"

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2xpbml0LmMgYi9kcml2ZXJzL3Nj
c2kvYWFjcmFpZC9saW5pdC5jCmluZGV4IDMzODI0NzUuLmM3YjZmZWQgMTAwNjQ0Ci0tLSBh
L2RyaXZlcnMvc2NzaS9hYWNyYWlkL2xpbml0LmMKKysrIGIvZHJpdmVycy9zY3NpL2FhY3Jh
aWQvbGluaXQuYwpAQCAtMzgsNiArMzgsNyBAQAogI2luY2x1ZGUgPGxpbnV4L21vZHVsZS5o
PgogI2luY2x1ZGUgPGxpbnV4L21vZHVsZXBhcmFtLmg+CiAjaW5jbHVkZSA8bGludXgvcGNp
Lmg+CisjaW5jbHVkZSA8bGludXgvcGNpLWFzcG0uaD4KICNpbmNsdWRlIDxsaW51eC9zbGFi
Lmg+CiAjaW5jbHVkZSA8bGludXgvbXV0ZXguaD4KICNpbmNsdWRlIDxsaW51eC9zcGlubG9j
ay5oPgpAQCAtMTEwOCw2ICsxMTA5LDkgQEAgc3RhdGljIGludCBfX2RldmluaXQgYWFjX3By
b2JlX29uZShzdHJ1Y3QgcGNpX2RldiAqcGRldiwKIAkJdW5pcXVlX2lkKys7CiAJfQogCisJ
cGNpX2Rpc2FibGVfbGlua19zdGF0ZShwZGV2LCBQQ0lFX0xJTktfU1RBVEVfTDBTIHwgUENJ
RV9MSU5LX1NUQVRFX0wxIHwKKwkJCSAgICAgICBQQ0lFX0xJTktfU1RBVEVfQ0xLUE0pOwor
CiAJZXJyb3IgPSBwY2lfZW5hYmxlX2RldmljZShwZGV2KTsKIAlpZiAoZXJyb3IpCiAJCWdv
dG8gb3V0Owo=
--------------060209040603010901080201--
