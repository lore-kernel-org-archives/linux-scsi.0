From: <Kento.A.Kobayashi@sony.com>
Subject: RE: [PATCH] usb: uas: fix usb subsystem hang after power off hub
 port
Date: Mon, 25 Mar 2019 10:21:45 +0000
Message-ID: <AE5419EAB4965843B3C0C1FE29F1FFE588EA40@JPYOKXMS103.jp.sony.com>
References: <AE5419EAB4965843B3C0C1FE29F1FFE5872241@JPYOKXMS103.jp.sony.com>
         <1552063928.29776.2.camel@suse.com>
         <AE5419EAB4965843B3C0C1FE29F1FFE587268B@JPYOKXMS103.jp.sony.com>
 <1552405047.21557.7.camel@suse.com>
 <AE5419EAB4965843B3C0C1FE29F1FFE5873FFB@JPYOKXMS103.jp.sony.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AE5419EAB4965843B3C0C1FE29F1FFE5873FFB@JPYOKXMS103.jp.sony.com>
Content-Language: ja-JP
Sender: linux-kernel-owner@vger.kernel.org
To: oneukum@suse.com, gregkh@linuxfoundation.org, stern@rowland.harvard.edu
Cc: usb-storage@lists.one-eyed-alien.net, Jacky.Cao@sony.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

SGksDQoNCj4+PiBBbmQgdGhlIHJldHVybiB2YWx1ZSgtRU5PREVWKSB3aWxsIGJlIHJldHVybmVk
IHRvIGVycm9yIGhhbmRsZXIuDQo+Pj4gdWFzX2VoX2RldmljZV9yZXNldF9oYW5kbGVyLT51c2Jf
cmVzZXRfZGV2aWNlIC0+IHVzYl9yZXNldF9hbmRfdmVyaWZ5X2RldmljZSAocmV0dXJuIC1FTk9E
RVYpIFRoZW4gSSB3cm90ZSB0aGF0IGNvbW1pdCBtZXNzYWdlIHRoYXQgd2UgdGhpbmsgZXZlbiBp
ZiB3ZSBpZ25vcmUgIkVOT0RFViIgaW4gcG9zdCByZXNldCB0byBhdm9pZCBoYW5nIGlzc3VlIGJ1
dCB0aGUgZXJyb3Igd2lsbCBhbHNvIGJlIHJlcG9ydGVkIHRvIGVycm9yIGhhbmRsZXIuDQo+Pj4g
I0lmIGlnbm9yZSBhbiBlcnJvciBhbmQgdGhlIGVycm9yIHdpbGwgbm90IGJlIHJlcG9ydGVkIHRo
ZW4gaXQgaXMgbm90IGdvb2QuDQo+Pg0KPj5XZWxsLCB3aGF0IGRvIHdlIGRvIG5vdz8gQXJlIHlv
dSBzYXlpbmcgdGhhdCB0aGUgc3RhdGUgbW9kZWwgU0NTSSBpcyB1c2luZyBpcyB3cm9uZz8NCg0K
Pk5vLCBpdCBpcyBub3Qgd3JvbmcuDQo+QnV0IEkgdGhpbmsgd2UgbWF5IHdhbnQgdG8gcHJldmVu
ZCBoYW5nIGJ5IHNsZWVwIHBlb2Nlc3Mgd2l0aCBjb250aW51aW5nIHRvIHRha2UgYSBsb2NrIGF0
IGJsa19leGVjdXRlX3JxKCkgZnJvbSA+dXNiX3VuYmluZF9hbmRfcmViaW5kX21hcmRlZF9pbnRl
cmZhY2VzKCkuDQoNCkNvdWxkIHlvdSBwbGVhc2UgeW91IGNhbiBhcHBseSB0aGlzIHBhdGNoIGZv
ciBtYWlubGluZSBvciBub3Q/DQpJZiBub3QsIGNvdWxkIHlvdSBwbGVhc2UgdGVsbCBtZSB3aHkg
eW91IGNhbid0IGFsbG93IHRvIGFwcGx5IHRoaXMgcGF0Y2g/DQoNClJlZ2FyZHMsDQpLZW50byBL
b2JheWFzaGkNCg==
