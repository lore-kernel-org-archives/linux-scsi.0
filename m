From: majianpeng <majianpeng@gmail.com>
Subject: [PATCH 5/6] scsi-mq: fix 'BUG_ON(count > sdb->table.nents)' in scsi_init_sgtable().
Date: Fri, 29 Nov 2013 16:42:39 +0800
Message-ID: <2013112916422942442410@gmail.com>
Reply-To: majianpeng <majianpeng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:62208 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab3K2Imt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Nov 2013 03:42:49 -0500
Received: by mail-pd0-f169.google.com with SMTP id v10so13467934pde.14
        for <linux-scsi@vger.kernel.org>; Fri, 29 Nov 2013 00:42:49 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

VGVzdCBjZHJvbSBvbiBpbnRlbCBhaGNpLCBpdCB3aWxsIHRyaWdnZXIgdGhpcyBjb25kaXRpb24u
DQpUaGlzIGlzIGJlY2F1c2Ugc2NzaS1tcSBkb24nIHRlc3QgJ3EtPmRtYV9kcmFpbl9zaXplICYm
DQpibGtfcnFfYnl0ZXMocnEpJyBsaWtlIGluIGJsa19wZWVrX3JlcXVlc3QoKS4NCg0KU2lnbmVk
LW9mZi1ieTogSmlhbnBlbmcgTWEgPG1hamlhbnBlbmdAZ21haWwuY29tPg0KLS0tDQogZHJpdmVy
cy9zY3NpL3Njc2ktbXEuYyB8ICAgMTAgKysrKysrKysrKw0KIDEgZmlsZSBjaGFuZ2VkLCAxMCBp
bnNlcnRpb25zKCspDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvc2NzaS1tcS5jIGIvZHJp
dmVycy9zY3NpL3Njc2ktbXEuYw0KaW5kZXggOTMzYmEwZi4uNzhiMDVjMSAxMDA2NDQNCi0tLSBh
L2RyaXZlcnMvc2NzaS9zY3NpLW1xLmMNCisrKyBiL2RyaXZlcnMvc2NzaS9zY3NpLW1xLmMNCkBA
IC0zNSw2ICszNSwxNiBAQCBzdGF0aWMgaW50IHNjc2lfbXFfcXVldWVfcnEoc3RydWN0IGJsa19t
cV9od19jdHggKmhjdHgsIHN0cnVjdCByZXF1ZXN0ICpycSkNCiAJc2MtPmRldmljZSA9IHNkZXY7
DQogCXNjLT5zZW5zZV9idWZmZXIgPSBzZW5zZV9idWY7DQogCXNjLT5tcV9zZ2wgPSBzZzsNCisN
CisJaWYgKHEtPmRtYV9kcmFpbl9zaXplICYmIGJsa19ycV9ieXRlcyhycSkpIHsNCisJCS8qDQor
CQkgKiBtYWtlIHN1cmUgc3BhY2UgZm9yIHRoZSBkcmFpbiBhcHBlYXJzIHdlDQorCQkgKiBrbm93
IHdlIGNhbiBkbyB0aGlzIGJlY2F1c2UgbWF4X2h3X3NlZ21lbnRzDQorCQkgKiBoYXMgYmVlbiBh
ZGp1c3RlZCB0byBiZSBvbmUgZmV3ZXIgdGhhbiB0aGUNCisJCSAqIGRldmljZSBjYW4gaGFuZGxl
DQorCQkgKi8NCisJCXJxLT5ucl9waHlzX3NlZ21lbnRzKys7DQorCX0NCiAJLyoNCiAJICogTWFy
ayB0aGUgZW5kIG9mIHRoZSBwcmUtYWxsb2NhdGVkIFNHTCBiYXNlZCB1cG9uIHRoZQ0KIAkgKiBp
bmNvbWluZyBudW1iZXIgb2YgcGh5c2ljYWwgc2VnbWVudHMgZnJvbSBibGstbXENCi0tIA0KMS43
LjEwLjQNCg==

