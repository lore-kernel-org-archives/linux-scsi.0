From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within
 a USB payload burst [NEW HARDWARE]
Date: Tue, 14 Jan 2014 09:43:57 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D45B08A@AcuExch.aculab.com>
References: <20140109235045.GA17660@xanatos> <52D4791B.3030309@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <52D4791B.3030309@gmail.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: 'walt' <w41ter@gmail.com>, Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

RnJvbTogd2FsdA0KPiBPbiAwMS8wOS8yMDE0IDAzOjUwIFBNLCBTYXJhaCBTaGFycCB3cm90ZToN
Cj4gDQo+ID4+PiBPbiBUdWUsIEphbiAwNywgMjAxNCBhdCAwMzo1NzowMFBNIC0wODAwLCB3YWx0
IHdyb3RlOg0KPiA+Pg0KPiA+PiBJJ3ZlIHdvbmRlcmVkIGlmIG15IHhoY2kgcHJvYmxlbXMgbWln
aHQgYmUgY2F1c2VkIGJ5IGhhcmR3YXJlIHF1aXJrcywgYW5kDQo+ID4+IHdvbmRlcmluZyB3aHkg
SSBzZWVtIHRvIGJlIHRoZSBvbmx5IG9uZSB3aG8gaGFzIHRoaXMgcHJvYmxlbS4NCj4gPj4NCj4g
Pj4gTWF5YmUgSSBjb3VsZCAidGFrZSBvbmUgZm9yIHRoZSB0ZWFtIiBieSBidXlpbmcgbmV3IGhh
cmR3YXJlIHRveXMgdGhhdCBJDQo+ID4+IGRvbid0IHJlYWxseSBuZWVkIGJ1dCBJIGNvdWxkIHVz
ZSB0byB0ZXN0IHRoZSB4aGNpIGRyaXZlcj8gIChJIGRvIGVuam95DQo+ID4+IGJ1eWluZyBuZXcg
dG95cywgbmVjZXNzYXJ5LCBvciwgdW0sIG1heWJlIG5vdCA6KQ0KPiA+DQo+ID4gSXQgd291bGQg
YmUgYXBwcmVjaWF0ZWQgaWYgeW91IGNvdWxkIHNlZSBpZiB5b3VyIGRldmljZSBjYXVzZXMgb3Ro
ZXINCj4gPiBob3N0IGNvbnRyb2xsZXJzIHRvIGZhaWwuICBXaG8gYW0gSSB0byBrZWVwIGEgZ2Vl
ayBmcm9tIG5ldyB0b3lzPyA7KQ0KPiANCj4gU2FyYWgsIEkganVzdCBmaXhlZCBteSB4aGNpIGJ1
ZyBmb3IgVVMkMTkuOTkgOikNCj4gDQo+ICNsc3BjaSB8IHRhaWwgLTENCj4gMDQ6MDAuMCBVU0Ig
Y29udHJvbGxlcjogTkVDIENvcnBvcmF0aW9uIHVQRDcyMDIwMCBVU0IgMy4wIEhvc3QgQ29udHJv
bGxlciAocmV2IDAzKQ0KDQpEbyB5b3Uga25vdyB3aGljaCB2ZXJzaW9uIG9mIHRoZSB4aGNpIHNw
ZWMgaXQgY29uZm9ybXMgdG8/DQooV2lsbCBwcm9iYWJseSBiZSAwLjk2IG9yIDEuMDApLg0KDQpP
ZiBjb3Vyc2UsIEFTTWVkaWEgd2lsbCBwcm9iYWJseSBjaGFuZ2UgdGhlIHNpbGljb24gdGhleSBh
cmUgdXNpbmcgd2l0aG91dA0KY2hhbmdpbmcgYW55dGhpbmcgb24gdGhlIHBhY2thZ2luZy4NCg0K
CURhdmlkDQo=
