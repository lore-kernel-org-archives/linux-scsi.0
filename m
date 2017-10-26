From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] iscsi-target: Convert timers to use timer_setup()
Date: Thu, 26 Oct 2017 14:04:13 +0000
Message-ID: <1509026649.13829.0.camel@wdc.com>
References: <20171025100145.GA144703@beast>
         <CAHmME9pJRRhWg3=eorVkkSXhpsPgeCfRJFJp2i1-kdXr_E0PCA@mail.gmail.com>
         <CAGXu5jKNDM8NjgtgBp-XapHEiaY_ryk3pBXdaryux6spX++zmQ@mail.gmail.com>
         <1508943795.4165.18.camel@wdc.com>
         <CAGXu5j+xk+tHh5z9Hvtg6kGSuZQcK=QYHpcZf_akMnKjP69CKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:34452 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932234AbdJZOES (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Oct 2017 10:04:18 -0400
In-Reply-To: <CAGXu5j+xk+tHh5z9Hvtg6kGSuZQcK=QYHpcZf_akMnKjP69CKA@mail.gmail.com>
Content-Language: en-US
Content-ID: <80E67E432D1DC74E9BF1DAE10E0E09A4@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "keescook@chromium.org" <keescook@chromium.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jiangyilism@gmail.com" <jiangyilism@gmail.com>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "Jason@zx2c4.com" <Jason@zx2c4.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "varun@chelsio.com" <varun@chelsio.com>

T24gVGh1LCAyMDE3LTEwLTI2IGF0IDEwOjI0ICswMjAwLCBLZWVzIENvb2sgd3JvdGU6DQo+IE9u
IFdlZCwgT2N0IDI1LCAyMDE3IGF0IDU6MDMgUE0sIEJhcnQgVmFuIEFzc2NoZSA8QmFydC5WYW5B
c3NjaGVAd2RjLmNvbT4gd3JvdGU6DQo+ID4gT24gV2VkLCAyMDE3LTEwLTI1IGF0IDE2OjEwICsw
MjAwLCBLZWVzIENvb2sgd3JvdGU6DQo+ID4gPiBIb3dldmVyLCBtYWludGFpbmVyczogc29ycnkg
dG8gc2VuZCB0aGlzIG9uZSAtLSBpdCBjYW4ndCBiZSBtZXJnZWQNCj4gPiA+IHlldCwgdGhpcyB1
c2VzIHRpbWVyX3NldHVwX29uX3N0YWNrKCkgd2hpY2ggaXMgb25seSBpbiAtbmV4dCByaWdodA0K
PiA+ID4gbm93LiBJZiBpdCBsb29rcyBva2F5LCB0aG91Z2gsIEkgY2FuIGNhcnJ5IHRoaXMgaW4g
dGhlIHRpbWVyIHRyZWUuDQo+ID4gDQo+ID4gSGVsbG8gS2VlcywNCj4gPiANCj4gPiBDYW4geW91
IGhhdmUgYSBsb29rIGF0IHRoZSBmb2xsb3dpbmcgcGF0Y2ggYW5kIHF1ZXVlIGl0IGJlZm9yZSB5
b3VyDQo+ID4gcGF0Y2ggaWYgeW91IHRoaW5rIHRoaXMgd291bGQgYmUgdXNlZnVsICh0aGlzIHBh
dGNoIGhhcyBiZWVuIHRlc3RlZCk6DQo+ID4gInRhcmdldC9pc2NzaTogU2ltcGxpZnkgdGltZXIg
bWFuaXB1bGF0aW9uIGNvZGUiDQo+ID4gKGh0dHBzOi8vd3d3LnNwaW5pY3MubmV0L2xpc3RzL3Rh
cmdldC1kZXZlbC9tc2cxNTM4NS5odG1sKS4NCj4gDQo+IFRoaXMgbG9va3MgZ29vZCwgeWVhaC4g
Q2FuIHlvdSByZXNlbmQgaXQgd2l0aCBtZSBDQ2VkPyBJdCBkb2Vzbid0IGxvb2sNCj4gbGlrZSBp
dCB3YXMgQ0NlZCB0byBsa21sLCBzbyBpdCdzIG5vdCBlYXN5IHRvIGZvciBtZSB0byBhZGQgaXQg
dG8gbWUNCj4gdHJlZS4NCg0KT0ssIEkgd2lsbCByZXNlbmQgdGhhdCBwYXRjaCBhcyBhIHJlcGx5
IHRvIHRoaXMgZS1tYWlsLiBCVFcsIEkganVzdCBmaW5pc2hlZA0KcmV0ZXN0aW5nIHRoYXQgcGF0
Y2ggb24gdG9wIG9mIHY0LjE0LXJjNi4NCg0KQmFydC4=
