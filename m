From: "=?utf-8?B?6ZmI5Y2O5omN?=" <chenhc@lemote.com>
Subject: Re: [PATCH 2/2] scsi: Align queue to ARCH_DMA_MINALIGN innon-coherent DMA mode
Date: Mon, 11 Sep 2017 16:41:51 +0800
Message-ID: <tencent_164349390B49089A598FAEDB@qq.com>
References: <1504774131-11691-1-git-send-email-chenhc@lemote.com>
        <20170911073906.GA7074@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170911073906.GA7074@infradead.org>
Sender: stable-owner@vger.kernel.org
To: =?utf-8?B?Q2hyaXN0b3BoIEhlbGx3aWc=?= <hch@infradead.org>
Cc: =?utf-8?B?SmFtZXMgRSAuIEogLiBCb3R0b21sZXk=?= <jejb@linux.vnet.ibm.com>, =?utf-8?B?TWFydGluIEsgLiBQZXRlcnNlbg==?= <martin.petersen@oracle.com>, =?utf-8?B?RnV4aW4gWmhhbmc=?= <zhangfx@lemote.com>, =?utf-8?B?bGludXgtc2NzaQ==?= <linux-scsi@vger.kernel.org>, =?utf-8?B?bGludXgta2VybmVs?= <linux-kernel@vger.kernel.org>, =?utf-8?B?c3RhYmxl?= <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

SGksIENocmlzdG9waA0KDQpJIHRoaW5rIHdlIGNhbm5vdCBtb2RpZnkgZG1hX2dldF9jYWNo
ZV9hbGlnbm1lbnQoKSwgYmVjYXVzZSBleGlzdGluZyBjYWxsZXJzIG1heSB3YW50IHRvIHVu
Y29uZGl0aW9uYWxseSByZXR1cm4gQVJDSF9ETUFfTUlOQUxJR04uDQoNCkh1YWNhaQ0KIA0K
IA0KLS0tLS0tLS0tLS0tLS0tLS0tIE9yaWdpbmFsIC0tLS0tLS0tLS0tLS0tLS0tLQ0KRnJv
bTogICJDaHJpc3RvcGggSGVsbHdpZyI8aGNoQGluZnJhZGVhZC5vcmc+Ow0KRGF0ZTogIE1v
biwgU2VwIDExLCAyMDE3IDAzOjM5IFBNDQpUbzogICJIdWFjYWkgQ2hlbiI8Y2hlbmhjQGxl
bW90ZS5jb20+OyANCkNjOiAgIkphbWVzIEUgLiBKIC4gQm90dG9tbGV5IjxqZWpiQGxpbnV4
LnZuZXQuaWJtLmNvbT47ICJNYXJ0aW4gSyAuIFBldGVyc2VuIjxtYXJ0aW4ucGV0ZXJzZW5A
b3JhY2xlLmNvbT47ICJGdXhpbiBaaGFuZyI8emhhbmdmeEBsZW1vdGUuY29tPjsgImxpbnV4
LXNjc2kiPGxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnPjsgImxpbnV4LWtlcm5lbCI8bGlu
dXgta2VybmVsQHZnZXIua2VybmVsLm9yZz47ICJzdGFibGUiPHN0YWJsZUB2Z2VyLmtlcm5l
bC5vcmc+OyANClN1YmplY3Q6ICBSZTogW1BBVENIIDIvMl0gc2NzaTogQWxpZ24gcXVldWUg
dG8gQVJDSF9ETUFfTUlOQUxJR04gaW5ub24tY29oZXJlbnQgRE1BIG1vZGUNCg0KIA0KPiAr
CWlmIChwbGF0X2RldmljZV9pc19jb2hlcmVudChkZXYpKQ0KDQpXZSBjYW4ndCBqdXN0IGNh
bGwgcGxhdGZvcm0gZGV2aWNlIGNvZGUuICBXZSdsbCBuZWVkIGEgcHJvcGVyDQpETUEgQVBJ
IGNhbGwgZm9yIHRoaXMuDQoNCj4gKwkJYmxrX3F1ZXVlX2RtYV9hbGlnbm1lbnQocSwgMHgw
NCAtIDEpOw0KPiArCWVsc2UNCj4gKwkJYmxrX3F1ZXVlX2RtYV9hbGlnbm1lbnQocSwgZG1h
X2dldF9jYWNoZV9hbGlnbm1lbnQoKSAtIDEpOw0KDQpXaGljaCB3ZSBhbHJlYWR5IGhhdmUg
d2l0aCBkbWFfZ2V0X2NhY2hlX2FsaWdubWVudCwgZXhjZXB0IHRoYXQgaXQNCmRvZXNuJ3Qg
dGFrZSBhIHN0cnVjdCBkZXZpY2UgcG9pbnRlciBhbmQgZG9lc24ndCBjYWxsIGludG8gZG1h
X21hcA0Kb3BzLiAgU28gcGxlYXNlIGFkZCBhIHN0cnVjdCBkZXZpY2UgYXJndW1lbnQgdG8g
ZG1hX2dldF9jYWNoZV9hbGlnbm1lbnQsDQphbmQgbGV0IGl0IGNhbGwgaW50byBkbWFfbWFw
X29wcyB3aGVyZSBuZWVkZWQuDQoNCldpdGggdGhhdCB5b3UgY2FuIHJlcGxhY2UgdGhlIGFi
b3ZlIHdpdGg6DQoNCglibGtfcXVldWVfZG1hX2FsaWdubWVudChxLA0KCQkJbWF4KDB4MDRV
LCBkbWFfZ2V0X2NhY2hlX2FsaWdubWVudChkZXYpKSAtIDEpOw==
