From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] Change synchronize_rcu() in scsi_device_quiesce() into
 synchronize_sched()
Date: Mon, 19 Mar 2018 16:57:45 +0000
Message-ID: <1521478664.2776.12.camel@wdc.com>
References: <20180316173516.3048-1-bart.vanassche@wdc.com>
         <20180319143147.GF2943022@devbig577.frc2.facebook.com>
         <1521472566.2776.6.camel@wdc.com>
         <20180319152144.GM2943022@devbig577.frc2.facebook.com>
         <1521476333.2776.9.camel@wdc.com>
         <20180319162921.GS2943022@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180319162921.GS2943022@devbig577.frc2.facebook.com>
Content-Language: en-US
Content-ID: <890E5C44F3626849AA3AA68C92A918A4@namprd04.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
To: "tj@kernel.org" <tj@kernel.org>
Cc: "jthumshirn@suse.de" <jthumshirn@suse.de>, "hch@lst.de" <hch@lst.de>, "martin@lichtvoll.de" <martin@lichtvoll.de>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "hare@suse.com" <hare@suse.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

T24gTW9uLCAyMDE4LTAzLTE5IGF0IDA5OjI5IC0wNzAwLCB0akBrZXJuZWwub3JnIHdyb3RlOg0K
PiBUaGlzIGNvdWxkIGJlIG1lIGJlaW5nIHNsb3cgYnV0IGNhbiB5b3UgZXhwbGFpbiBob3cgd2hh
dA0KPiBwZXJjcHVfcmVmX3RyeWdldF9saXZlKCkgdXNlcyBpbnRlcm5hbGx5IGFmZmVjdHMgd2hl
dGhlciB3ZSBjYW4gdXNlDQo+IHJlZ3VsYXIgUkNVIGFyb3VuZCBpdD8NCg0KSGVsbG8gVGVqdW4s
DQoNCkZvciBzeW5jaHJvbml6YXRpb24gcHJpbWl0aXZlcyB0aGF0IHdhaXQgaGF2aW5nIGEgc3Ry
b25nZXIgc3luY2hyb25pemF0aW9uDQpwcmltaXRpdmUgbmVzdGVkIGluc2lkZSBhIG1vcmUgcmVs
YXhlZCBvbmUgY2FuIGxlYWQgdG8gYSBkZWFkbG9jay4gQnV0IHNpbmNlDQp0aGUgcmN1IHJlYWQg
bG9jayBwcmltaXRpdmVzIGRvIG5vdCB3YWl0IGl0IGNvdWxkIGJlIHNhZmUgdG8gdXNlIHRoYXQg
a2luZA0Kb2YgbmVzdGluZyB3aXRoIFJDVS4gRG8geW91IHBlcmhhcHMga25vdyB3aGV0aGVyIGFu
eSBkb2N1bWVudGF0aW9uIGlzDQphdmFpbGFibGUgYWJvdXQgdGhhdCBraW5kIG9mIG5lc3Rpbmcg
b3Igd2hldGhlciBpdCBpcyBhbHJlYWR5IHVzZWQgZWxzZXdoZXJlDQppbiB0aGUga2VybmVsPw0K
DQpUaGFua3MsDQoNCkJhcnQuDQoNCg==
