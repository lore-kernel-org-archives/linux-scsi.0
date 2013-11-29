From: majianpeng <majianpeng@gmail.com>
Subject: [RFC PATCH 0/6] scsi-mq: make the scsi-mq work.
Date: Fri, 29 Nov 2013 16:41:20 +0800
Message-ID: <201311291641178322454@gmail.com>
Reply-To: majianpeng <majianpeng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:36559 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab3K2Il2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Nov 2013 03:41:28 -0500
Received: by mail-pd0-f174.google.com with SMTP id y13so13319427pdi.5
        for <linux-scsi@vger.kernel.org>; Fri, 29 Nov 2013 00:41:27 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

SGkgbmFiOg0KCVRlc3QgaHR0cDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVs
L2dpdC9uYWIvdGFyZ2V0LXBlbmRpbmcuZ2l0L3Njc2ktbXEsIGl0IGNhbid0IHdvcmsgZm9yIG15
IG1hY2hpbmUodXNpbmcgYWhjaSBkcml2ZXIpLg0KRnJvbSB0aGlzIGJyYW5jaCwgaSBrbm93IGl0
IHN1cHBvcnQgYWhjaSB3aXRoIHNjc2ktbXEvYmxvY2stbXEuU28gaSBtb2RpZnkgc29tZSBwbGFj
ZSB0byBtYWtlIGl0IGNhbiB3b3JrLg0KRm9yIHRoaXMgcGF0Y2hzZXQsIGkgb25seSB0ZXN0IHJl
YWQvd3JpdGUgYW5kIG9uIG9vcHMvaHVuZ190YXNrIG9jY3VyLg0KDQpKaWFucGVuZyBNYSAoNik6
DQogIGJsb2NrOiBzdXBwb3J0IGJsay1tcSBvbiBibGtfcnVuX3F1ZXVlL2Jsa19ydW5fcXVldWVf
YXN5bmMuDQogIHNjc2ktbXE6IGFkZCBvcGVyYXRpb25zIGFib3V0IGRldmljZV9idXN5L3Rhcmdl
dF9idXN5L2hvc3RfYnVzeSBpbiAgIA0KICAgICBzY3NpX21xX3F1ZXVlX3JxKCkuDQogIHNjc2kt
bXE6IERvbid0IHNldCBRVUVVRV9GTEFHX05PTlJPVCBpbiBzY3NpX21xX2FsbG9jX3F1ZXVlKCku
DQogIHNjc2ktbXE6IGluaXQgc2cgaW4gc2NzaV9pbml0X2lvLg0KICBzY3NpLW1xOiBmaXggJ0JV
R19PTihjb3VudCA+IHNkYi0+dGFibGUubmVudHMpJyBpbg0KICAgIHNjc2lfaW5pdF9zZ3RhYmxl
KCkuDQogIHNjc2ktbXE6IFByZS1hbGxvY2F0aW9uIG9mIHNnIHRhYmxlcyBiYXNlIG9uDQogICAg
bWluKGhvc3QtPmhvc3R0LT5zZ190YWJsZXNpemUsIFNDU0lfTVFfTUFYX1NHX1NFR01FTlRTKS4N
Cg0KIGJsb2NrL2Jsay1jb3JlLmMgICAgICAgIHwgICAyMSArKysrKysrKysrKysrKy0tLS0tLS0N
CiBkcml2ZXJzL3Njc2kvc2NzaS1tcS5jICB8ICAgMzMgKysrKysrKysrKysrKysrKysrKysrKysr
KysrKy0tLS0tDQogZHJpdmVycy9zY3NpL3Njc2lfbGliLmMgfCAgICA0ICsrKy0NCiAzIGZpbGVz
IGNoYW5nZWQsIDQ1IGluc2VydGlvbnMoKyksIDEzIGRlbGV0aW9ucygtKQ0KDQotLSANCjEuNy4x
MC40DQo=

