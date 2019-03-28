From: <Kento.A.Kobayashi@sony.com>
Subject: RE: [PATCH] usb: uas: fix usb subsystem hang after power off hub
 port
Date: Thu, 28 Mar 2019 07:53:14 +0000
Message-ID: <AE5419EAB4965843B3C0C1FE29F1FFE588FCC9@JPYOKXMS103.jp.sony.com>
References: <AE5419EAB4965843B3C0C1FE29F1FFE5872241@JPYOKXMS103.jp.sony.com>
         <1552063928.29776.2.camel@suse.com>
         <AE5419EAB4965843B3C0C1FE29F1FFE587268B@JPYOKXMS103.jp.sony.com>
         <1552405047.21557.7.camel@suse.com>
         <AE5419EAB4965843B3C0C1FE29F1FFE5873FFB@JPYOKXMS103.jp.sony.com>
         <AE5419EAB4965843B3C0C1FE29F1FFE588EA40@JPYOKXMS103.jp.sony.com>
 <1553510086.2668.2.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1553510086.2668.2.camel@suse.com>
Content-Language: ja-JP
Sender: linux-kernel-owner@vger.kernel.org
To: oneukum@suse.com, gregkh@linuxfoundation.org, stern@rowland.harvard.edu
Cc: usb-storage@lists.one-eyed-alien.net, Jacky.Cao@sony.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, Kento.A.Kobayashi@sony.com
List-Id: linux-scsi@vger.kernel.org

SGksDQoNCj5Tb3JyeSwNCj4NCj5JIHRob3VnaHQgdGhpcyB3YXMgY2xlYXIuIFlvdXIgcGF0Y2gg
aXMgbWFraW5nIHRoZSBhc3N1bXB0aW9uIHRoYXQgdGhlIHJlc2V0IGlzIHRyaWdnZXJlZCBieSB0
aGUgU0NTSSBsYXllci4gWW91IGNhbm5vdCBtYWtlIHRoYXQgYXNzdW1wdGlvbiwgYXMgdGhlcmUg
aXMgYW4gaW9jdGwgZm9yIHJlc2V0dGluZyBhIFVTQiBkZXZpY2UuDQo+SW4gY2FzZSB3ZSBhcmUg
Z2V0dGluZyBhbiBlcnJvciBkdXJpbmcgdGhlIHJlc2V0IChvdXIgZW5kcG9pbnRzIHZhbmlzaCks
IHRoZSBkZXZpY2UgZHJpdmVyIG11c3QgcmVwb3J0IHRoYXQgdG8gdGhlIFVTQiBsYXllciwgc28g
dGhlIGRyaXZlciB3aWxsIGFsd2F5cyBiZSBkaXNjb25uZWN0ZWQuDQo+V2UgY2Fubm90IGRyb3Ag
ZXJyb3JzLg0KPg0KPglSZWdhcmRzDQo+CQlPbGl2ZXINCg0KVGhpcyBwYXRjaCBtb2RpZmllZCB1
YXNfcG9zdF9yZXNldCB0byBza2lwIHJlYmluZCBvcGVyYXRpb24gdG8gYXZvaWQgZXhjZXB0aW9u
IHdoaWxlIC1FTk9ERVYgaGFwcGVucyBub3QgZHJvcCBlcnJvci4NCklmIHVhc19wb3N0X3Jlc2V0
IGhhcHBlbnMgLUVOT0RFViwgdXNiX3Jlc2V0X2FuZF92ZXJpZnlfZGV2aWNlIG11c3QgaGFwcGVu
IGVycm9yLg0KU28sd2hlbiB3ZSB1c2UgaW9jdGwoVVNCREVWRlNfUkVTRVQpIHRvIHJlc2V0IGRl
dmljZSwgaWYgdXNiX3Jlc2V0X2FuZF92ZXJpZnlfZGV2aWNlIGhhcHBlbnMgZXJyb3IsIHRoZSBl
cnJvciB3aWxsIGJlIHJlcG9ydGVkIHRocm91Z2ggaW9jdGwgcmV0dXJuIHZhbHVlLiANCg0KUmVn
YXJkcywNCktlbnRvIEtvYmF5YXNoaQ0K
