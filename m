From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 8/8] scsi: Introduce ZBC disk I/O scheduler
Date: Fri, 1 Sep 2017 17:19:33 +0000
Message-ID: <1504286372.14386.50.camel@wdc.com>
References: <20170901113631.12323-1-damien.lemoal@wdc.com>
         <20170901113631.12323-9-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:42218 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752180AbdIARUU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Sep 2017 13:20:20 -0400
In-Reply-To: <20170901113631.12323-9-damien.lemoal@wdc.com>
Content-Language: en-US
Content-ID: <D916D4F28ED5ED4DA84BEF957EA59915@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "hch@lst.de" <hch@lst.de>

T24gRnJpLCAyMDE3LTA5LTAxIGF0IDIwOjM2ICswOTAwLCBEYW1pZW4gTGUgTW9hbCB3cm90ZToN
Cj4gK3N0YXRpYyBzdHJ1Y3Qgc2NzaV9kaXNrICpfX3pvbmVkX3Njc2lfZGlzayhzdHJ1Y3QgcmVx
dWVzdF9xdWV1ZSAqcSkNCj4gK3sNCj4gKyAgICAgICBzdHJ1Y3Qgc2NzaV9kZXZpY2UgKnNkcDsN
Cj4gKyAgICAgICBzdHJ1Y3Qgc2NzaV9kaXNrICpzZGtwOw0KPiArDQo+ICsgICAgICAgaWYgKCFi
bGtfcXVldWVfaXNfem9uZWQocSkpIHsNCj4gKyAgICAgICAgICAgICAgIHByX2Vycigiem9uZWQ6
IE5vdCBhIHpvbmVkIGJsb2NrIGRldmljZVxuIik7DQo+ICsgICAgICAgICAgICAgICByZXR1cm4g
TlVMTDsNCj4gKyAgICAgICB9DQo+ICsNCj4gKyAgICAgICBzZHAgPSBzY3NpX2RldmljZV9mcm9t
X3F1ZXVlKHEpOw0KPiArICAgICAgIGlmICghc2RwKSB7DQo+ICsgICAgICAgICAgICAgICBwcl9l
cnIoInpvbmVkOiBOb3QgYSBTQ1NJIGRldmljZVxuIik7DQo+ICsgICAgICAgICAgICAgICByZXR1
cm4gTlVMTDsNCj4gKyAgICAgICB9DQo+ICsNCj4gKyAgICAgICBzZGtwID0gZGV2X2dldF9kcnZk
YXRhKCZzZHAtPnNkZXZfZ2VuZGV2KTsNCj4gKyAgICAgICBpZiAoV0FSTl9PTihzZGtwLT5kaXNr
LT5xdWV1ZSAhPSBxKSkNCj4gKyAgICAgICAgICAgICAgIHJldHVybiBOVUxMOw0KPiArDQo+ICsg
ICAgICAgcmV0dXJuIHNka3A7DQo+ICt9DQoNCkhlbGxvIERhbWllbiwNCg0KQ2FuIHJlYWRpbmcg
c2RrcC0+ZGlzay0+cXVldWUgY2F1c2UgYSBrZXJuZWwgY3Jhc2ggaWYgc2RwIGRvZXMgbm90IHBv
aW50IGF0DQphIFNDU0kgZGV2aWNlIHRoYXQgaXMgYXNzb2NpYXRlZCB3aXRoIGEgU0NTSSBkaXNr
PyBIb3cgYWJvdXQgdXNpbmcgc29tZXRoaW5nDQpsaWtlIHRoZSBjb2RlIGJlbG93IHRvIGNvbnZl
cnQgYSByZXF1ZXN0IHF1ZXVlIHBvaW50ZXIgaW50byBhIFNDU0kgZGlzaw0KcG9pbnRlcj8NCg0K
c3RhdGljIGludCBsb29rdXBfZGlzayhzdHJ1Y3QgZGV2aWNlICpkZXYsIHZvaWQgKmRhdGEpDQp7
DQoJc3RydWN0IHNjc2lfZGlzayAqKnNka3AgPSBkYXRhOw0KDQoJaWYgKCEqc2RrcCAmJiBkZXYt
PmNsYXNzID09ICZzZF9kaXNrX2NsYXNzKQ0KCQkqc2RrcCA9IHRvX3Njc2lfZGlzayhkZXYpOw0K
DQoJcmV0dXJuIDA7DQp9DQoNCnN0YXRpYyBzdHJ1Y3Qgc2NzaV9kaXNrICpxX3RvX3Nka3Aoc3Ry
dWN0IHJlcXVlc3RfcXVldWUgKnEpDQp7DQoJc3RydWN0IHNjc2lfZGV2aWNlICpzZHAgPSBzY3Np
X2RldmljZV9mcm9tX3F1ZXVlKHEpOw0KCXN0cnVjdCBzY3NpX2Rpc2sgKnNka3AgPSBOVUxMOw0K
DQoJaWYgKHNkcCkNCgkJZGV2aWNlX2Zvcl9lYWNoX2NoaWxkKCZzZHAtPnNkZXZfZ2VuZGV2LCAm
c2RrcCwgbG9va3VwX2Rpc2spOw0KCXJldHVybiBzZGtwOw0KfQ0KDQpUaGFua3MsDQoNCkJhcnQu
