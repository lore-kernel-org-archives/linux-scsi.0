From: majianpeng <majianpeng@gmail.com>
Subject: [PATCH 3/6] scsi-mq: Don't set QUEUE_FLAG_NONROT in scsi_mq_alloc_queue().
Date: Fri, 29 Nov 2013 16:42:00 +0800
Message-ID: <201311291641544409087@gmail.com>
Reply-To: majianpeng <majianpeng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:46767 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab3K2ImG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Nov 2013 03:42:06 -0500
Received: by mail-pd0-f181.google.com with SMTP id p10so13324403pdj.40
        for <linux-scsi@vger.kernel.org>; Fri, 29 Nov 2013 00:42:05 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

VGhpcyBmbGFnIHdpbGwgYmUgc2V0IGluIHNkX3JldmFsaWRhdGVfZGlzaygpLlNvIHJlbW92ZSB0
aGlzIG9wZXJhdGlvbi4NCg0KU2lnbmVkLW9mZi1ieTogSmlhbnBlbmcgTWEgPG1hamlhbnBlbmdA
Z21haWwuY29tPg0KLS0tDQogZHJpdmVycy9zY3NpL3Njc2ktbXEuYyB8ICAgIDIgLS0NCiAxIGZp
bGUgY2hhbmdlZCwgMiBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9z
Y3NpLW1xLmMgYi9kcml2ZXJzL3Njc2kvc2NzaS1tcS5jDQppbmRleCBlY2NkYmQ1Li45MzNiYTBm
IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL3Njc2ktbXEuYw0KKysrIGIvZHJpdmVycy9zY3Np
L3Njc2ktbXEuYw0KQEAgLTIwNiw4ICsyMDYsNiBAQCBpbnQgc2NzaV9tcV9hbGxvY19xdWV1ZShz
dHJ1Y3QgU2NzaV9Ib3N0ICpzaCwgc3RydWN0IHNjc2lfZGV2aWNlICpzZGV2KQ0KIAkJCX0NCiAJ
CX0NCiAJfQ0KLS8vRklYTUU6IENoZWNrIGZvciAhTk9OUk9UIHVzYWdlDQotCXF1ZXVlX2ZsYWdf
c2V0X3VubG9ja2VkKFFVRVVFX0ZMQUdfTk9OUk9ULCBxKTsNCiANCiAJcHJpbnRrKCJzY3NpX21x
X2FsbG9jX3F1ZXVlKCkgY29tcGxldGUgISEgPj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+Pj4+XG4i
KTsNCiAJcmV0dXJuIDA7DQotLSANCjEuNy4xMC40DQo=

