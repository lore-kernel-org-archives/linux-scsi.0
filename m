From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH] In the ioaccel path, the calculation of the starting
Date: Fri, 16 Sep 2016 20:01:16 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D193B054B2E@avsrvexchmbx1.microsemi.net>
References: <147405576722.22073.13600876343999401194.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0068.outbound.protection.outlook.com ([104.47.37.68]:10811
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S965229AbcIPUR2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 16 Sep 2016 16:17:28 -0400
In-Reply-To: <147405576722.22073.13600876343999401194.stgit@brunhilda>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "hch@infradead.org" <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBsaW51eC1zY3NpLW93bmVyQHZn
ZXIua2VybmVsLm9yZyBbbWFpbHRvOmxpbnV4LXNjc2ktDQo+IG93bmVyQHZnZXIua2VybmVsLm9y
Z10gT24gQmVoYWxmIE9mIERvbiBCcmFjZQ0KPiBTZW50OiBGcmlkYXksIFNlcHRlbWJlciAxNiwg
MjAxNiAyOjU2IFBNDQo+IFRvOiBqZWpiQGxpbnV4LnZuZXQuaWJtLmNvbTsgSm9obiBIYWxsOyBL
ZXZpbiBCYXJuZXR0OyBNYWhlc2gNCj4gUmFqYXNoZWtoYXJhOyBoY2hAaW5mcmFkZWFkLm9yZzsg
U2NvdHQgVGVlbDsgVmlzd2FzIEc7IEp1c3RpbiBMaW5kbGV5OyBTY290dA0KPiBCZW5lc2g7IGVs
bGlvdHRAaHBlLmNvbQ0KPiBDYzogbGludXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVj
dDogW1BBVENIXSBJbiB0aGUgaW9hY2NlbCBwYXRoLCB0aGUgY2FsY3VsYXRpb24gb2YgdGhlIHN0
YXJ0aW5nDQo+IA0KPiBFWFRFUk5BTCBFTUFJTA0KPiANCj4gDQo+IEZyb206IGtldmluIEJhcm5l
dHQgPGtldmluLmJhcm5ldHRAbWljcm9zZW1pLmNvbT4NCj4gDQo+IExCQSBmb3IgUkVBRCg2KS9X
UklURSg2KSBTQ1NJIGNvbW1hbmRzIGRvZXMgbm90IHRha2UNCj4gaW50byBhY2NvdW50IHRoZSBt
b3N0IHNpZ25pZmljYW50IDUgYml0cyBvZiB0aGUNCj4gTEJBOiBpdCBvbmx5IHVzZXMgdGhlIGxl
YXN0IHNpZ25pZmljYW50IDE2IGJpdHMgb2YNCj4gdGhlIHN0YXJ0aW5nIExCQS4NCj4gDQo+IFJl
cG9ydGVkLWJ5OiBNYWhlc2ggUmFqYXNoZWtoYXJhDQo+IDxtYWhlc2gucmFqYXNoZWtoYXJhQG1p
Y3Jvc2VtaS5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IEtldmluIEJhcm5ldHQgPGtldmluLmJhcm5l
dHRAbWljcm9zZW1pLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogRG9uIEJyYWNlIDxkb24uYnJhY2VA
bWljcm9zZW1pLmNvbT4NCj4gLS0tDQpTb3JyeSBmb3Jnb3QgdGl0bGUsIHJlc2VuZGluZyBhcyBW
MQ0KDQo+IC0tDQo+IFRvIHVuc3Vic2NyaWJlIGZyb20gdGhpcyBsaXN0OiBzZW5kIHRoZSBsaW5l
ICJ1bnN1YnNjcmliZSBsaW51eC1zY3NpIiBpbg0KPiB0aGUgYm9keSBvZiBhIG1lc3NhZ2UgdG8g
bWFqb3Jkb21vQHZnZXIua2VybmVsLm9yZw0KPiBNb3JlIG1ham9yZG9tbyBpbmZvIGF0ICBodHRw
Oi8vdmdlci5rZXJuZWwub3JnL21ham9yZG9tby1pbmZvLmh0bWwNCg==
