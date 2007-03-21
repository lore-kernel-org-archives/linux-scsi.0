From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: [PATCH] aacraid: check buffer address in aac_internal_transfer
Date: Wed, 21 Mar 2007 13:22:56 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF0172BE7C@otce2k301.adaptec.com>
References: <1173988507.30374.33.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C76BDD.924CC06E"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:47728 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933191AbXCURXA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Mar 2007 13:23:00 -0400
Received: from otce2k301.adaptec.com (otce2k301.adaptec.com [10.12.1.97])
	by mail-gw3.adaptec.com (Spam Firewall) with ESMTP id AAA2418191E
	for <linux-scsi@vger.kernel.org>; Wed, 21 Mar 2007 10:22:59 -0700 (PDT)
Content-class: urn:content-classes:message
In-Reply-To: <1173988507.30374.33.camel@markh3.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.

------_=_NextPart_001_01C76BDD.924CC06E
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Captured a panic on an older kernel where an application issuing
commands via sg was sending requests that lacked a request_buffer, thus
the buffer pointer used in aac_internal_transer was NULL. The
application was fixed closing the issue, but felt it was advised to
immunize the driver against the eventuality.

This attached patch is against current scsi-misc-2.6

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

---

Sincerely -- Mark Salyzyn

------_=_NextPart_001_01C76BDD.924CC06E
Content-Type: application/octet-stream;
	name="aacraid_aac_internal_transfer.patch"
Content-Transfer-Encoding: base64
Content-Description: aacraid_aac_internal_transfer.patch
Content-Disposition: attachment;
	filename="aacraid_aac_internal_transfer.patch"

ZGlmZiAtcnUgYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9hYWNoYmEuYyBiL2RyaXZlcnMvc2NzaS9h
YWNyYWlkL2FhY2hiYS5jCi0tLSBhL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2FhY2hiYS5jCTIwMDct
MDMtMjEgMTI6MTU6MjkuODQ0MDUzMDQ1IC0wNDAwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlk
L2FhY2hiYS5jCTIwMDctMDMtMjEgMTI6MjE6MjIuMjk3OTczMTk1IC0wNDAwCkBAIC0zNTAsOCAr
MzUwLDkgQEAKIAkJYnVmID0gc2NzaWNtZC0+cmVxdWVzdF9idWZmZXI7CiAJCXRyYW5zZmVyX2xl
biA9IG1pbihzY3NpY21kLT5yZXF1ZXN0X2J1ZmZsZW4sIGxlbiArIG9mZnNldCk7CiAJfQotCi0J
bWVtY3B5KGJ1ZiArIG9mZnNldCwgZGF0YSwgdHJhbnNmZXJfbGVuIC0gb2Zmc2V0KTsKKwl0cmFu
c2Zlcl9sZW4gLT0gb2Zmc2V0OworCWlmIChidWYgJiYgdHJhbnNmZXJfbGVuKQorCQltZW1jcHko
YnVmICsgb2Zmc2V0LCBkYXRhLCB0cmFuc2Zlcl9sZW4pOwogCiAJaWYgKHNjc2ljbWQtPnVzZV9z
ZykgCiAJCWt1bm1hcF9hdG9taWMoYnVmIC0gc2ctPm9mZnNldCwgS01fSVJRMCk7Cg==

------_=_NextPart_001_01C76BDD.924CC06E--
