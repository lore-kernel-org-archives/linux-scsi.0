Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A537C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 01:49:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2255064EBC
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 01:49:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbhBIBs7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Feb 2021 20:48:59 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:2830 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbhBIBs7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Feb 2021 20:48:59 -0500
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4DZQhn4XsVz13rxP;
        Tue,  9 Feb 2021 09:46:01 +0800 (CST)
Received: from dggemi711-chm.china.huawei.com (10.3.20.110) by
 DGGEMM405-HUB.china.huawei.com (10.3.20.213) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Tue, 9 Feb 2021 09:48:15 +0800
Received: from dggemi761-chm.china.huawei.com (10.1.198.147) by
 dggemi711-chm.china.huawei.com (10.3.20.110) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2106.2; Tue, 9 Feb 2021 09:48:15 +0800
Received: from dggemi761-chm.china.huawei.com ([10.9.49.202]) by
 dggemi761-chm.china.huawei.com ([10.9.49.202]) with mapi id 15.01.2106.006;
 Tue, 9 Feb 2021 09:48:15 +0800
From:   "Song Bao Hua (Barry Song)" <song.bao.hua@hisilicon.com>
To:     Finn Thain <fthain@telegraphics.com.au>,
        tanxiaofei <tanxiaofei@huawei.com>
CC:     "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: RE: [Linuxarm]  Re: [PATCH for-next 00/32] spin lock usage
 optimization for SCSI drivers
Thread-Topic: [Linuxarm]  Re: [PATCH for-next 00/32] spin lock usage
 optimization for SCSI drivers
Thread-Index: AQHW/fAMrBMz1ua2YUiLJwcWnjqnW6pPDROA
Date:   Tue, 9 Feb 2021 01:48:15 +0000
Message-ID: <e949a474a9284ac6951813bfc8b34945@hisilicon.com>
References: <1612697823-8073-1-git-send-email-tanxiaofei@huawei.com>
 <31cd807d-3d0-ed64-60d-fde32cb3833c@telegraphics.com.au>
In-Reply-To: <31cd807d-3d0-ed64-60d-fde32cb3833c@telegraphics.com.au>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.126.200.92]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRmlubiBUaGFpbiBbbWFp
bHRvOmZ0aGFpbkB0ZWxlZ3JhcGhpY3MuY29tLmF1XQ0KPiBTZW50OiBNb25kYXksIEZlYnJ1YXJ5
IDgsIDIwMjEgODo1NyBQTQ0KPiBUbzogdGFueGlhb2ZlaSA8dGFueGlhb2ZlaUBodWF3ZWkuY29t
Pg0KPiBDYzogamVqYkBsaW51eC5pYm0uY29tOyBtYXJ0aW4ucGV0ZXJzZW5Ab3JhY2xlLmNvbTsN
Cj4gbGludXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5v
cmc7DQo+IGxpbnV4YXJtQG9wZW5ldWxlci5vcmcNCj4gU3ViamVjdDogW0xpbnV4YXJtXSBSZTog
W1BBVENIIGZvci1uZXh0IDAwLzMyXSBzcGluIGxvY2sgdXNhZ2Ugb3B0aW1pemF0aW9uDQo+IGZv
ciBTQ1NJIGRyaXZlcnMNCj4gDQo+IE9uIFN1biwgNyBGZWIgMjAyMSwgWGlhb2ZlaSBUYW4gd3Jv
dGU6DQo+IA0KPiA+IFJlcGxhY2Ugc3Bpbl9sb2NrX2lycXNhdmUgd2l0aCBzcGluX2xvY2sgaW4g
aGFyZCBJUlEgb2YgU0NTSSBkcml2ZXJzLg0KPiA+IFRoZXJlIGFyZSBubyBmdW5jdGlvbiBjaGFu
Z2VzLCBidXQgbWF5IHNwZWVkIHVwIGlmIGludGVycnVwdCBoYXBwZW4gdG9vDQo+ID4gb2Z0ZW4u
DQo+IA0KPiBUaGlzIGNoYW5nZSBkb2Vzbid0IG5lY2Vzc2FyaWx5IHdvcmsgb24gcGxhdGZvcm1z
IHRoYXQgc3VwcG9ydCBuZXN0ZWQNCj4gaW50ZXJydXB0cy4NCj4gDQo+IFdlcmUgeW91IGFibGUg
dG8gbWVhc3VyZSBhbnkgYmVuZWZpdCBmcm9tIHRoaXMgY2hhbmdlIG9uIHNvbWUgb3RoZXINCj4g
cGxhdGZvcm0/DQoNCkkgdGhpbmsgdGhlIGNvZGUgZGlzYWJsaW5nIGlycSBpbiBoYXJkSVJRIGlz
IHNpbXBseSB3cm9uZy4NClNpbmNlIHRoaXMgY29tbWl0DQpodHRwczovL2dpdC5rZXJuZWwub3Jn
L3B1Yi9zY20vbGludXgva2VybmVsL2dpdC90b3J2YWxkcy9saW51eC5naXQvY29tbWl0Lz9pZD1l
NThhYTNkMmQwY2MNCmdlbmlycTogUnVuIGlycSBoYW5kbGVycyB3aXRoIGludGVycnVwdHMgZGlz
YWJsZWQNCg0KaW50ZXJydXB0IGhhbmRsZXJzIGFyZSBkZWZpbml0ZWx5IHJ1bm5pbmcgaW4gYSBp
cnEtZGlzYWJsZWQgY29udGV4dA0KdW5sZXNzIGlycSBoYW5kbGVycyBlbmFibGUgdGhlbSBleHBs
aWNpdGx5IGluIHRoZSBoYW5kbGVyIHRvIHBlcm1pdA0Kb3RoZXIgaW50ZXJydXB0cy4NCg0KPiAN
Cj4gUGxlYXNlIHNlZSBhbHNvLA0KPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1zY3Np
Lzg5YzVjYjA1Y2I4NDQ5MzlhZTY4NGRiMDA3N2Y2NzVmQGgzYy5jbw0KPiBtLw0KPiBfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXw0KPiBMaW51eGFybSBtYWls
aW5nIGxpc3QgLS0gbGludXhhcm1Ab3BlbmV1bGVyLm9yZw0KPiBUbyB1bnN1YnNjcmliZSANCg0K
VGhhbmtzDQpCYXJyeQ0KDQo=
