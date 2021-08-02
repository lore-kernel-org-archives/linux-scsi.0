Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 892A6C432BE
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Aug 2021 08:11:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BFA4610A7
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Aug 2021 08:11:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232742AbhHBIL5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Aug 2021 04:11:57 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:56256 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232713AbhHBIL4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Aug 2021 04:11:56 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-160-iK0gGvUAPBS2DPHDQWYVNA-1; Mon, 02 Aug 2021 09:11:45 +0100
X-MC-Unique: iK0gGvUAPBS2DPHDQWYVNA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.23; Mon, 2 Aug 2021 09:11:42 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.023; Mon, 2 Aug 2021 09:11:42 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Colin King' <colin.king@canonical.com>,
        Khalid Aziz <khalid@gonehiking.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] scsi: BusLogic: use %X for u32 sized integer rather than
 %lX
Thread-Topic: [PATCH] scsi: BusLogic: use %X for u32 sized integer rather than
 %lX
Thread-Index: AQHXhShtHO1PT2Lr+0KEAD6jWXCNLqtf4VtQ
Date:   Mon, 2 Aug 2021 08:11:42 +0000
Message-ID: <09bbe958ea12459f98f4fd62ac9a8823@AcuMS.aculab.com>
References: <20210730095031.26981-1-colin.king@canonical.com>
In-Reply-To: <20210730095031.26981-1-colin.king@canonical.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

RnJvbTogQ29saW4gS2luZw0KPiBTZW50OiAzMCBKdWx5IDIwMjEgMTA6NTENCj4gDQo+IEZyb206
IENvbGluIElhbiBLaW5nIDxjb2xpbi5raW5nQGNhbm9uaWNhbC5jb20+DQo+IA0KPiBBbiBlYXJs
aWVyIGZpeCBjaGFuZ2VkIHRoZSBwcmludCBmb3JtYXQgc3BlY2lmaWVyIGZvciBhZGFwdGVyLT5i
aW9zX2FkZHINCj4gdG8gdXNlICVsWCBob3dldmVyIHRoZSBpbnRlZ2VyIGlzIGEgdTMyIHNvIHRo
ZSBmaXggd2FzIHdyb25nLiBGaXggdGhpcw0KPiBieSB1c2luZyB0aGUgY29ycmVjdCAlWCBmb3Jt
YXQgc3BlY2lmaWVyLg0KDQpJcyB0aGF0IHJpZ2h0Pw0KSSBiZXQgb25lIDMyYml0IGFyY2ggZGVm
aW5lcyB1MzIgYXMgbG9uZy4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtl
c2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBV
Sw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

