From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] libsas: set sas_address and device type of rphy
Date: Fri, 23 Sep 2011 18:54:27 -0700
Message-ID: <CAA9_cmdgV_2DWiLCAcEoda_wajcVXZ23gVPQYru=PagA=B-odw@mail.gmail.com>
References: <67EFB401F0334372A629F8C2A4AFADDD@usish.com.cn>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=20cf300fafffbec3f604ada63487
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:58101 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab1IXBy2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Sep 2011 21:54:28 -0400
Received: by qyk7 with SMTP id 7so4521113qyk.19
        for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2011 18:54:28 -0700 (PDT)
In-Reply-To: <67EFB401F0334372A629F8C2A4AFADDD@usish.com.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jack Wang <jack_wang@usish.com>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Xiangliang Yu <yuxiangl@marvell.com>, Mark Salyzyn <mark_salyzyn@us.xyratex.com>, Luben Tuikov <ltuikov@yahoo.com>, lindar_liu@usish.com, =?GB2312?B?09qwrruq?= <crystal_yu@usish.com>

--20cf300fafffbec3f604ada63487
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

2011/9/22 Jack Wang <jack_wang@usish.com>:
> Hi James,
>
> Libsas forget to set the sas_address and device type of rphy lead to file
> under /sys/class/sas_x show wrong value, fix that.
>
> From 976849ae6da4bc454a89d91b98824c915d3c99a2 Mon Sep 17 00:00:00 2001
> From: Jack Wang <jack_wang@usish.com>
> Date: Fri, 23 Sep 2011 14:19:24 +0800
> Subject: [PATCH] set rphy sas_address and device type correctly
>
> Signed-off-by: Jack Wang <jack_wang@usish.com>
> Tested-by: Crystal Yu <crystal_yu@usish.com>
> ---
> =A0sas_expander.c | =A0 =A02 ++
> =A01 files changed, 2 insertions(+), 0 deletions(-)

Hi Jack, quick note, this patch does not apply...

> diff --git a/sas_expander.c b/sas_expander.c
> index 874e29d..4ad0a40 100644
> --- a/sas_expander.c
> +++ b/sas_expander.c

...should be:
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c

I went ahead and fixed this up.

--
Dan

--20cf300fafffbec3f604ada63487
Content-Type: application/octet-stream;
	name="0001-set-rphy-sas_address-and-device-type-correctly.patch"
Content-Disposition: attachment;
	filename="0001-set-rphy-sas_address-and-device-type-correctly.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gsxy4m9t0

RnJvbSA5NzY4NDlhZTZkYTRiYzQ1NGE4OWQ5MWI5ODgyNGM5MTVkM2M5OWEyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKYWNrIFdhbmcgPGphY2tfd2FuZ0B1c2lzaC5jb20+CkRhdGU6
IEZyaSwgMjMgU2VwIDIwMTEgMTQ6MTk6MjQgKzA4MDAKU3ViamVjdDogW1BBVENIXSBzZXQgcnBo
eSBzYXNfYWRkcmVzcyBhbmQgZGV2aWNlIHR5cGUgY29ycmVjdGx5CgpTaWduZWQtb2ZmLWJ5OiBK
YWNrIFdhbmcgPGphY2tfd2FuZ0B1c2lzaC5jb20+ClRlc3RlZC1ieTogQ3J5c3RhbCBZdSA8Y3J5
c3RhbF95dUB1c2lzaC5jb20+Ci0tLQogc2FzX2V4cGFuZGVyLmMgfCAgICAyICsrCiAxIGZpbGVz
IGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9k
cml2ZXJzL3Njc2kvbGlic2FzL3Nhc19leHBhbmRlci5jIGIvZHJpdmVycy9zY3NpL2xpYnNhcy9z
YXNfZXhwYW5kZXIuYwppbmRleCA4NzRlMjlkLi40YWQwYTQwIDEwMDY0NAotLS0gYS9kcml2ZXJz
L3Njc2kvbGlic2FzL3Nhc19leHBhbmRlci5jCisrKyBiL2RyaXZlcnMvc2NzaS9saWJzYXMvc2Fz
X2V4cGFuZGVyLmMKQEAgLTE5OSw2ICsxOTksOCBAQCBzdGF0aWMgdm9pZCBzYXNfc2V0X2V4X3Bo
eShzdHJ1Y3QgZG9tYWluX2RldmljZSAqZGV2LCBpbnQgcGh5X2lkLAogCXBoeS0+dmlydHVhbCA9
IGRyLT52aXJ0dWFsOwogCXBoeS0+bGFzdF9kYV9pbmRleCA9IC0xOwogCisJcGh5LT5waHktPmlk
ZW50aWZ5LnNhc19hZGRyZXNzID0gU0FTX0FERFIocGh5LT5hdHRhY2hlZF9zYXNfYWRkcik7CisJ
cGh5LT5waHktPmlkZW50aWZ5LmRldmljZV90eXBlID0gcGh5LT5hdHRhY2hlZF9kZXZfdHlwZTsK
IAlwaHktPnBoeS0+aWRlbnRpZnkuaW5pdGlhdG9yX3BvcnRfcHJvdG9jb2xzID0gcGh5LT5hdHRh
Y2hlZF9pcHJvdG87CiAJcGh5LT5waHktPmlkZW50aWZ5LnRhcmdldF9wb3J0X3Byb3RvY29scyA9
IHBoeS0+YXR0YWNoZWRfdHByb3RvOwogCXBoeS0+cGh5LT5pZGVudGlmeS5waHlfaWRlbnRpZmll
ciA9IHBoeV9pZDsKLS0gCjEuNy40Lm1zeXNnaXQuMAoK
--20cf300fafffbec3f604ada63487--
