From: "Stewart, Sean" <Sean.Stewart@netapp.com>
Subject: Re: [PATCH v2] scsi_devinfo: remove synchronous ALUA for NETAPP
 devices
Date: Wed, 7 Dec 2016 19:35:54 +0000
Message-ID: <2F2F999B-934D-4D63-A759-2FC777CF16B0@netapp.com>
References: <20161111164949.2322-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx142.netapp.com ([216.240.21.19]:54094 "EHLO mx142.netapp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753106AbcLGTf6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 7 Dec 2016 14:35:58 -0500
In-Reply-To: <20161111164949.2322-1-xose.vazquez@gmail.com>
Content-Language: en-US
Content-ID: <1DC22D3889FD034483681408C42645FD@namprd06.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: "George, Martin" <Martin.George@netapp.com>, "Stankey, Robert" <Robert.Stankey@netapp.com>, "Schremmer, Steven" <Steve.Schremmer@netapp.com>, Hannes Reinecke <hare@suse.de>, Christophe Varoqui <christophe.varoqui@opensvc.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, SCSI ML <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>

T24gMTEvMTEvMTYsIDEwOjQ5IEFNLCAiWG9zZSBWYXpxdWV6IFBlcmV6IiA8eG9zZS52YXpxdWV6
QGdtYWlsLmNvbT4gd3JvdGU6DQoNCiAgICBOZXRBcHAgZGlkIGNvbmZpcm0gdGhpcyBpcyBub3Qg
cmVxdWlyZWQuDQogICAgDQogICAgQ2M6IE1hcnRpbiBHZW9yZ2UgPE1hcnRpbi5HZW9yZ2VAbmV0
YXBwLmNvbT4NCiAgICBDYzogUm9iZXJ0IFN0YW5rZXkgPFJvYmVydC5TdGFua2V5QG5ldGFwcC5j
b20+DQogICAgQ2M6IFN0ZXZlbiBTY2hyZW1tZXIgPFN0ZXZlbi5TY2hyZW1tZXJAbmV0YXBwLmNv
bT4NCiAgICBDYzogU2VhbiBTdGV3YXJ0IDxTZWFuLlN0ZXdhcnRAbmV0YXBwLmNvbT4NCiAgICBD
YzogSGFubmVzIFJlaW5lY2tlIDxoYXJlQHN1c2UuZGU+DQogICAgQ2M6IENocmlzdG9waGUgVmFy
b3F1aSA8Y2hyaXN0b3BoZS52YXJvcXVpQG9wZW5zdmMuY29tPg0KICAgIENjOiBKYW1lcyBFLkou
IEJvdHRvbWxleSA8amVqYkBsaW51eC52bmV0LmlibS5jb20+DQogICAgQ2M6IE1hcnRpbiBLLiBQ
ZXRlcnNlbiA8bWFydGluLnBldGVyc2VuQG9yYWNsZS5jb20+DQogICAgQ2M6IFNDU0kgTUwgPGxp
bnV4LXNjc2lAdmdlci5rZXJuZWwub3JnPg0KICAgIENjOiBkZXZpY2UtbWFwcGVyIGRldmVsb3Bt
ZW50IDxkbS1kZXZlbEByZWRoYXQuY29tPg0KICAgIFNpZ25lZC1vZmYtYnk6IFhvc2UgVmF6cXVl
eiBQZXJleiA8eG9zZS52YXpxdWV6QGdtYWlsLmNvbT4NCiAgICAtLS0NCiAgICAgZHJpdmVycy9z
Y3NpL3Njc2lfZGV2aW5mby5jIHwgMiAtLQ0KICAgICAxIGZpbGUgY2hhbmdlZCwgMiBkZWxldGlv
bnMoLSkNCiAgICANCiAgICBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Njc2lfZGV2aW5mby5j
IGIvZHJpdmVycy9zY3NpL3Njc2lfZGV2aW5mby5jDQogICAgaW5kZXggMjQ2NDU2OS4uMjhmZWE4
MyAxMDA2NDQNCiAgICAtLS0gYS9kcml2ZXJzL3Njc2kvc2NzaV9kZXZpbmZvLmMNCiAgICArKysg
Yi9kcml2ZXJzL3Njc2kvc2NzaV9kZXZpbmZvLmMNCiAgICBAQCAtMjIwLDggKzIyMCw2IEBAIHN0
YXRpYyBzdHJ1Y3Qgew0KICAgICAJeyJOQUtBTUlDSCIsICJNSi01LjE2UyIsIE5VTEwsIEJMSVNU
X0ZPUkNFTFVOIHwgQkxJU1RfU0lOR0xFTFVOfSwNCiAgICAgCXsiTkVDIiwgIlBELTEgT0RYNjU0
UCIsIE5VTEwsIEJMSVNUX0ZPUkNFTFVOIHwgQkxJU1RfU0lOR0xFTFVOfSwNCiAgICAgCXsiTkVD
IiwgImlTdG9yYWdlIiwgTlVMTCwgQkxJU1RfUkVQT1JUTFVOMn0sDQogICAgLQl7Ik5FVEFQUCIs
ICJMVU4gQy1Nb2RlIiwgTlVMTCwgQkxJU1RfU1lOQ19BTFVBfSwNCiAgICAtCXsiTkVUQVBQIiwg
IklORi0wMS0wMCIsIE5VTEwsIEJMSVNUX1NZTkNfQUxVQX0sDQogICAgIAl7Ik5SQyIsICJNQlIt
NyIsIE5VTEwsIEJMSVNUX0ZPUkNFTFVOIHwgQkxJU1RfU0lOR0xFTFVOfSwNCiAgICAgCXsiTlJD
IiwgIk1CUi03LjQiLCBOVUxMLCBCTElTVF9GT1JDRUxVTiB8IEJMSVNUX1NJTkdMRUxVTn0sDQog
ICAgIAl7IlBJT05FRVIiLCAiQ0QtUk9NIERSTS02MDAiLCBOVUxMLCBCTElTVF9GT1JDRUxVTiB8
IEJMSVNUX1NJTkdMRUxVTn0sDQogICAgLS0gDQogICAgMi4xMC4yDQogICAgDQpSZXZpZXdlZC1i
eTogU2VhbiBTdGV3YXJ0IDxzZWFuLnN0ZXdhcnRAbmV0YXBwLmNvbT4NCg0KVGhhbmtzLA0KU2Vh
bg0KDQo=
