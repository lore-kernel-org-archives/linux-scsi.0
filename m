Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42426C19F2C
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Aug 2022 23:56:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235181AbiHBX4Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Aug 2022 19:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236205AbiHBX4J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Aug 2022 19:56:09 -0400
X-Greylist: delayed 901 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 02 Aug 2022 16:55:50 PDT
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E6273DFBA
        for <linux-scsi@vger.kernel.org>; Tue,  2 Aug 2022 16:55:49 -0700 (PDT)
X-AuditID: a67dfc5b-1a5ff7000001a3fa-92-62e9b5fd7b78
Received: from hymail21.hynixad.com (10.156.135.51) by hymail20.hynixad.com
 (10.156.135.50) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.986.15; Wed, 3 Aug 2022
 08:40:45 +0900
Received: from hymail21.hynixad.com ([10.156.135.51]) by hymail21.hynixad.com
 ([10.156.135.51]) with mapi id 15.02.0986.015; Wed, 3 Aug 2022 08:40:45 +0900
From:   =?ks_c_5601-1987?B?waS/5MfRKEpPVU5HIFlPSEFOKSBNb2JpbGUgU0U=?= 
        <yohan.joung@sk.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Avri Altman" <avri.altman@wdc.com>, Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: RE: [PATCH v3] scsi: ufs: Increase the maximum data buffer size
Thread-Topic: [PATCH v3] scsi: ufs: Increase the maximum data buffer size
Thread-Index: AQHYoUKOvUbRZtx3z0GI27+IE7yewa2cTOUQ
Date:   Tue, 2 Aug 2022 23:40:45 +0000
Message-ID: <55fce3baaabf4e33aeaccbe5b4e1f145@sk.com>
References: <20220726225232.1362251-1-bvanassche@acm.org>
In-Reply-To: <20220726225232.1362251-1-bvanassche@acm.org>
Accept-Language: ko-KR, en-US
Content-Language: ko-KR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.152.36.223]
Content-Type: text/plain; charset="ks_c_5601-1987"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFLMWRmVeSWpSXmKPExsXCNUdUWffv1pdJBlceG1l0X9/B5sDo8XmT
        XABjFJdNSmpOZllqkb5dAlfG/0nLGAvWSVecvXSKrYHxilQXIyeHhICJxOtzN5i6GLk4hARe
        MUrs6bzCCOHMZZTY+/k8M0gVm0CUxOPWFewgtohAnETrrFdgRcwCV5gkJn38C5YQFvCQWPd5
        BlCCA6jIU+L+lBCIeiOJt02fwOawCKhI/Dq9jAnE5hUwldhycCtYXEjAUuLC2s9gcU4BK4lL
        f9pZQcYwCshKXL0mAxJmFhCXWPz1GjPE0QISS/ach7JFJV4+/scKYStK/P6zlRWi3khiyer5
        TBC2osSU7ofsEGsFJU7OfMICUS8pcXDFDZYJjGKzkKyYhaR9FpL2WUjaFzCyrGIUyswry03M
        zDHRy6jMy6zQS87P3cQIjJFltX+idzB+uhB8iFGAg1GJh/eD9cskIdbEsuLK3EOMEhzMSiK8
        d1yeJwnxpiRWVqUW5ccXleakFh9ilOZgURLn/RaWmiAkkJ5YkpqdmlqQWgSTZeLglGpg7Bb1
        mr7HPFxXaVGTwrbJ8f4ia0/zvhO2fdl1Jj3fc1LA15u/5qz9/qx1P3tp/MuXGy8t9Nn589Ok
        4jtfj6Yr93yfvUQnksF39YwPEgySnctu9SVz+qgbd68TcFox4X6TboRxzLvpi/WXPT9aso+x
        xyk0+U5p/aXgJ2HLds++b5L9pe2hYuk6cSWW4oxEQy3mouJEAHt1ggeNAgAA
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgYmFydA0KDQpJcyBpdCBwb3NzaWJsZSBieSBhZGRpbmcgb25seSBtYXhfc2VjdG9yIHRvIGlu
Y3JlYXNlIHRoZSBkYXRhIGJ1ZmZlciBzaXplPw0KSSB0aGluayB0aGUgZGF0YSBidWZmZXIgd2ls
bCBzcGxpdCB0byA1MTIgS2lCLCBiZWNhdXNlIHRoZSBzZ190YWJsZSBzaXplIGlzIFNHX0FMTA0K
DQpUaGFua3MsDQp5b2hhbg0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206
IEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPg0KPiBTZW50OiBXZWRuZXNkYXks
IEp1bHkgMjcsIDIwMjIgNzo1MiBBTQ0KPiBUbzogTWFydGluIEsgLiBQZXRlcnNlbiA8bWFydGlu
LnBldGVyc2VuQG9yYWNsZS5jb20+DQo+IENjOiBKYWVnZXVrIEtpbSA8amFlZ2V1a0BrZXJuZWwu
b3JnPjsgbGludXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmc7IEFkcmlhbg0KPiBIdW50ZXIgPGFkcmlh
bi5odW50ZXJAaW50ZWwuY29tPjsgQmFydCBWYW4gQXNzY2hlIDxidmFuYXNzY2hlQGFjbS5vcmc+
Ow0KPiBBdnJpIEFsdG1hbiA8YXZyaS5hbHRtYW5Ad2RjLmNvbT47IEJlYW4gSHVvIDxiZWFuaHVv
QG1pY3Jvbi5jb20+OyBTdGFubGV5DQo+IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPjsg
SmFtZXMgRS5KLiBCb3R0b21sZXkgPGplamJAbGludXguaWJtLmNvbT47DQo+IE1hdHRoaWFzIEJy
dWdnZXIgPG1hdHRoaWFzLmJnZ0BnbWFpbC5jb20+DQo+IFN1YmplY3Q6IFtQQVRDSCB2M10gc2Nz
aTogdWZzOiBJbmNyZWFzZSB0aGUgbWF4aW11bSBkYXRhIGJ1ZmZlciBzaXplDQo+IA0KPiBNZWFz
dXJlbWVudHMgZm9yIG9uZSBwYXJ0aWN1bGFyIFVGUyBjb250cm9sbGVyICsgVUZTIGRldmljZSBz
aG93IGEgMjUlDQo+IGhpZ2hlciByZWFkIGJhbmR3aWR0aCBpZiB0aGUgbWF4aW11bSBkYXRhIGJ1
ZmZlciBzaXplIGlzIGluY3JlYXNlZCBmcm9tDQo+IDUxMiBLaUIgdG8gMSBNaUIuIEhlbmNlIGlu
Y3JlYXNlIHRoZSBtYXhpbXVtIHNpemUgb2YgdGhlIGRhdGEgYnVmZmVyDQo+IGFzc29jaWF0ZWQg
d2l0aCBhIHNpbmdsZSByZXF1ZXN0IGZyb20gU0NTSV9ERUZBVUxUX01BWF9TRUNUT1JTICgxMDI0
KQ0KPiAqIDUxMiBieXRlcyA9IDUxMiBLaUIgdG8gMSBNaUIuDQo+IA0KPiBOb3RlczoNCj4gLSBU
aGUgbWF4aW11bSBkYXRhIGJ1ZmZlciBzaXplIHN1cHBvcnRlZCBieSB0aGUgVUZTSENJIHNwZWNp
ZmljYXRpb24NCj4gICBpcyA2NTUzNSAqIDI1NiBLaUIgb3IgYWJvdXQgMTYgR2lCLg0KPiAtIFRo
ZSBtYXhpbXVtIGRhdGEgYnVmZmVyIHNpemUgZm9yIFJFQUQoMTApIGNvbW1hbmRzIGlzIDY1NTM1
IGxvZ2ljYWwNCj4gICBibG9ja3MuIFRvIHRyYW5zZmVyIG1vcmUgdGhhbiA2NTUzNSAqIDQwOTYg
Ynl0ZXMgPSAyNTUgTWlCIHdpdGggYQ0KPiAgIHNpbmdsZSBTQ1NJIGNvbW1hbmQsIHRoZSBSRUFE
KDE2KSBjb21tYW5kIGlzIHJlcXVpcmVkLiBTdXBwb3J0IGZvcg0KPiAgIFJFQUQoMTYpIGlzIG9w
dGlvbmFsIGluIHRoZSBVRlMgMy4xIGFuZCBVRlMgNC4wIHN0YW5kYXJkcy4NCj4gDQo+IENjOiBB
ZHJpYW4gSHVudGVyIDxhZHJpYW4uaHVudGVyQGludGVsLmNvbT4NCj4gQ2M6IEF2cmkgQWx0bWFu
IDxhdnJpLmFsdG1hbkB3ZGMuY29tPg0KPiBDYzogQmVhbiBIdW8gPGJlYW5odW9AbWljcm9uLmNv
bT4NCj4gQ2M6IFN0YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5jb20+DQo+IFNpZ25l
ZC1vZmYtYnk6IEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPg0KPiAtLS0NCj4g
Q2hhbmdlcyBjb21wYXJlZCB0byB2MjogY2hhbmdlZCBtYXhpbXVtIHRyYW5zZmVyIHNpemUgMjU1
IE1pQiB0byAxIE1pQi4NCj4gQ2hhbmdlcyBjb21wYXJlZCB0byB2MTogY2hhbmdlZCBtYXhpbXVt
IHRyYW5zZmVyIHNpemUgZnJvbSAxIEdpQiB0byAyNTUgTWlCLg0KPiANCj4gIGRyaXZlcnMvdWZz
L2NvcmUvdWZzaGNkLmMgfCAxICsNCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKQ0K
PiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMgYi9kcml2ZXJzL3Vm
cy9jb3JlL3Vmc2hjZC5jIGluZGV4DQo+IDM2YjcyMTJlOWNiNS4uNjc4YmM4ZDZkNmFhIDEwMDY0
NA0KPiAtLS0gYS9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jDQo+ICsrKyBiL2RyaXZlcnMvdWZz
L2NvcmUvdWZzaGNkLmMNCj4gQEAgLTgzNjUsNiArODM2NSw3IEBAIHN0YXRpYyBzdHJ1Y3Qgc2Nz
aV9ob3N0X3RlbXBsYXRlDQo+IHVmc2hjZF9kcml2ZXJfdGVtcGxhdGUgPSB7DQo+ICAJLmNtZF9w
ZXJfbHVuCQk9IFVGU0hDRF9DTURfUEVSX0xVTiwNCj4gIAkuY2FuX3F1ZXVlCQk9IFVGU0hDRF9D
QU5fUVVFVUUsDQo+ICAJLm1heF9zZWdtZW50X3NpemUJPSBQUkRUX0RBVEFfQllURV9DT1VOVF9N
QVgsDQo+ICsJLm1heF9zZWN0b3JzCQk9ICgxIDw8IDIwKSAvIFNFQ1RPUl9TSVpFLCAvKiAxIE1p
QiAqLw0KPiAgCS5tYXhfaG9zdF9ibG9ja2VkCT0gMSwNCj4gIAkudHJhY2tfcXVldWVfZGVwdGgJ
PSAxLA0KPiAgCS5zZGV2X2dyb3VwcwkJPSB1ZnNoY2RfZHJpdmVyX2dyb3VwcywNCg==
