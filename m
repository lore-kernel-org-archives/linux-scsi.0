From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: [LSF/MM TOPIC] irq affinity handling for high CPU count machines
Date: Mon, 29 Jan 2018 15:41:02 +0000
Message-ID: <AT5PR8401MB0387022075AF24A278FA522EABE50@AT5PR8401MB0387.NAMPRD84.PROD.OUTLOOK.COM>
References: <45dc032d-a0ce-816c-d2c5-74c69433bd29@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hpe.com ([15.241.32.99]:6074 "EHLO
        g9t1613g.houston.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751256AbeA2Pl1 (ORCPT
        <rfc822;Linux-scsi@vger.kernel.org>); Mon, 29 Jan 2018 10:41:27 -0500
Received: from g2t2354.austin.hpe.com (g2t2354.austin.hpe.com [15.233.44.27])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by g9t1613g.houston.hpe.com (Postfix) with ESMTPS id 7EA6261AA2
        for <Linux-scsi@vger.kernel.org>; Mon, 29 Jan 2018 15:41:26 +0000 (UTC)
In-Reply-To: <45dc032d-a0ce-816c-d2c5-74c69433bd29@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Cc: "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>, Kashyap Desai <kashyap.desai@broadcom.com>

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTGludXgtbnZtZSBbbWFp
bHRvOmxpbnV4LW52bWUtYm91bmNlc0BsaXN0cy5pbmZyYWRlYWQub3JnXSBPbiBCZWhhbGYNCj4g
T2YgSGFubmVzIFJlaW5lY2tlDQo+IFNlbnQ6IE1vbmRheSwgSmFudWFyeSAyOSwgMjAxOCAzOjA5
IEFNDQo+IFRvOiBsc2YtcGNAbGlzdHMubGludXgtZm91bmRhdGlvbi5vcmcNCj4gQ2M6IGxpbnV4
LW52bWVAbGlzdHMuaW5mcmFkZWFkLm9yZzsgbGludXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmc7IEth
c2h5YXANCj4gRGVzYWkgPGthc2h5YXAuZGVzYWlAYnJvYWRjb20uY29tPg0KPiBTdWJqZWN0OiBb
TFNGL01NIFRPUElDXSBpcnEgYWZmaW5pdHkgaGFuZGxpbmcgZm9yIGhpZ2ggQ1BVIGNvdW50IG1h
Y2hpbmVzDQo+IA0KPiBIaSBhbGwsDQo+IA0KPiBoZXJlJ3MgYSB0b3BpYyB3aGljaCBjYW1lIHVw
IG9uIHRoZSBTQ1NJIE1MIChjZiB0aHJlYWQgJ1tSRkMgMC8yXQ0KPiBtcHQzc2FzL21lZ2FyYWlk
X3NhczogaXJxIHBvbGwgYW5kIGxvYWQgYmFsYW5jaW5nIG9mIHJlcGx5IHF1ZXVlJykuDQo+IA0K
PiBXaGVuIGRvaW5nIEkvTyB0ZXN0cyBvbiBhIG1hY2hpbmUgd2l0aCBtb3JlIENQVXMgdGhhbiBN
U0l4IHZlY3RvcnMNCj4gcHJvdmlkZWQgYnkgdGhlIEhCQSB3ZSBjYW4gZWFzaWx5IHNldHVwIGEg
c2NlbmFyaW8gd2hlcmUgb25lIENQVSBpcw0KPiBzdWJtaXR0aW5nIEkvTyBhbmQgdGhlIG90aGVy
IG9uZSBpcyBjb21wbGV0aW5nIEkvTy4gV2hpY2ggd2lsbCByZXN1bHQgaW4NCj4gdGhlIGxhdHRl
ciBDUFUgYmVpbmcgc3R1Y2sgaW4gdGhlIGludGVycnVwdCBjb21wbGV0aW9uIHJvdXRpbmUgZm9y
DQo+IGJhc2ljYWxseSBldmVyLCByZXN1bHRpbmcgaW4gdGhlIGxvY2t1cCBkZXRlY3RvciBraWNr
aW5nIGluLg0KPiANCj4gSG93IHNob3VsZCB0aGVzZSBzaXR1YXRpb25zIGJlIGhhbmRsZWQ/DQo+
IFNob3VsZCBpdCBiZSBtYWRlIHRoZSByZXNwb25zaWJpbGl0eSBvZiB0aGUgZHJpdmVycywgZW5z
dXJpbmcgdGhhdCB0aGUNCj4gaW50ZXJydXB0IGNvbXBsZXRpb24gcm91dGluZSBpcyB0ZXJtaW5h
dGVkIGFmdGVyIGEgY2VydGFpbiB0aW1lPw0KPiBTaG91bGQgaXQgYmUgbWFkZSB0aGUgcmVzcG9z
aWJpbGl0eSBvZiB0aGUgdXBwZXIgbGF5ZXJzPw0KPiBTaG91bGQgaXQgYmUgdGhlIHJlc3BvbnNp
YmlsaXR5IG9mIHRoZSBpbnRlcnJ1cHQgbWFwcGluZyBjb2RlPw0KPiBDYW4vc2hvdWxkIGludGVy
cnVwdCBwb2xsaW5nIGJlIHVzZWQgaW4gdGhlc2Ugc2l0dWF0aW9ucz8NCg0KQmFjayB3aGVuIHdl
IGludHJvZHVjZWQgc2NzaS1tcSB3aXRoIGhwc2EsIHRoZSBiZXN0IGFwcHJvYWNoIHdhcyB0bw0K
cm91dGUgaW50ZXJydXB0cyBhbmQgY29tcGxldGlvbiBoYW5kbGluZyBzbyBlYWNoIENQVSBjb3Jl
IGhhbmRsZXMgaXRzDQpvd24gc3VibWlzc2lvbnM7IHRoaXMgd2F5LCB0aGV5IGFyZSBzZWxmLXRo
cm90dGxpbmcuDQoNCkV2ZXJ5IG90aGVyIGFycmFuZ2VtZW50IHdhcyBzdWJqZWN0IHRvIHNvZnQg
bG9ja3VwcyBhbmQgb3RoZXIgcHJvYmxlbXMNCndoZW4gdGhlIGNvbXBsZXRpb24gQ1BVcyBiZWNv
bWUgb3ZlcndoZWxtZWQgd2l0aCB3b3JrLg0KDQpTZWUgaHR0cHM6Ly9sa21sLm9yZy9sa21sLzIw
MTQvOS85LzkzMS4NCg0KLS0tDQpSb2JlcnQgRWxsaW90dCwgSFBFIFBlcnNpc3RlbnQgTWVtb3J5
DQoNCg0K
