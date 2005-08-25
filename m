From: "Johann Hanne" <jhml@gmx.net>
Subject: =?ISO-8859-1?Q?[patch]_reenable_megaraid_legacy_driver?=
Date: Thu, 25 Aug 2005 15:52:03 +0200 (MEST)
Message-ID: <1399.1124977923@www79.gmx.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="========GMXBoundary13991124977923"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imap.gmx.net ([213.165.64.20]:61656 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S964991AbVHYNwE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Aug 2005 09:52:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a MIME encapsulated multipart message -
please use a MIME-compliant e-mail program to open it.

Dies ist eine mehrteilige Nachricht im MIME-Format -
bitte verwenden Sie zum Lesen ein MIME-konformes Mailprogramm.

--========GMXBoundary13991124977923
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

this re-enables the megaraid legacy driver (drivers/scsi/megaraid.c) which
is still completely in the kernel but is missing from drivers/scsi/Kconfig.
Some devices are NOT supported by the newgen megaraid driver (e.g. the HP
Netserver LH 3000 embedded Netraid) and the old driver still works fine with
them, so I see no reason to not supported it!?

Cheers, Johann
--========GMXBoundary13991124977923
Content-Type: application/octet-stream; name="reenable-megaraid-legacy.diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="reenable-megaraid-legacy.diff"

LS0tIG5ldHdhdGNoMDItMi42LjEyLjUvZHJpdmVycy9zY3NpL0tjb25maWcub3JpZwkyMDA1LTA4
LTI1IDE1OjI4OjE4LjAwMDAwMDAwMCArMDIwMAorKysgbmV0d2F0Y2gwMi0yLjYuMTIuNS9kcml2
ZXJzL3Njc2kvS2NvbmZpZwkyMDA1LTA4LTI1IDE1OjI4OjM3LjAwMDAwMDAwMCArMDIwMApAQCAt
NDAzLDYgKzQwMywxMCBAQAogCSAgVG8gY29tcGlsZSB0aGlzIGRyaXZlciBhcyBhIG1vZHVsZSwg
Y2hvb3NlIE0gaGVyZTogdGhlCiAJICBtb2R1bGUgd2lsbCBiZSBjYWxsZWQgaW4yMDAwLgogCitj
b25maWcgTUVHQVJBSURfTEVHQUNZCisgICAgICAgIHRyaXN0YXRlICJBTUkgTWVnYVJBSUQgc3Vw
cG9ydCAobGVnYWN5KSIKKyAgICAgICAgZGVwZW5kcyBvbiBQQ0kgJiYgU0NTSQorCiBzb3VyY2Ug
ImRyaXZlcnMvc2NzaS9tZWdhcmFpZC9LY29uZmlnLm1lZ2FyYWlkIgogCiBjb25maWcgU0NTSV9T
QVRBCg==

--========GMXBoundary13991124977923--

