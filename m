From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH v2] scsi: ufs: add trace event for ufs upiu
Date: Thu, 22 Mar 2018 14:15:34 +0000
Message-ID: <562b08c355de2fe594b0a236172f43289154a6e7.camel@wdc.com>
References: <1521719439-2251-1-git-send-email-ohad.sharabi@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1521719439-2251-1-git-send-email-ohad.sharabi@sandisk.com>
Content-Language: en-US
Content-ID: <4EE5CF9BD7C0F042AAEA7D18E66581B8@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ohad Sharabi <Ohad.Sharabi@wdc.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, Stanislav Nijnikov <Stanislav.Nijnikov@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Alex Lemberg <Alex.Lemberg@wdc.com>
List-Id: linux-scsi@vger.kernel.org

T24gVGh1LCAyMDE4LTAzLTIyIGF0IDEzOjUwICswMjAwLCBPaGFkIFNoYXJhYmkgd3JvdGU6DQo+
ICtzdGF0aWMgdm9pZCB1ZnNoY2RfYWRkX2NtZF91cGl1X3RyYWNlKHN0cnVjdCB1ZnNfaGJhICpo
YmEsIHVuc2lnbmVkIGludCB0YWcsDQo+ICsJCWNvbnN0IGNoYXIgKnN0cikNCj4gK3sNCj4gKwlz
dHJ1Y3QgdXRwX3VwaXVfcmVxICpycSA9IGhiYS0+bHJiW3RhZ10udWNkX3JlcV9wdHI7DQo+ICsN
Cj4gKwl0cmFjZV91ZnNoY2RfdXBpdShkZXZfbmFtZShoYmEtPmRldiksIHN0ciwgKHU4ICopJnJx
LT5oZWFkZXIsDQo+ICsJCQkodTggKikmcnEtPnNjLmNkYik7DQo+ICt9DQo+ICsNCj4gK3N0YXRp
YyB2b2lkIHVmc2hjZF9hZGRfcXVlcnlfdXBpdV90cmFjZShzdHJ1Y3QgdWZzX2hiYSAqaGJhLCB1
bnNpZ25lZCBpbnQgdGFnLA0KPiArCQljb25zdCBjaGFyICpzdHIpDQo+ICt7DQo+ICsJc3RydWN0
IHV0cF91cGl1X3JlcSAqcnEgPSBoYmEtPmxyYlt0YWddLnVjZF9yZXFfcHRyOw0KPiArDQo+ICsJ
dHJhY2VfdWZzaGNkX3VwaXUoZGV2X25hbWUoaGJhLT5kZXYpLCBzdHIsICh1OCAqKSZycS0+aGVh
ZGVyLA0KPiArCQkJKHU4ICopJnJxLT5xcik7DQo+ICt9DQo+ICsNCj4gK3N0YXRpYyB2b2lkIHVm
c2hjZF9hZGRfdG1fdXBpdV90cmFjZShzdHJ1Y3QgdWZzX2hiYSAqaGJhLCB1bnNpZ25lZCBpbnQg
dGFnLA0KPiArCQljb25zdCBjaGFyICpzdHIpDQo+ICt7DQo+ICsJc3RydWN0IHV0cF90YXNrX3Jl
cV9kZXNjICpkZXNjcDsNCj4gKwlzdHJ1Y3QgdXRwX3VwaXVfdGFza19yZXEgKnRhc2tfcmVxOw0K
PiArCWludCBvZmYgPSAoaW50KXRhZyAtIGhiYS0+bnV0cnM7DQo+ICsNCj4gKwlkZXNjcCA9ICZo
YmEtPnV0bXJkbF9iYXNlX2FkZHJbb2ZmXTsNCj4gKwl0YXNrX3JlcSA9IChzdHJ1Y3QgdXRwX3Vw
aXVfdGFza19yZXEgKilkZXNjcC0+dGFza19yZXFfdXBpdTsNCj4gKwl0cmFjZV91ZnNoY2RfdXBp
dShkZXZfbmFtZShoYmEtPmRldiksIHN0ciwgKHU4ICopJnRhc2tfcmVxLT5oZWFkZXIsDQo+ICsJ
CQkodTggKikmdGFza19yZXEtPmlucHV0X3BhcmFtMSk7DQo+ICt9DQoNCkNhbiB0aGUgdHJhY2Vf
dWZzaGNkX3VwaXUoKSBkZWZpbml0aW9uIGJlIGNoYW5nZWQgc3VjaCB0aGF0IHRoZSB0aGlyZCBh
bmQNCmZvdXJ0aCBhcmd1bWVudCBhcmUgZGVjbGFyZWQgYXMgJ3ZvaWQgKicgc3VjaCB0aGF0IHRo
ZSB1Z2x5ICcodTggKiknIGNhc3RzDQpjYW4gYmUgbGVmdCBvdXQgZnJvbSB0aGUgY2FsbGVycz8N
Cg0KVGhhbmtzLA0KDQpCYXJ0Lg0KDQoNCg==
