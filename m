From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 1/1] mpt3sas: Ignore unaligned completion length for
 ZBC_IN
Date: Tue, 14 Feb 2017 05:11:30 +0000
Message-ID: <1487049066.6475.3.camel@sandisk.com>
References: <20170213051152.27741-1-damien.lemoal@wdc.com>
         <1487012224.2719.3.camel@sandisk.com>
         <1f98b2ef-89d6-65e4-6424-c3b4b4cf1b82@wdc.com>
         <1487044768.6475.1.camel@sandisk.com>
         <bb2092fe-4368-2a7f-3e67-6e8369fb4d56@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:8086 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751936AbdBNFLs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Feb 2017 00:11:48 -0500
In-Reply-To: <bb2092fe-4368-2a7f-3e67-6e8369fb4d56@wdc.com>
Content-Language: en-US
Content-ID: <DC6A790B2023D34897D4B24E1123F09D@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>, "chaitra.basappa@broadcom.com" <chaitra.basappa@broadcom.com>, Damien Le Moal <Damien.LeMoal@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "suganath-prabu.subramani@broadcom.com" <suganath-prabu.subramani@broadcom.com>
Cc: "hch@lst.de" <hch@lst.de>, "hare@suse.de" <hare@suse.de>, "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>

T24gVHVlLCAyMDE3LTAyLTE0IGF0IDEzOjQyICswOTAwLCBEYW1pZW4gTGUgTW9hbCB3cm90ZToN
Cj4gSSB0aGluayBzby4gQnV0IG15IHVuZGVyc3RhbmRpbmcgb2YgUkVRX1RZUEVfQkxPQ0tfUEMg
aXMgdGhhdCBpdCBpcyB0aGUNCj4gdHlwZSBmb3IgcmVxdWVzdHMgaXNzdWVkIGludGVybmFsbHkg
KHNjc2lfZXhlY3V0ZSkgb2YgZnJvbSB0aGluZ3MgbGlrZQ0KPiB0aGUgU0cgZHJpdmVyLCBzbyBp
biBlc3NlbmNlLCBhbGwgcmVxdWVzdHMgbm90IGRlcml2ZWQgZnJvbSBhIEJJTy4uLiBJcw0KPiB0
aGlzIGNvcnJlY3QgPyBJZiB5ZXMsIHRoZW4gc2V0dGluZyB0aGUgQkxPQ0tfVFlQRV9QQyBmb3IN
Cj4gUkVRX09QX1pPTkVfUkVQT1JUIChhbmQgUkVRX09QX1pPTkVfUkVTRVQgd2hpbGUgYXQgaXQp
IHdvdWxkIGJyZWFrIHRoaXMNCj4gbW9kZWwsIHdvdWxkbid0IGl0ID8NCg0KSGVsbG8gRGFtaWVu
LA0KDQpJIHRoaW5rIHdlIHdhbnQgdG8ga2VlcCB0aGUga25vd2xlZGdlIG9mIHdoaWNoIHJlcXVl
c3RzIGhhdmUgYSByZXF1ZXN0IHNpemUNCnRoYXQgc2hvdWxkIGJlIGEgbXVsdGlwbGUgb2YgdGhl
IGxvZ2ljYWwgYmxvY2sgc2l6ZSBpbiB0aGUgYmxvY2sgbGF5ZXIgY29yZQ0Kb3IgaW4gdGhlIFND
U0kgY29yZSBidXQgbm90IGluIHRoZSBtcHQzc2FzIGRyaXZlci4gQnV0IEknbSBub3Qgc3VyZSB3
aGF0IHRoZQ0KYmVzdCBhcHByb2FjaCBpcyB0byBkbyB0aGF0LiBTaG91bGQgd2UgdXNlIHRoZSBy
ZXF1ZXN0IHR5cGUsIHNob3VsZCB3ZSBhZGQgYQ0KbmV3IHJlcXVlc3QgYXR0cmlidXRlIG9yIHNo
b3VsZCB3ZSBhZGQgYSBuZXcgZnVuY3Rpb24/DQoNCkJhcnQu
