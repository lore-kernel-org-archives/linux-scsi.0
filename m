From: <Kento.A.Kobayashi@sony.com>
Subject: RE: [PATCH] usb: uas: fix usb subsystem hang after power off hub
 port
Date: Fri, 15 Mar 2019 02:28:13 +0000
Message-ID: <AE5419EAB4965843B3C0C1FE29F1FFE5873FFB@JPYOKXMS103.jp.sony.com>
References: <AE5419EAB4965843B3C0C1FE29F1FFE5872241@JPYOKXMS103.jp.sony.com>
         <1552063928.29776.2.camel@suse.com>
         <AE5419EAB4965843B3C0C1FE29F1FFE587268B@JPYOKXMS103.jp.sony.com>
 <1552405047.21557.7.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1552405047.21557.7.camel@suse.com>
Content-Language: ja-JP
Sender: linux-kernel-owner@vger.kernel.org
To: oneukum@suse.com, gregkh@linuxfoundation.org, stern@rowland.harvard.edu
Cc: usb-storage@lists.one-eyed-alien.net, Jacky.Cao@sony.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

SGksDQoNCj4+IEFuZCB0aGUgcmV0dXJuIHZhbHVlKC1FTk9ERVYpIHdpbGwgYmUgcmV0dXJuZWQg
dG8gZXJyb3IgaGFuZGxlci4NCj4+IHVhc19laF9kZXZpY2VfcmVzZXRfaGFuZGxlci0+dXNiX3Jl
c2V0X2RldmljZSAtPiB1c2JfcmVzZXRfYW5kX3ZlcmlmeV9kZXZpY2UgKHJldHVybiAtRU5PREVW
KSBUaGVuIEkgd3JvdGUgdGhhdCBjb21taXQgbWVzc2FnZSB0aGF0IHdlIHRoaW5rIGV2ZW4gaWYg
d2UgaWdub3JlICJFTk9ERVYiIGluIHBvc3QgcmVzZXQgdG8gYXZvaWQgaGFuZyBpc3N1ZSBidXQg
dGhlIGVycm9yIHdpbGwgYWxzbyBiZSByZXBvcnRlZCB0byBlcnJvciBoYW5kbGVyLg0KPj4gI0lm
IGlnbm9yZSBhbiBlcnJvciBhbmQgdGhlIGVycm9yIHdpbGwgbm90IGJlIHJlcG9ydGVkIHRoZW4g
aXQgaXMgbm90IGdvb2QuDQo+DQo+V2VsbCwgd2hhdCBkbyB3ZSBkbyBub3c/IEFyZSB5b3Ugc2F5
aW5nIHRoYXQgdGhlIHN0YXRlIG1vZGVsIFNDU0kgaXMgdXNpbmcgaXMgd3Jvbmc/DQoNCk5vLCBp
dCBpcyBub3Qgd3JvbmcuDQpCdXQgSSB0aGluayB3ZSBtYXkgd2FudCB0byBwcmV2ZW5kIGhhbmcg
Ynkgc2xlZXAgcGVvY2VzcyB3aXRoIGNvbnRpbnVpbmcgdG8gdGFrZSBhIGxvY2sgYXQgYmxrX2V4
ZWN1dGVfcnEoKSBmcm9tIHVzYl91bmJpbmRfYW5kX3JlYmluZF9tYXJkZWRfaW50ZXJmYWNlcygp
Lg0KDQpSZWdhcmRzLA0KS2VudG8gS29iYXlhc2hpDQo=
