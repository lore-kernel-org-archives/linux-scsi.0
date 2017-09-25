From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH V5 07/14] scsi: sd_zbc: Initialize device request queue
 zoned data
Date: Mon, 25 Sep 2017 21:17:22 +0000
Message-ID: <1506374241.2641.20.camel@wdc.com>
References: <20170925061454.5533-1-damien.lemoal@wdc.com>
         <20170925061454.5533-8-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:62170 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932182AbdIYVRZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Sep 2017 17:17:25 -0400
In-Reply-To: <20170925061454.5533-8-damien.lemoal@wdc.com>
Content-Language: en-US
Content-ID: <9961A106ACE57D438C19E6F7117C5192@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "hch@lst.de" <hch@lst.de>

T24gTW9uLCAyMDE3LTA5LTI1IGF0IDE1OjE0ICswOTAwLCBEYW1pZW4gTGUgTW9hbCB3cm90ZToN
Cj4gKwlyZXR1cm4ga3phbGxvY19ub2RlKEJJVFNfVE9fTE9OR1Moc2RrcC0+bnJfem9uZXMpDQo+
ICsJCQkgICAgKiBzaXplb2YodW5zaWduZWQgbG9uZyksDQoNCkRvZXMgdGhpcyBwZXJoYXBzIGZp
dCBvbiBvbmUgbGluZT8NCg0KPiArLyoqDQo+ICsgKiBzZF96YmNfZ2V0X3NlcV96b25lcyAtIFBh
cnNlIHJlcG9ydCB6b25lcyByZXBseSB0byBpZGVudGlmeSBzZXF1ZW50aWFsIHpvbmVzDQo+ICsg
KiBAc2RrcDogZGlzayB1c2VkDQo+ICsgKiBAYnVmOiByZXBvcnQgcmVwbHkgYnVmZmVyDQo+ICsg
KiBAc2VxX3pvbmVfYml0YW1wOiBiaXRtYXAgb2Ygc2VxdWVudGlhbCB6b25lcyB0byBzZXQNCj4g
KyAqIEB6bm86IFpvbmUgbnVtYmVyIG9mIHRoZSBmaXJzdCB6b25lIGluIHRoZSByZXBvcnQNCg0K
J3pubycgaXMgYW4gaW5wdXQgYW5kIG91dHB1dCBwYXJhbWV0ZXIgYnV0IHRoZSBhYm92ZSBsaW5l
IG9ubHkgZGVzY3JpYmVzIHdoYXQNCmhhcHBlbnMgd2l0aCB0aGUgdmFsdWUgcGFzc2VkIHRvIHNk
X3piY19nZXRfc2VxX3pvbmVzKCkuIEkgdGhpbmsgd2UgYWxzbyBuZWVkIGENCmRlc2NyaXB0aW9u
IGZvciB0aGUgdmFsdWUgb2YgJ3pubycgdXBvbiByZXR1cm4uDQoNCj4gKyAqIFBhcnNlIHJlcG9y
dGVkIHpvbmUgZGVzY3JpcHRvcnMgdG8gZmluZCBzZXF1aWVudGlhbCB6b25lcy4NCiAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBeXl5eXl5eXl5eXg0KICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHNlcXVlbnRpYWw/DQoNCk90
aGVyd2lzZSB0aGlzIHBhdGNoIGxvb2tzIGZpbmUgdG8gbWUuDQoNCkJhcnQu
