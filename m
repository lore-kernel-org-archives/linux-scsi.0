From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH v1.3 1/11] arcmsr: Revise interrupt service routine to
 fix command timeout
Date: Fri, 21 Feb 2014 01:43:40 +0000
Message-ID: <1392947020.11425.1.camel@dabdike>
References: <CAKiknE9pf-hQOTcxbw8WnHECDJDZMHJA-TBEPeg7+q5nb+AoCA@mail.gmail.com>
	 <20140220121435.GY26776@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:50340 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599AbaBUBoO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Feb 2014 20:44:14 -0500
In-Reply-To: <20140220121435.GY26776@mwanda>
Content-Language: en-US
Content-ID: <F9384BD96208894E9206BE2B54A5C0D1@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "fengguang.wu@intel.com" <fengguang.wu@intel.com>, "ching2048@areca.com.tw" <ching2048@areca.com.tw>, "thenzl@redhat.com" <thenzl@redhat.com>, "billion.wu@areca.com.tw" <billion.wu@areca.com.tw>

T24gVGh1LCAyMDE0LTAyLTIwIGF0IDE1OjE0ICswMzAwLCBEYW4gQ2FycGVudGVyIHdyb3RlOg0K
PiBPbiBUaHUsIEZlYiAyMCwgMjAxNCBhdCAwODowNTowNVBNICswODAwLCDpu4PmuIXpmoYgd3Jv
dGU6DQo+ID4gRnJvbTogQ2hpbmcgPGNoaW5nMjA0OEBhcmVjYS5jb20udHc+DQo+ID4gDQo+ID4g
UmV3cml0ZSBpbnRlcnJ1cHQgc2VydmljZSByb3V0aW5lIHRvIGZpeCBjb21tYW5kIHRpbWVvdXQg
b24gY29udHJvbGxlciB0b28NCj4gPiBoZWF2eSBsb2FkaW5nLg0KPiA+IA0KPiA+IFNpbmdlZC1v
ZmYtYnk6IENoaW5nIDxjaGluZzIwNDhAYXJlY2EuY29tLnR3Pg0KPiANCj4gWW91ciBlbWFpbCBj
bGllbnQgc2NyZXdlZCB1cCB0aGUgd2hpdGVzcGFjZSBjb21wbGV0ZWx5LiAgUmVhZA0KPiBEb2N1
bWVudGF0aW9uL2VtYWlsLWNsaWVudHMudHh0IG9yIHVzZSBgZ2l0IHNlbmQtZW1haWxgDQo+IGh0
dHA6Ly93d3cuZnJlZWRlc2t0b3Aub3JnL3dpa2kvU29mdHdhcmUvUHVsc2VBdWRpby9Ib3dUb1Vz
ZUdpdFNlbmRFbWFpbC8NCj4gDQo+IFRoZXJlIGFyZSBhbHNvIG1hbnkgdW5yZWxhdGVkIHdoaXRl
IHNwYWNlIGNoYW5nZXMgaW4gdGhpcyBwYXRjaC4NCg0KQWN0dWFsbHksIG5vbmUgb2YgdGhlc2Ug
cGF0Y2hlcyBldmVuIG1hZGUgaXQgdG8gdGhlIFNDU0kgbGlzdCwgYmVjYXVzZQ0KdGhleSBoYWQg
aHRtbCBwYXJ0cywgd2hpY2ggdmdlciBkZXN0cm95cy4gIFBsZWFzZSBtYWtlIHRoZSBjaGFuZ2Vz
IERhbg0Kc3VnZ2VzdHMgYW5kIHRoZW4gcmVzdWJtaXQgYXMgcGxhaW4gdGV4dCBvbmx5Lg0KDQpK
YW1lcw0KDQo=
