From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] SCSI: run queue if SCSI device queue isn't ready and
 queue is idle
Date: Tue, 5 Dec 2017 16:16:44 +0000
Message-ID: <1512490603.2660.13.camel@sandisk.com>
References: <20171205075256.10319-1-ming.lei@redhat.com>
         <mqd374ptfh8.fsf@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <mqd374ptfh8.fsf@linux-x5ow.site>
Content-Language: en-US
Content-ID: <CB0783EAC702414A887F08F9EA34BABF@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "osandov@osandov.com" <osandov@osandov.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "hare@suse.com" <hare@suse.com>, "holger@applied-asynchrony.com" <holger@applied-asynchrony.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

T24gVHVlLCAyMDE3LTEyLTA1IGF0IDE1OjI5ICswMTAwLCBKb2hhbm5lcyBUaHVtc2hpcm4gd3Jv
dGU6DQo+IDEpIFRlc3Rpbmcgd2l0aG91dCB0aGUgcGF0Y2ggYXBwbGllZCBoYW5ncyB0aGUgdGVz
dCBmb3JldmVyIGFzIGl0DQo+ICAgIGRvZXNuJ3QgZ2V0IGtpbGxlZCBhZnRlciBhIHNwZWNpZmlj
IHRpbWVvdXQgKEkgdGhpbmsgdGhpcyBzaG91bGQgYmUNCj4gICAgc29sdmVkIGluIGEgY29tbW9u
IGZ1bmN0aW9uKS4NCg0KSGVsbG8gSm9oYW5uZXMsDQoNCklmIGEgcmVxdWVzdCBxdWV1ZSBnb3Qg
c3R1Y2sgdGhlbiB0aGUgcHJvY2Vzc2VzIHRoYXQgc3VibWl0dGVkIHRoZSByZXF1ZXN0cw0Kb24g
dGhhdCBxdWV1ZSBhcmUgdW5raWxsYWJsZS4gVGhlIG9ubHkgYXBwcm9hY2ggSSBrbm93IG9mIHRv
IHN0b3AgdGhlc2UNCnByb2Nlc3NlcyBpcyB0byBzZW5kIGEga2lsbCBzaWduYWwgYW5kIG5leHQg
dG8gdHJpZ2dlciBhIHF1ZXVlIHJ1biBmcm9tIHVzZXINCnNwYWNlLiBPbmUgcG9zc2libGUgYXBw
cm9hY2ggaXMgdG8gcnVuIHRoZSBmb2xsb3dpbmcgY29tbWFuZDoNCg0KICAgIGZvciBkIGluIC9z
eXMva2VybmVsL2RlYnVnL2Jsb2NrLyo7IGRvIGVjaG8ga2ljayA+JGQvc3RhdGU7IGRvbmUNCg0K
QmFydC4=
