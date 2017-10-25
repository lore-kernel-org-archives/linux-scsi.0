From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] iscsi-target: Convert timers to use timer_setup()
Date: Wed, 25 Oct 2017 15:03:19 +0000
Message-ID: <1508943795.4165.18.camel@wdc.com>
References: <20171025100145.GA144703@beast>
         <CAHmME9pJRRhWg3=eorVkkSXhpsPgeCfRJFJp2i1-kdXr_E0PCA@mail.gmail.com>
         <CAGXu5jKNDM8NjgtgBp-XapHEiaY_ryk3pBXdaryux6spX++zmQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jKNDM8NjgtgBp-XapHEiaY_ryk3pBXdaryux6spX++zmQ@mail.gmail.com>
Content-Language: en-US
Content-ID: <738107933A99964D87B61120E8E11E93@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "keescook@chromium.org" <keescook@chromium.org>, "Jason@zx2c4.com" <Jason@zx2c4.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jiangyilism@gmail.com" <jiangyilism@gmail.com>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "varun@chelsio.com" <varun@chelsio.com>
List-Id: linux-scsi@vger.kernel.org

T24gV2VkLCAyMDE3LTEwLTI1IGF0IDE2OjEwICswMjAwLCBLZWVzIENvb2sgd3JvdGU6DQo+IEhv
d2V2ZXIsIG1haW50YWluZXJzOiBzb3JyeSB0byBzZW5kIHRoaXMgb25lIC0tIGl0IGNhbid0IGJl
IG1lcmdlZA0KPiB5ZXQsIHRoaXMgdXNlcyB0aW1lcl9zZXR1cF9vbl9zdGFjaygpIHdoaWNoIGlz
IG9ubHkgaW4gLW5leHQgcmlnaHQNCj4gbm93LiBJZiBpdCBsb29rcyBva2F5LCB0aG91Z2gsIEkg
Y2FuIGNhcnJ5IHRoaXMgaW4gdGhlIHRpbWVyIHRyZWUuDQoNCkhlbGxvIEtlZXMsDQoNCkNhbiB5
b3UgaGF2ZSBhIGxvb2sgYXQgdGhlIGZvbGxvd2luZyBwYXRjaCBhbmQgcXVldWUgaXQgYmVmb3Jl
IHlvdXINCnBhdGNoIGlmIHlvdSB0aGluayB0aGlzIHdvdWxkIGJlIHVzZWZ1bCAodGhpcyBwYXRj
aCBoYXMgYmVlbiB0ZXN0ZWQpOg0KInRhcmdldC9pc2NzaTogU2ltcGxpZnkgdGltZXIgbWFuaXB1
bGF0aW9uIGNvZGUiDQooaHR0cHM6Ly93d3cuc3Bpbmljcy5uZXQvbGlzdHMvdGFyZ2V0LWRldmVs
L21zZzE1Mzg1Lmh0bWwpLg0KDQpUaGFua3MsDQoNCkJhcnQu
