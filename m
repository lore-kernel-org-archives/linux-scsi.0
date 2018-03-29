From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] scsi: Introduce sdev_printk_ratelimited to throttle
 frequent printk
Date: Thu, 29 Mar 2018 23:56:05 +0000
Message-ID: <ab95f87c23832aed080d0c1b6f329471a26d549b.camel@wdc.com>
References: <1522226584-137056-1-git-send-email-wen.yang99@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1522226584-137056-1-git-send-email-wen.yang99@zte.com.cn>
Content-Language: en-US
Content-ID: <A661D461B7C25747A4EF9EEE37B927AC@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "wen.yang99@zte.com.cn" <wen.yang99@zte.com.cn>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jiang.biao2@zte.com.cn" <jiang.biao2@zte.com.cn>, "zhong.weidong@zte.com.cn" <zhong.weidong@zte.com.cn>, "sergey.senozhatsky.work@gmail.com" <sergey.senozhatsky.work@gmail.com>, "pmladek@suse.com" <pmladek@suse.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "tan.hu@zte.com.cn" <tan.hu@zte.com.cn>, "tj@kernel.org" <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

T24gV2VkLCAyMDE4LTAzLTI4IGF0IDE2OjQzICswODAwLCBXZW4gWWFuZyB3cm90ZToNCj4gVGhl
cmUgd291bGQgYmUgc28gbWFueSBzYW1lIGxpbmVzIHByaW50ZWQgYnkgZnJlcXVlbnQgcHJpbmsg
aWYgb25lIA0KPiBkaXNrIHdlbnQgd3JvbmcsIGxpa2UsDQo+IFsgIDU0Ni4xODUyNDJdIHNkIDA6
MTowOjA6IHJlamVjdGluZyBJL08gdG8gb2ZmbGluZSBkZXZpY2UNCj4gWyAgNTQ2LjE4NTI1OF0g
c2QgMDoxOjA6MDogcmVqZWN0aW5nIEkvTyB0byBvZmZsaW5lIGRldmljZQ0KPiBbICA1NDYuMTg1
MjgwXSBzZCAwOjE6MDowOiByZWplY3RpbmcgSS9PIHRvIG9mZmxpbmUgZGV2aWNlDQo+IFsgIDU0
Ni4xODUzMDddIHNkIDA6MTowOjA6IHJlamVjdGluZyBJL08gdG8gb2ZmbGluZSBkZXZpY2UNCj4g
WyAgNTQ2LjE4NTMzNF0gc2QgMDoxOjA6MDogcmVqZWN0aW5nIEkvTyB0byBvZmZsaW5lIGRldmlj
ZQ0KPiBbICA1NDYuMTg1MzY0XSBzZCAwOjE6MDowOiByZWplY3RpbmcgSS9PIHRvIG9mZmxpbmUg
ZGV2aWNlDQo+IFsgIDU0Ni4xODUzOTBdIHNkIDA6MTowOjA6IHJlamVjdGluZyBJL08gdG8gb2Zm
bGluZSBkZXZpY2UNCj4gWyAgNTQ2LjE4NTQxMF0gc2QgMDoxOjA6MDogcmVqZWN0aW5nIEkvTyB0
byBvZmZsaW5lIGRldmljZQ0KPiBGb3Igc2xvdyBzZXJpYWwgY29uc29sZSwgdGhlIGZyZXF1ZW50
IHByaW5rIG1heSBibG9jayB0aGUgcHJpbnRrLCBhbmQgDQo+IGlmIHNwaW5fbG9jayB3YXMgYWNx
dWlyZWQgYmVmb3JlIHRoZSBwcmludGsgbGlrZSBpbiBzY3NpX3JlcXVlc3RfZm4sDQo+IHRoYXQg
Y291bGQgdHJpZ2dlciB0aGUgd2F0Y2hkb2cuDQo+IA0KPiBSZWxhdGl2ZSBkaXNzY3Vzc2lvbiBj
YW4gYmUgZm91bmQgaGVyZSwNCiAgXl5eXl5eXl4NCiAgUmVsYXRlZD8NCg0KQW55d2F5Og0KDQpS
ZXZpZXdlZC1ieTogQmFydCBWYW4gQXNzY2hlIDxiYXJ0LnZhbmFzc2NoZUB3ZGMuY29tPg0KDQoN
Cg0KDQoNCg==
