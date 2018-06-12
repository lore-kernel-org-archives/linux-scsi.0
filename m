From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 2/3] scsi: check for equality of result byte values
Date: Tue, 12 Jun 2018 15:12:00 +0000
Message-ID: <45da3041af0060a0a914e04d4870182f640e7d9d.camel@wdc.com>
References: <20180612135311.13216-1-jthumshirn@suse.de>
         <20180612135311.13216-3-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180612135311.13216-3-jthumshirn@suse.de>
Content-Language: en-US
Content-ID: <15215FB1BD6740439EBB4A3FD62DE0E4@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "jthumshirn@suse.de" <jthumshirn@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

T24gVHVlLCAyMDE4LTA2LTEyIGF0IDE1OjUzICswMjAwLCBKb2hhbm5lcyBUaHVtc2hpcm4gd3Jv
dGU6DQo+IC0JCSAgICAgfHwgc3RhdHVzX2J5dGUoY21kLT5yZXN1bHQpICYNCj4gKwkJICAgICB8
fCBzdGF0dXNfYnl0ZShjbWQtPnJlc3VsdCkgPT0NCj4gIAkJICAgICBDSEVDS19DT05ESVRJT04p
KSB7DQoNCklzICJzdGF0dXNfYnl0ZShjbWQtPnJlc3VsdCkgPT0gQ0hFQ0tfQ09ORElUSU9OIiBz
aG9ydCBlbm91Z2ggZm9yIGEgc2luZ2xlDQpsaW5lIG9mIGNvZGU/IElzIHRoZSBsaW5lIHNwbGl0
dGluZyByZWFsbHkgbmVjZXNzYXJ5Pw0KDQo+IC0JCWlmICghKGRyaXZlcl9ieXRlKHJlc3VsdCkg
JiBEUklWRVJfU0VOU0UpIHx8DQo+ICsJCWlmICghKGRyaXZlcl9ieXRlKHJlc3VsdCkgPT0gRFJJ
VkVSX1NFTlNFKSB8fA0KDQpQbGVhc2UgY2hhbmdlICghKHggPT0geSkpIGludG8gKHggIT0geSku
DQoNCj4gLQlpZiAoKGRyaXZlcl9ieXRlKHJlc3VsdCkgJiBEUklWRVJfU0VOU0UpICYmDQo+ICsJ
aWYgKChkcml2ZXJfYnl0ZShyZXN1bHQpID09IERSSVZFUl9TRU5TRSkgJiYNCg0KUGxlYXNlIGNo
YW5nZSAoZHJpdmVyX2J5dGUocmVzdWx0KSA9PSBEUklWRVJfU0VOU0UpIGludG8NCmRyaXZlcl9i
eXRlKHJlc3VsdCkgPT0gRFJJVkVSX1NFTlNFLg0KDQo+IC0JCQkgICgoZHJpdmVyX2J5dGUodGhl
X3Jlc3VsdCkgJiBEUklWRVJfU0VOU0UpICYmDQo+ICsJCQkgICgoZHJpdmVyX2J5dGUodGhlX3Jl
c3VsdCkgPT0gRFJJVkVSX1NFTlNFKSAmJg0KDQpTYW1lIGNvbW1lbnQgaGVyZS4NCg0KPiAtCQlp
ZiAoKGRyaXZlcl9ieXRlKHRoZV9yZXN1bHQpICYgRFJJVkVSX1NFTlNFKSA9PSAwKSB7DQo+ICsJ
CWlmICgoZHJpdmVyX2J5dGUodGhlX3Jlc3VsdCkgPT0gRFJJVkVSX1NFTlNFKSA9PSAwKSB7DQoN
ClBsZWFzZSBjaGFuZ2UgKHggPT0geSkgPT0gMCBpbnRvIHggIT0geS4NCg0KVGhhbmtzLA0KDQpC
YXJ0Lg0KDQoNCg0KDQo=
