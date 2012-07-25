From: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
Subject: RE: 'Device not ready' issue on mpt2sas since 3.1.10
Date: Wed, 25 Jul 2012 15:56:39 +0530
Message-ID: <DCD177647606E9419ED923E0C8C4AA7223E1E95F10@inbmail02.lsi.com>
References: <4FFB8A86.7000009@farcaster.org>
 <4FFCBA4C.4000502@farcaster.org> <4FFD6F3D.2030708@matthiasprager.de>
 <4FFD8410.7050604@matthiasprager.de> <20120717180932.GB2878@google.com>
 <5005BF7D.2050703@matthiasprager.de> <20120717200136.GC24336@google.com>
 <500A9D7C.8080801@matthiasprager.de>
 <20120722173146.GE5144@dhcp-172-17-108-109.mtv.corp.google.com>
 <500C8938.2080607@matthiasprager.de> <20120723152619.GD6823@google.com>
 <500F1BEA.8010104@matthiasprager.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:47346 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753840Ab2GYK0t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jul 2012 06:26:49 -0400
In-Reply-To: <500F1BEA.8010104@matthiasprager.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthias Prager <linux@matthiasprager.de>, Tejun Heo <tj@kernel.org>
Cc: Robert Trace <maillist@farcaster.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jens Axboe <jaxboe@fusionio.com>, "Moore, Eric" <Eric.Moore@lsi.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Alan <alan@lxorguk.ukuu.org.uk>, "Darrick J. Wong" <djwong@us.ibm.com>

SGksDQoNCldlIGhhdmUgZG9uZSBzb21lIGFuYWx5c2lzIG9uIHRoaXMgaXNzdWUuIEZyb20gb3Vy
IGFuYWx5c2lzIHdlIG9ic2VydmVkIHRoYXQsIHRoaXMgaXNzdWUgaXMgcmVwcm9kdWNpYmxlIG9u
IGtlcm5lbCAzLjEuMTAgb253YXJkcyBidXQgaW4gMy4wLjM2IHRoaXMgaXNzdWUgaXMgbm90IHJl
cHJvZHVjaWJsZS4gU28sIHdlIGhhdmUgdGFrZW4gdGhlIG1wdDJzYXMgY29kZSBmcm9tIDMuMS4x
MCBrZXJuZWwgYW5kIGNvbXBpbGVkIGFuZCBydW4gaXQgb24gMy4wLjM2IGtlcm5lbC4gSGVyZSB0
aGlzIGlzc3VlIGlzIG5vdCByZXByb2R1Y2libGUgKGkuZS4gaXQgaXMgd29ya2luZyBmaW5lKS4g
DQoNCkZyb20gMy4wLjM2IGtlcm5lbCBvbndhcmRzIHdlIGhhdmUgbm90IGFkZGVkIGFueSBwYXRj
aGVzIHRoYXQgd2lsbCBjYXVzZSB0aGlzIGlzc3VlLiBTbywgd2hhdCBJIG1lYW4gdG8gc2F5IGlz
ICJ0aGlzIGlzc3VlIGlzIG5vdCBiZWNhdXNlIG9mIG1wdDJzYXMgZHJpdmVyIi4NCg0KUmVnYXJk
cywNClNyZWVrYW50aC4gIA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206
IGxpbnV4LXNjc2ktb3duZXJAdmdlci5rZXJuZWwub3JnIFttYWlsdG86bGludXgtc2NzaS0NCj4g
b3duZXJAdmdlci5rZXJuZWwub3JnXSBPbiBCZWhhbGYgT2YgTWF0dGhpYXMgUHJhZ2VyDQo+IFNl
bnQ6IFdlZG5lc2RheSwgSnVseSAyNSwgMjAxMiAzOjM0IEFNDQo+IFRvOiBUZWp1biBIZW8NCj4g
Q2M6IFJvYmVydCBUcmFjZTsgbGludXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmc7IEplbnMgQXhib2U7
IE1vb3JlLCBFcmljOw0KPiBKYW1lcyBFLkouIEJvdHRvbWxleTsgQWxhbjsgRGFycmljayBKLiBX
b25nOyBNYXR0aGlhcyBQcmFnZXINCj4gU3ViamVjdDogUmU6ICdEZXZpY2Ugbm90IHJlYWR5JyBp
c3N1ZSBvbiBtcHQyc2FzIHNpbmNlIDMuMS4xMA0KPiANCj4gSGVsbG8gZXZlcnlvbmUsDQo+IA0K
PiBJIHJldGVzdGVkIHdpdGggYSBuZXcgZmlybXdhcmUgKFAxNCAtIHJlbGVhc2VkIHRvZGF5KSwg
c2luY2UgaXQNCj4gY29udGFpbnMNCj4gYSBidW5jaCBvZiBzYXRhIGFuZCBTQVRMIGZpeGVzIChh
Y2NvcmRpbmcgdG8gdGhlIGNoYW5nZWxvZykuDQo+IFVuZm9ydHVuYXRlbHkgdGhlIG9ic2VydmVk
IGJlaGF2aW9yIGlzIHVuY2hhbmdlZCAodGVzdGVkIG9uIGEgMy40LjUNCj4ga2VybmVsKS4NCj4g
DQo+IEp1c3Qgd2FudGVkIHRvIGxldCBldmVyeW9uZSBrbm93Lg0KPiANCj4gQ2hlZXJzDQo+IE1h
dHRoaWFzDQo+IC0tDQo+IFRvIHVuc3Vic2NyaWJlIGZyb20gdGhpcyBsaXN0OiBzZW5kIHRoZSBs
aW5lICJ1bnN1YnNjcmliZSBsaW51eC1zY3NpIg0KPiBpbg0KPiB0aGUgYm9keSBvZiBhIG1lc3Nh
Z2UgdG8gbWFqb3Jkb21vQHZnZXIua2VybmVsLm9yZw0KPiBNb3JlIG1ham9yZG9tbyBpbmZvIGF0
ICBodHRwOi8vdmdlci5rZXJuZWwub3JnL21ham9yZG9tby1pbmZvLmh0bWwNCg==
