From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH v2] target/iscsi: Convert timers to use timer_setup()
Date: Tue, 31 Oct 2017 17:34:00 +0000
Message-ID: <1509471239.12927.3.camel@wdc.com>
References: <20171027091930.GA14728@beast> <1509109031.3135.1.camel@wdc.com>
         <CAGXu5j+z9t28n33e6r9hxRNX1hpkzF4Z5sy308sWYh84whkRfQ@mail.gmail.com>
         <1509470185.12927.1.camel@wdc.com> <yq11slj9qtq.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq11slj9qtq.fsf@oracle.com>
Content-Language: en-US
Content-ID: <6DEB89C6FD6F684E832871CC4933AA9A@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "keescook@chromium.org" <keescook@chromium.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "varun@chelsio.com" <varun@chelsio.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "jiangyilism@gmail.com" <jiangyilism@gmail.com>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

T24gVHVlLCAyMDE3LTEwLTMxIGF0IDEzOjIwIC0wNDAwLCBNYXJ0aW4gSy4gUGV0ZXJzZW4gd3Jv
dGU6DQo+ID4gVGhhdCB0cmVlIHBhc3NlZCB0aGUgaVNDU0kgdGFyZ2V0IHRlc3RzIEkgcmFuIHNv
IGZlZWwgZnJlZSB0byBhZGQgbXkNCj4gPiBSZXZpZXdlZC1ieSBhbmQgVGVzdGVkLWJ5IHRvIFtQ
QVRDSCB2Ml0gdGFyZ2V0L2lzY3NpOiBDb252ZXJ0IHRpbWVycw0KPiA+IHRvIHVzZSB0aW1lcl9z
ZXR1cCgpLg0KPiANCj4gSXMgdGhhdCB3aXRoIHlvdXIgcmViYXNlZCBwYXRjaCBmcm9tIGEgZmV3
IGRheXMgYWdvPw0KDQpIZWxsbyBNYXJ0aW4sDQoNClRoZSB0cmVlIEkgdGVzdGVkIGluZGVlZCBp
bmNsdWRlcyB0aGF0IHJlYmFzZWQgcGF0Y2guIEJUVywgc2luY2UgdGhlIGNvZGUNCnRvdWNoZWQg
YnkgdGhhdCBwYXRjaCBoYXMgbm90IGJlZW4gbW9kaWZpZWQgaW4gdGhlIHBhc3QgbW9udGhzLCB0
aGUgcmViYXNlZA0KcGF0Y2ggaXMgaWRlbnRpY2FsIHRvIHRoZSBwYXRjaCBJIHBvc3RlZCBpbiBN
YXkgMjAxNy4NCg0KQmFydC4=
