From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] scsi: mpt3sas: fix oops in error handlers after
 shutdown/unload
Date: Wed, 31 Jan 2018 19:06:01 +0000
Message-ID: <1517425560.7325.2.camel@wdc.com>
References: <1517425200-19126-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:22495 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751163AbeAaTGF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Jan 2018 14:06:05 -0500
In-Reply-To: <1517425200-19126-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Content-Language: en-US
Content-ID: <358AF9C889076642BCD45ED1C1909CF3@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "mauricfo@linux.vnet.ibm.com" <mauricfo@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "chaitra.basappa@broadcom.com" <chaitra.basappa@broadcom.com>, "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>, "suganath-prabu.subramani@broadcom.com" <suganath-prabu.subramani@broadcom.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

T24gV2VkLCAyMDE4LTAxLTMxIGF0IDE3OjAwIC0wMjAwLCBNYXVyaWNpbyBGYXJpYSBkZSBPbGl2
ZWlyYSB3cm90ZToNCj4gVGhpcyBwcm9ibGVtIHdhcyBvYnNlcnZlZCB3aXRoIGtleGVjIG9uIGEg
c3lzdGVtIHdpdGggYSBtcHQzc2FzDQo+IGJhc2VkIGFkYXB0ZXIgYW5kIGFuIGluZmluaWJhbmQg
YWRhcHRlciB3aGljaCB0YWtlcyBsb25nIGVub3VnaA0KPiB0byBzaHV0ZG93bi4gIFRoZSBtcHQz
c2FzIGRyaXZlciBmaW5pc2hlZCBzaHV0dHRpbmcgZG93biwgd2hpY2gNCj4gZGlzYWJsZWQgaW50
ZXJydXB0aW9uIGhhbmRsaW5nLCB0aHVzIHNvbWUgcnVubmluZyBjb21tYW5kcyBoYXZlDQo+IG5v
dCBmaW5pc2hlZCBhbmQgdGltZWQgb3V0LiAgU2luY2UgdGhlIHN5c3RlbSB3YXMgc3RpbGwgcnVu
bmluZywNCj4gd2FpdGluZyBmb3IgdGhlIGluZmluaWJhbmQgYWRhcHRlciB0byBzaHV0IGRvd24s
IHRoZSBzY3NpIGVycm9yDQo+IGhhbmRsZXIgZm9yIHRhc2sgYWJvcnQgb2YgbXB0M3NhcyB3YXMg
aW52b2tlZCwgYW5kIGhpdCB0aGUgb29wcw0KPiBiZWNhdXNlICdpb2MtPnNjc2lfbG9va3VwJyB3
YXMgTlVMTC4NCg0KU29ycnkgYnV0IEkgdGhpbmsgdGhpcyBwYXRjaCBpbnRyb2R1Y2VzIG5ldyBy
YWNlIGNvbmRpdGlvbnMuIEhhdmUgeW91DQpjb25zaWRlcmVkIHRvIG1vZGlmeSB0aGUgbXB0M3Nh
cyBkcml2ZXIgc3VjaCB0aGF0IGludGVycnVwdHMgYXJlIG9ubHkNCmRpc2FibGVkIGFmdGVyIGFs
bCBjb21tYW5kcyBoYXZlIGZpbmlzaGVkPw0KDQpUaGFua3MsDQoNCkJhcnQu
