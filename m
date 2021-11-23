Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 197D9C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Nov 2021 05:20:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231974AbhKWFXN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Nov 2021 00:23:13 -0500
Received: from exvmail.hynix.com ([166.125.252.79]:47335 "EHLO
        invmail.skhynix.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S232386AbhKWFXN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Nov 2021 00:23:13 -0500
X-AuditID: a67dfc4e-31dff7000000da67-72-619c7a0068b5
Received: from hymail21.hynixad.com (10.156.135.51) by hymail08.hynixad.com
 (10.156.135.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.986.5; Tue, 23 Nov 2021
 14:19:59 +0900
Received: from hymail21.hynixad.com ([10.156.135.51]) by hymail21.hynixad.com
 ([10.156.135.51]) with mapi id 15.02.0986.005; Tue, 23 Nov 2021 14:19:59
 +0900
From:   =?utf-8?B?7KCV7JqU7ZWcKEpPVU5HIFlPSEFOKSBNb2JpbGUgU0U=?= 
        <yohan.joung@sk.com>
To:     Bean Huo <huobean@gmail.com>,
        "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        =?utf-8?B?7LWc7J6s7JiBKENIT0kgSkFFIFlPVU5HKSBNb2JpbGUgU0U=?= 
        <jaeyoung21.choi@sk.com>,
        =?utf-8?B?6rO97YOc7IiYKEtXQUsgVEFFU1UpIE1vYmlsZSBTRQ==?= 
        <taesu.kwak@sk.com>
Subject: RE: Please check ufshpb init flow
Thread-Topic: Please check ufshpb init flow
Thread-Index: Adfc6j2tFkh4yQNUQbaUsbtOylGK5f//7QEA//tP0CA=
Date:   Tue, 23 Nov 2021 05:19:59 +0000
Message-ID: <4d2331ea33a246c78fcabaf1ca4e0b10@sk.com>
References: <e092e35414844175bf76868b820d907f@sk.com>
 <b06d9a87232a6d4e90fe635384a83c48586652e9.camel@gmail.com>
In-Reply-To: <b06d9a87232a6d4e90fe635384a83c48586652e9.camel@gmail.com>
Accept-Language: ko-KR, en-US
Content-Language: ko-KR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.152.36.34]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNLMWRmVeSWpSXmKPExsXCNUdUWZehak6iweG9Ahbd13ewOTB6fN4k
        F8AYxWWTkpqTWZZapG+XwJXxqPUOc8EhsYqP+zaxNTD+EO1i5OSQEDCR2L1sGmsXIxeHkMAr
        Rok7d/+zQTgLGCU+nv/FBlLFJhAqceP2SkaQhIjAXyaJCTsugjnMAi8YJS7efsYKUiUsoCUx
        /+N6FhBbREBb4uulTawQtpXEx53/wWwWAVWJ13P2MoPYvAKmEp3tq5lAbCGBIonHH56zg9ic
        Au4Sk/v2AM3h4GAUkJW4ek0GJMwsIC6x+Os1ZoizBSSW7DkPZYtKvHz8jxXCVpBY+f0CE0gr
        s4CmxPpd+hCtihJTuh+yQ2wVlDg58wkLRLmkxMEVN1gmMIrNQrJhFkL3LCTds5B0L2BkWcUo
        nJlXlpuYmaNXnJ1RmZdZoZecn7uJERgly2r/+O1g/HIh+BCjAAejEg9vwqLZiUKsiWXFlbmH
        GCU4mJVEeK8tAQrxpiRWVqUW5ccXleakFh9ilOZgURLn/RaWmiAkkJ5YkpqdmlqQWgSTZeLg
        lGpg7KupDHreOqluzezD7NP6z1/4a/BjR8vT8Nk7Ju44fCTe4vkiWc11eQ+nXH3Cwy13MudY
        bVG4QsqiosS8Ei3Dzev9PW+rMxVpnzzh2KzI4LFEqqf5C5+vv9UjdiOzWtXkgw3JP4SP3YiY
        8p9774YLr57G2051CjSQ99zKLqxvPCmkPSXi8dnFSizFGYmGWsxFxYkAzoFb+o4CAAA=
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiBpdCdzIGZvciAiSW5hY3RpdmF0aW5nIGFsbCBIUEIgcmVnaW9ucyIgYWZ0ZXIgcmVib290DQo+
IA0KPiBzY3NpX2FkZF9sdW4oKS4uLj51ZnNocGJfaXNzdWVfdW1hcF9hbGxfcmVxKGhwYik7DQo+
IA0KPiBpZiBpdCBpcyBhIGNvbGQgcmVib290IG9uIGJvdGggaG9zdCBzaWRlIGFuZCBVRlMgZGV2
aWNlIHNpZGUsIGl0IGlzIG5vdA0KPiBuZWNlc3NhcnkgdG8gaXNzdWUgdGhpcyB3cml0ZSBidWZm
ZXIuDQpBY2NvcmRpbmcgdG8geW91LCBpcyB1ZnNocGJfaXNzdWVfdW1hcF9hbGxfcmVxIHVzZWQg
b25seSBmb3IgaG9zdCByZXNldD8NCkR1cmluZyBib290dGltZSwgdGhlIHByb2JsZW0gaXMgdGhh
dCB0aGUgaHBiIGlzIHNldCB0byB0aGUgbGFzdCBMVU4sIHdyaXRlIGJ1ZmZlciBjb21tYW5kIGlz
IHNlbnQgYmVmb3JlIHNkX3Byb2JlIGNvbXBsZXRlcy4NCnNvLCBpbnN0ZWFkIG9mIHBlcmZvcm1p
bmcgdW5tYXAsIFVBQyBpcyByZXR1cm5lZC4gDQpJZiB1ZnNocGJfaXNzdWVfdW1hcF9hbGxfcmVx
IGlzIG5vdCBuZWVkZWQgaW4gY29sZCBib290LCBpdCBzZWVtcyBuZWNlc3NhcnkgdG8gbW92ZSBp
dCB0byBhbiBhcHByb3ByaWF0ZSBsb2NhdGlvbiBvciByZW1vdmUNCj4gDQo+IA0KPiBPbiBGcmks
IDIwMjEtMTEtMTkgYXQgMDI6MzEgKzAwMDAsIOygleyalO2VnChKT1VORyBZT0hBTikgTW9iaWxl
IFNFIHdyb3RlOg0KPiA+IEhpIGRhZWp1bg0KPiA+DQo+ID4gUGxlYXNlIGNoZWNrIHVmc2hwYiBp
bml0IGZsb3cuDQo+ID4gc2VuZGluZyB3cml0ZSBidWZmZXIoMHgwMykgc2VlbXMgc3BlYyB2aW9s
YXRpb24gKEpFU0QyMjAgQ29tbWFuZHMgZm9yDQo+ID4gZXhjZXB0aW9uYWwgYmVoYXZpb3Igb24g
VUFDLCBTQU0gNXIwNSkgYmVmb3JlIFVBQyBjbGVhciAoc2RfcHJvYmUpLg0KPiA+IEFueXdheSBo
cGIgcmVzZXQgcXVlcnkodWZzaHBiX2NoZWNrX2hwYl9yZXNldF9xdWVyeSkgc2VlbXMgc3VmZmlj
aWVudC4NCj4gPiBXaHkgZG8gd2UgbmVlZCB0byBzZW5kIHdyaXRlIGJ1ZmZlcj8NCj4gPg0KPiA+
IHZvaWQgdWZzaHBiX2luaXRfaHBiX2x1KHN0cnVjdCB1ZnNfaGJhICpoYmEsIHN0cnVjdCBzY3Np
X2RldmljZQ0KPiA+ICpzZGV2KQ0KPiA+IHsNCj4gPiBvdXQ6DQo+ID4gICAgIC8qIEFsbCBMVXMg
YXJlIGluaXRpYWxpemVkICovDQo+ID4gICAgIGlmIChhdG9taWNfZGVjX2FuZF90ZXN0KCZoYmEt
PnVmc2hwYl9kZXYuc2xhdmVfY29uZl9jbnQpKQ0KPiA+IAlUaGVyZSBzZWVtcyB0byBiZSBhIHBy
b2JsZW0gd2l0aCB0aGlzIGxvZ2ljLg0KPiA+IAlJZiBocGIgaXMgc2V0IG9uIHRoZSBsYXN0IExV
Tiwgd3JpdGUgYnVmZmVyIGNvbW1hbmQgaXMgc2VudCBiZWZvcmUNCj4gPiBzZF9wcm9iZSBjb21w
bGV0ZXMuDQo+ID4gICAgICAgICB1ZnNocGJfaHBiX2x1X3ByZXBhcmVkKGhiYSk7DQo+ID4gfQ0K
PiA+DQo+ID4gc3RhdGljIHZvaWQgdWZzaHBiX2hwYl9sdV9wcmVwYXJlZChzdHJ1Y3QgdWZzX2hi
YSAqaGJhKSB7DQo+ID4NCj4gPiAgICAgaW5pdF9zdWNjZXNzID0gIXVmc2hwYl9jaGVja19ocGJf
cmVzZXRfcXVlcnkoaGJhKTsNCj4gPg0KPiA+ICAgICBzaG9zdF9mb3JfZWFjaF9kZXZpY2Uoc2Rl
diwgaGJhLT5ob3N0KSB7DQo+ID4gICAgICAgICBocGIgPSB1ZnNocGJfZ2V0X2hwYl9kYXRhKHNk
ZXYpOw0KPiA+ICAgICAgICAgaWYgKCFocGIpDQo+ID4gICAgICAgICAgICAgY29udGludWU7DQo+
ID4NCj4gPiAgICAgICAgIGlmIChpbml0X3N1Y2Nlc3MpIHsNCj4gPiAgICAgICAgICAgICB1ZnNo
cGJfc2V0X3N0YXRlKGhwYiwgSFBCX1BSRVNFTlQpOw0KPiA+ICAgICAgICAgICAgIGlmICgoaHBi
LT5sdV9waW5uZWRfZW5kIC0gaHBiLT5sdV9waW5uZWRfc3RhcnQpID4gMCkNCj4gPiAgICAgICAg
ICAgICAgICAgcXVldWVfd29yayh1ZnNocGJfd3EsICZocGItPm1hcF93b3JrKTsNCj4gPiAgICAg
ICAgICAgICBpZiAoIWhwYi0+aXNfaGNtKQ0KPiA+ICAgICAgICAgICAgICAgICB1ZnNocGJfaXNz
dWVfdW1hcF9hbGxfcmVxKGhwYik7DQo+ID4gCQlUaGlzIHNlZW1zIHVubmVjZXNzYXJ5Lg0KPiA+
DQo+ID4gICAgICAgICB9IGVsc2Ugew0KPiA+DQo+ID4gVGhhbmtzDQo+ID4geW9oYW4NCg0K
