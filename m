From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH v4 3/6] qla2xxx: Utilize
 pci_alloc_irq_vectors/pci_free_irq_vectors calls.
Date: Thu, 8 Dec 2016 19:02:13 +0000
Message-ID: <13FC12B8-A8EF-41A9-8CE4-923146B7619B@cavium.com>
References: <1481051266-32362-1-git-send-email-himanshu.madhani@cavium.com>
 <1481051266-32362-4-git-send-email-himanshu.madhani@cavium.com>
 <20161207190342.GA29031@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0084.outbound.protection.outlook.com ([104.47.34.84]:52717
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932409AbcLHTCV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 8 Dec 2016 14:02:21 -0500
In-Reply-To: <20161207190342.GA29031@infradead.org>
Content-Language: en-US
Content-ID: <2E8F95027DB18446B82591FEB3B964CE@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

SGkgQ2hyaXN0b3BoLCANCg0KDQoNCk9uIDEyLzcvMTYsIDExOjAzIEFNLCAiQ2hyaXN0b3BoIEhl
bGx3aWciIDxoY2hAaW5mcmFkZWFkLm9yZz4gd3JvdGU6DQoNCj4+ICBzdGF0aWMgaW50DQo+PiAg
cWxhMjR4eF9lbmFibGVfbXNpeChzdHJ1Y3QgcWxhX2h3X2RhdGEgKmhhLCBzdHJ1Y3QgcnNwX3F1
ZSAqcnNwKQ0KPj4gIHsNCj4+ICAjZGVmaW5lIE1JTl9NU0lYX0NPVU5UCTINCj4+ICAjZGVmaW5l
IEFUSU9fVkVDVE9SCTINCj4+ICAJaW50IGksIHJldDsNCj4+ICAJc3RydWN0IHFsYV9tc2l4X2Vu
dHJ5ICpxZW50cnk7DQo+PiAgCXNjc2lfcWxhX2hvc3RfdCAqdmhhID0gcGNpX2dldF9kcnZkYXRh
KGhhLT5wZGV2KTsNCj4+ICANCj4+ICsJcmV0ID0gcGNpX2FsbG9jX2lycV92ZWN0b3JzKGhhLT5w
ZGV2LA0KPj4gKwkgICAgTUlOX01TSVhfQ09VTlQsIGhhLT5tc2l4X2NvdW50LCBQQ0lfSVJRX01T
SVh8UENJX0lSUV9BRkZJTklUWSk7DQo+DQo+R2l2ZW4gdGhhdCBhcy1pcyB0aGUgY29kZSBvbmx5
IHVzZXMgdHdvIHZlY3RvcnMsIGFuZCB0aGV5IGFyZSBub3QNCj5mb3IgcGVyLWNwdSBxdWV1ZXMg
dXNpbmcgUENJX0lSUV9BRkZJTklUWSBpcyBhY3R1YWxseSB3cm9uZywgYW5kDQo+eW91J3JlIGJl
dHRlciBvZmYgd2l0aG91dCBpdC4gIEFsc28gcGxlYXNlIGZpeCB0aGUgc3BhY2luZzoNCj50YWJz
IGZvciBhbGlnbmluZyBjb250aW51ZWQgYXJndW1lbnRzLCBhbmQgc3BhY2VzIGFyb3VuZCBvcGVy
YXRvcnMNCj4oYWx0aG91Z2ggdGhlIHJldmlzZWQgdmVyc2lvbiB3b24ndCBoYXZlIGFuIG9wZXJh
dG9yIC0gc28gdGhpcyBpcw0KPmp1c3QgZm9yIGZ1dHVyZSByZWZlcmVuY2U6DQo+DQoNCkFjay4g
QWdyZWUgaGVyZSB0aGlzIGNoYW5nZSBzaG91bGQgbm90IGJlIHBhcnQgb2YgdGhpcyBwYXRjaC4N
Cg0KPglyZXQgPSBwY2lfYWxsb2NfaXJxX3ZlY3RvcnMoaGEtPnBkZXYsIE1JTl9NU0lYX0NPVU5U
LA0KPgkJCWhhLT5tc2l4X2NvdW50LCBQQ0lfSVJRX01TSVgpOw0KPg0KPj4gKwlzdHJ1Y3QgcnNw
X3F1ZSAqcnNwID0gKHN0cnVjdCByc3BfcXVlICopZS0+aGFuZGxlOw0KPg0KPk5vIG5lZWQgZm9y
IHRoZSBjYXN0IGhlcmUuDQoNCkFjay4gV2lsbCBwb3N0IHVwZGF0ZSBpbiBuZXcgc2VyaWVzLiAN
Cg0KPg0KPj4gKwlzdHJ1Y3QgcnNwX3F1ZSAqcnNwID0gKHN0cnVjdCByc3BfcXVlICopZS0+aGFu
ZGxlOw0KPg0KPlNhbWUgaGVyZS4NCg0KV2lsbCBzZW5kIG5ldyBzZXJpZXMgc29vbi4NCg0KPg0K
