From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [dm-devel] [PATCH V4] blk-mq: introduce BLK_STS_DEV_RESOURCE
Date: Fri, 2 Feb 2018 00:53:51 +0000
Message-ID: <1517532830.2746.43.camel@wdc.com>
References: <20180129203300.50595-1-snitzer@redhat.com>
         <1517260932.2687.42.camel@wdc.com> <20180129214446.GD5744@redhat.com>
         <1517262713.2687.56.camel@wdc.com>
         <23155.45114.317289.396546@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:27084 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751669AbeBBAxz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Feb 2018 19:53:55 -0500
In-Reply-To: <23155.45114.317289.396546@quad.stoffel.home>
Content-Language: en-US
Content-ID: <8C660C0FD4E81840BCBE4EC4CDE7EF08@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "john@stoffel.org" <john@stoffel.org>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>

T24gVGh1LCAyMDE4LTAyLTAxIGF0IDE5OjI2IC0wNTAwLCBKb2huIFN0b2ZmZWwgd3JvdGU6DQo+
IERvZXNuJ3QgdGhpcyBhcmd1ZSB0aGF0IHlvdSByZWFsbHkgd2FudCBzb21lIHNvcnQgb2YgY29t
cGxldGlvbnMgdG8gYmUNCj4gcnVuIGluIHRoaXMgY2FzZSBpbnN0ZWFkPyAgSW5zdGVhZCBvZiBi
dXN5IGxvb3Bpbmcgb3Igd2FpdGluZyBmb3IgYQ0KPiBzZXQgYW1vdW50IG9mIHRpbWUsIGp1c3Qg
ZmlyZSBvZmYgYSBjYWxsYmFjayB0byBydW4gb25jZSB5b3UgaGF2ZSB0aGUNCj4gcmVzb3VyY2Vz
IGF2YWlsYWJsZSwgbm8/DQoNCkhlbGxvIEpvaG4sDQoNClJlcnVubmluZyB0aGUgcXVldWUgd2hl
biB0aGUgcmVzb3VyY2Ugd2UgcmFuIG91dCBvZiBpcyBhdmFpbGFibGUgYWdhaW4gd291bGQNCmJl
IGlkZWFsLiBIb3dldmVyLCBJJ20gbm90IHN1cmUgaXQgaXMgcG9zc2libGUgdG8gaW1wbGVtZW50
IHRoaXMuIElmIGEgZHJpdmVyDQpwZXJmb3JtcyBtZW1vcnkgYWxsb2NhdGlvbiB3aGlsZSBleGVj
dXRpbmcgYSByZXF1ZXN0IGFuZCBrbWFsbG9jKCkgcmV0dXJucw0KLUVOT01FTSB0aGVuIEkgZG9u
J3Qga25vdyB3aGljaCBtZWNoYW5pc20gc2hvdWxkIGJlIHVzZWQgdG8gdHJpZ2dlciBhIHF1ZXVl
DQpyZXJ1biB3aGVuIHN1ZmZpY2llbnQgbWVtb3J5IGlzIGF2YWlsYWJsZSBhZ2Fpbi4NCg0KQW5v
dGhlciBleGFtcGxlIGlzIHRoZSBTQ1NJIHN1YnN5c3RlbS4gSWYgYSB0aGUgLnF1ZXVlY29tbWFu
ZCgpIGltcGxlbWVudGF0aW9uDQpvZiBhIFNDU0kgTExEIHJldHVybnMgU0NTSV9NTFFVRVVFXypf
QlVTWSBiZWNhdXNlIGEgY2VydGFpbiBIQkEgY29uZGl0aW9uDQpvY2N1cnJlZCBhbmQgdGhlIEhC
QSBkb2VzIG5vdCB0cmlnZ2VyIGFuIGludGVycnVwdCB3aGVuIHRoYXQgY29uZGl0aW9uIGlzDQpj
bGVhcmVkLCBob3cgdG8gZmlndXJlIG91dCB3aGV0aGVyIG9yIG5vdCBhIHJlcXVlc3QgY2FuIGJl
IGV4ZWN1dGVkIG90aGVyIHRoYW4NCmJ5IHJldHJ5aW5nLCB3aGljaCBtZWFucyByZXJ1bm5pbmcg
dGhlIHF1ZXVlPw0KDQpUaGFua3MsDQoNCkJhcnQu
