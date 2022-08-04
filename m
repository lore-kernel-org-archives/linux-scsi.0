Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C6B7C19F29
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Aug 2022 01:50:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238944AbiHDBu5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 21:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbiHDBu4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 21:50:56 -0400
Received: from invmail3.skhynix.com (exvmail3.hynix.com [166.125.252.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B29FDD107
        for <linux-scsi@vger.kernel.org>; Wed,  3 Aug 2022 18:50:53 -0700 (PDT)
X-AuditID: a67dfc59-507ff7000000959d-d9-62eb25f6d0ee
Received: from hymail21.hynixad.com (10.156.135.51) by hymail19.hynixad.com
 (10.156.135.49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.986.15; Thu, 4 Aug 2022
 10:50:45 +0900
Received: from hymail21.hynixad.com ([10.156.135.51]) by hymail21.hynixad.com
 ([10.156.135.51]) with mapi id 15.02.0986.015; Thu, 4 Aug 2022 10:50:45 +0900
From:   =?utf-8?B?7KCV7JqU7ZWcKEpPVU5HIFlPSEFOKSBNb2JpbGUgU0U=?= 
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
Thread-Index: AQHYoUKOvUbRZtx3z0GI27+IE7yewa2cTOUQgACEW4CAATMjMA==
Date:   Thu, 4 Aug 2022 01:50:45 +0000
Message-ID: <d8945bdf320240b2bdf6ee411eff6c8a@sk.com>
References: <20220726225232.1362251-1-bvanassche@acm.org>
 <55fce3baaabf4e33aeaccbe5b4e1f145@sk.com>
 <6263c2a5-e7b6-c9e5-69e8-b6d93604d82d@acm.org>
In-Reply-To: <6263c2a5-e7b6-c9e5-69e8-b6d93604d82d@acm.org>
Accept-Language: ko-KR, en-US
Content-Language: ko-KR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.152.36.223]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJLMWRmVeSWpSXmKPExsXCNUdUSfen6uskg+OTjSy6r+9gc2D0+LxJ
        LoAxissmJTUnsyy1SN8ugSvjxEKrgg/cFVu+xjcwnuDuYuTkkBAwkbg37wRzFyMXh5DAK0aJ
        SZ9vQzlzGSWafu5nBKliEwiVuHF7JZgtIhAn0TrrFSNIEbPAFSaJSR//soMkhAU8JNZ9ngGU
        4AAq8pS4PyUEot5J4s2WC2AlLAIqEmt//2AFsXkFTCXm3pzFBLFsGqPEtWOdYAs4Bawlfm38
        ywoyh1FAVuLqNRmQMLOAuMTir9eYIa4WkFiy5zyULSrx8vE/VghbUeL3n61grcwCmhLrd+lD
        tCpKTOl+yA6xVlDi5MwnLBDlkhIHV9xgmcAoNgvJhlkI3bOQdM9C0r2AkWUVo0hmXlluYmaO
        sV5xdkZlXmaFXnJ+7iZGYIQsq/0TuYPx24XgQ4wCHIxKPLwZba+ShFgTy4orcw8xSnAwK4nw
        3nF5niTEm5JYWZValB9fVJqTWnyIUZqDRUmc91tYaoKQQHpiSWp2ampBahFMlomDU6qB0dzX
        1+jz9ndvHqmr1m1LYTCwbZjW5KjH8jT/1gVp7k+3Z9dsjjOae8BUu0hb1Slw4pLS0xq9zXHS
        Kp07Th9h+713wdnKgFMnY864c/offHE2svJvw9pij9hYuUbPgGlKGppvtnGu+ycwPTPwRmdx
        +72cH4tqI7/sTlw32zjt994VTRfis7kSlViKMxINtZiLihMBGbqwTIwCAAA=
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiBPbiA4LzIvMjIgMTY6NDAsIHlvaGFuLmpvdW5nQHNrLmNvbSB3cm90ZToNCj4gPiBJcyBpdCBw
b3NzaWJsZSBieSBhZGRpbmcgb25seSBtYXhfc2VjdG9yIHRvIGluY3JlYXNlIHRoZSBkYXRhIGJ1
ZmZlciBzaXplPw0KPiANCj4gWWVzLg0KPiANCj4gPiBJIHRoaW5rIHRoZSBkYXRhIGJ1ZmZlciB3
aWxsIHNwbGl0IHRvIDUxMiBLaUIsIGJlY2F1c2UgdGhlIHNnX3RhYmxlDQo+ID4gc2l6ZSBpcyBT
R19BTEwNCj4gDQo+IEkgZG9uJ3QgdGhpbmsgc28uIFdpdGggdGhpcyBwYXRjaCBhcHBsaWVkLCB0
aGUgbGltaXRzIHN1cHBvcnRlZCBieSB0aGUgVUZTDQo+IGRyaXZlciBhcmUgYXMgZm9sbG93czoN
Cj4gDQo+IAkuc2dfdGFibGVzaXplCQk9IFNHX0FMTCwgICAgICAgICAgICAgICAgICAgLyogMTI4
ICovDQo+ICAgCS5tYXhfc2VnbWVudF9zaXplCT0gUFJEVF9EQVRBX0JZVEVfQ09VTlRfTUFYLCAv
KiAyNTYgS2lCKi8NCj4gCS5tYXhfc2VjdG9ycwkJPSAoMSA8PCAyMCkgLyBTRUNUT1JfU0laRSwg
IC8qIDEgTWlCICovDQo+IA0KPiBTbyB0aGUgbWF4aW11bSBkYXRhIGJ1ZmZlciBzaXplIGlzIG1p
bihtYXhfc2VjdG9ycyAqIDUxMiwgc2dfdGFibGVzaXplICoNCj4gbWF4X3NlZ21lbnRfc2l6ZSkg
PSBtaW4oMSBNaUIsIDEyOCAqIDI1NiBLaUIpID0gMSBNaUIuIE9uIGEgc3lzdGVtIHdpdGgNCj4g
NCBLaUIgcGFnZXMsIHRoZSBkYXRhIGJ1ZmZlciBzaXplIHdpbGwgYmUgMTI4ICogNCBLaUIgPSA1
MTIgTWlCIGlmIG5vbmUgb2YNCj4gdGhlIHBhZ2VzIGludm9sdmVkIGluIHRoZSBJL08gYXJlIGNv
bnRpZ3VvdXMuDQpJbiBibG9jayBsYXllciwgbWF4X3NlZ21lbnRfc2l6ZSBpcyBvYnRhaW5lZCBm
cm9tIGdldF9tYXhfc2VnbWVudF9zaXplLg0Kc2VnX2JvdW5kYXJ5X21hc2sgaXMgc2V0IHRvIFBB
R0VfU0laRSAtIDEgaW4gdGhlIHVmcyBkcml2ZXIuDQpUaGUgc2VnbWVudCBzaXplIGlzIHRoZSBQ
QUdFIHNpemUsIGFuZCB0aGUgbWF4IGJ1ZmZlciBzaXplIGlzDQpzZWdtZW50IHNpemUgKiBtYXgg
c2VnbWVudCBjb3VudCAoIFBBR0UgU0laRSAqIDEyOCApID0gNTEyIEtpQiAgaW4gYmxvY2sgbGF5
ZXINClJpZ2h0PyANCj4NCj4gQmFydC4NCg==
