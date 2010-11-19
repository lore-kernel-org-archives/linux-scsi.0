From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: [PATCH 3/9] scsi: megaraid_sas - Driver will scan device after
 receive event MR_EVT_LD_STATE_CHANGE
Date: Fri, 19 Nov 2010 10:03:16 -0700
Message-ID: <4B6A08C587958942AA3002690DD4F8C30106A961E4@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C3D0804533@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C3DBD67F68@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C30106A961BD@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C30106A961D6@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_4B6A08C587958942AA3002690DD4F8C30106A961E4cosmail02lsic_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog106.obsmtp.com ([74.125.149.77]:56119 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754539Ab0KSRDG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Nov 2010 12:03:06 -0500
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C30106A961D6@cosmail02.lsi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>, "'James.Bottomley@HansenPartnership.com'" <James.Bottomley@HansenPartnership.com>, "'James.Bottomley@suse.de'" <James.Bottomley@suse.de>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'akpm@osdl.org'" <akpm@osdl.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "Daftardar, Jayant" <Jayant.Daftardar@lsi.com>, Tomas Henzl <thenzl@redhat.com>, "Karlikova, Lenka" <Lenka.Karlikova@lsi.com>, "Nielson, Mike" <Mike.Nielson@lsi.com>, "Jablonski, Charles" <Charles.Jablonski@lsi.com>

--_002_4B6A08C587958942AA3002690DD4F8C30106A961E4cosmail02lsic_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Driver will scan devices after receive event code MR_EVT_LD_STATE_CHANGE fr=
om megasas fw

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
drivers/scsi/megaraid/megaraid_sas.c |    1 +
 1 file changed, 1 insertion(+)

--_002_4B6A08C587958942AA3002690DD4F8C30106A961E4cosmail02lsic_
Content-Type: application/octet-stream; name="megasas-p3.patch"
Content-Description: megasas-p3.patch
Content-Disposition: attachment; filename="megasas-p3.patch"; size=482;
	creation-date="Thu, 18 Nov 2010 20:37:02 GMT";
	modification-date="Wed, 17 Nov 2010 13:09:11 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtcnVwTiBvbGQvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhcy5jIG5ldy9k
cml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzLmMKLS0tIG9sZC9kcml2ZXJzL3Njc2kv
bWVnYXJhaWQvbWVnYXJhaWRfc2FzLmMJMjAxMC0xMS0xNCAxNTozNzoyMS4wMDAwMDAwMDAgLTA1
MDAKKysrIG5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzLmMJMjAxMC0xMS0x
NCAxNTozODowMC4wMDAwMDAwMDAgLTA1MDAKQEAgLTQ5OTAsNiArNDk5MCw3IEBAIG1lZ2FzYXNf
YWVuX3BvbGxpbmcoc3RydWN0IHdvcmtfc3RydWN0ICoKIAkJCWJyZWFrOwogCQljYXNlIE1SX0VW
VF9DVFJMX0hPU1RfQlVTX1NDQU5fUkVRVUVTVEVEOgogCQljYXNlIE1SX0VWVF9GT1JFSUdOX0NG
R19JTVBPUlRFRDoKKwkJY2FzZSBNUl9FVlRfTERfU1RBVEVfQ0hBTkdFOgogCQkJZG9zY2FuID0g
MTsKIAkJCWJyZWFrOwogCQlkZWZhdWx0Ogo=

--_002_4B6A08C587958942AA3002690DD4F8C30106A961E4cosmail02lsic_--
