From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH v9 09/10] block, scsi: Make SCSI quiesce and resume work
 reliably
Date: Tue, 17 Oct 2017 20:18:04 +0000
Message-ID: <1508271483.3457.15.camel@wdc.com>
References: <20171016232905.5047-1-bart.vanassche@wdc.com>
         <20171016232905.5047-10-bart.vanassche@wdc.com>
         <df8b960d-e65d-3e5e-9de7-4423aa65ad92@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <df8b960d-e65d-3e5e-9de7-4423aa65ad92@suse.de>
Content-Language: en-US
Content-ID: <5FFC048D5EC772408C6E9638F4B60360@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "hare@suse.com" <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

T24gVHVlLCAyMDE3LTEwLTE3IGF0IDA4OjMzICswMjAwLCBIYW5uZXMgUmVpbmVja2Ugd3JvdGU6
DQo+IEhvdyBkbyB5b3UgZW5zdXJlIHRoYXQgUFJFRU1QVCByZXF1ZXN0cyBhcmUgbm90IHN0dWNr
IGluIHRoZSBxdWV1ZQ0KPiBfYmVoaW5kXyBub24tUFJFRU1QVCByZXF1ZXN0cz8NCj4gT25jZSB0
aGV5IGFyZSBpbiB0aGUgcXVldWUgdGhlIHJlcXVlc3QgYXJlIGFscmVhZHkgYWxsb2NhdGVkLCBz
byB5b3VyDQo+IGRlZmVycmVkIGFsbG9jYXRpb24gd29uJ3Qgd29yay4NCj4gX0FuZF8gZGVmZXJy
ZWQgcmVxdWVzdHMgd2lsbCBiZSByZS1pbnNlcnRlZCBhdCB0aGUgaGVhZCBvZiB0aGUgcXVldWUu
DQo+IENvbnNlcXVlbnRseSB0aGUgUFJFRU1QVCByZXF1ZXN0IHdpbGwgbmV2ZXIgZXZlciBzY2hl
ZHVsZWQgZHVyaW5nIHF1aWVzY2UuDQo+IEhvdyBkbyB5b3UgYXZvaWQgc3VjaCBhIHNjZW5hcmlv
Pw0KDQpIZWxsbyBIYW5uZXMsDQoNClRoZSBibGtfbXFfZnJlZXplX3F1ZXVlKCkgLyBibGtfbXFf
dW5mcmVlemVfcXVldWUoKSBjYWxscyB0aGF0IGhhdmUgYmVlbg0KYWRkZWQgdGhyb3VnaCBwYXRj
aCA5LzEwIHRvIHNjc2lfZGV2aWNlX3F1aWVzY2UoKSB3aWxsIG9ubHkgc3VjY2VlZCBhZnRlciBh
bGwNCm91dHN0YW5kaW5nIHJlcXVlc3RzIGhhdmUgZmluaXNoZWQuIFRoYXQgaW5jbHVkZXMgbm9u
LXByZWVtcHQgcmVxdWVzdHMgYW5kDQpyZXF1ZXN0cyB0aGF0IGFyZSBhYm91dCB0byBiZSByZXF1
ZXVlZC4gVGhlIGNoYW5nZXMgaW4gc2NzaV9kZXZpY2VfcXVpZXNjZSgpDQphcmUgc3VjaCB0aGF0
IGJsa19xdWV1ZV9lbnRlcigpIHdpbGwgZmFpbCBmb3Igbm9uLXByZWVtcHQgcmVxdWVzdHMgYWZ0
ZXIgdGhlDQpxdWV1ZSBoYXMgYmVlbiB1bmZyb3plbi4gSW4gb3RoZXIgd29yZHMsIGlmIGEgc2Nz
aV9kZXZpY2VfcXVpZXNjZSgpIGNhbGwNCnN1Y2NlZWRzLCBpdCBpcyBndWFyYW50ZWVkIHRoYXQg
dGhlcmUgYXJlIG5vIG5vbi1wcmVlbXB0IHJlcXVlc3RzIGluIHRoZSBxdWV1ZQ0KYW5kIGFsc28g
dGhhdCBubyBuZXcgbm9uLXByZWVtcHQgcmVxdWVzdHMgd2lsbCBlbnRlciB0aGUgcXVldWUgdW50
aWwNCnNjc2lfZGV2aWNlX3Jlc3VtZSgpIGlzIGNhbGxlZC4NCg0KQmFydC4=
