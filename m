Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A09FC48BCD
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 02:10:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E83C461407
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 02:10:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbhFJCM1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Jun 2021 22:12:27 -0400
Received: from exvmail3.skhynix.com ([166.125.252.90]:61831 "EHLO
        invmail3.skhynix.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229705AbhFJCM1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jun 2021 22:12:27 -0400
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Jun 2021 22:12:26 EDT
X-AuditID: a67dfc59-d75ff70000008761-6f-60c1710d3855
Received: from hymail21.hynixad.com (10.156.135.51) by hymail19.hynixad.com
 (10.156.135.49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.792.3; Thu, 10 Jun 2021
 10:55:24 +0900
Received: from hymail21.hynixad.com ([10.156.135.51]) by hymail21.hynixad.com
 ([10.156.135.51]) with mapi id 15.02.0792.010; Thu, 10 Jun 2021 10:55:24
 +0900
From:   =?utf-8?B?7KCV7JqU7ZWcKEpPVU5HIFlPSEFOKSBNb2JpbGUgU0U=?= 
        <yohan.joung@sk.com>
To:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v36 4/4] scsi: ufs: Add HPB 2.0 support
Thread-Topic: [PATCH v36 4/4] scsi: ufs: Add HPB 2.0 support
Thread-Index: AQHXW1RTlN1ifpMXPEWIYMQnD3fis6sMe1SA
Date:   Thu, 10 Jun 2021 01:55:24 +0000
Message-ID: <e540ec7b6d3e4adc97780fcdf87f46aa@sk.com>
References: <20210607041650epcms2p29002c9d072738bbf21fb4acf31847e8e@epcms2p2>
        <CGME20210607041650epcms2p29002c9d072738bbf21fb4acf31847e8e@epcms2p7>
 <20210607041927epcms2p707781de1678af1e1d0f4d88782125f7b@epcms2p7>
In-Reply-To: <20210607041927epcms2p707781de1678af1e1d0f4d88782125f7b@epcms2p7>
Accept-Language: ko-KR, en-US
Content-Language: ko-KR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.152.36.34]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsXCNUdUWZe38GCCwe9ufovLu+awWXRf38Hm
        wOTxeZNcAGMUl01Kak5mWWqRvl0CV8b9VbMYC26xV2xe2sDUwHiAvYuRk0NCwETi4Zx3LF2M
        XBxCAq8YJS48/c8O4SxglLjYuJUJpIpNIFTixu2VjCAJEYEpLBL/1j5jA0kwC9RJ7J7zB8wW
        FrCWuNi+BWgUB1CRjUTnZQuQsIiAkcStWa+ZQWwWAVWJh0cnMYOU8AqYSrz6xw2x6wGjxNbm
        92BjOAX8JA5uf8MOUsMoICtx9ZoMxCZxicVfrzFDHC0gsWTPeShbVOLl43+sELaCxMrvF5hA
        WpkFNCXW79KHaFWUmNL9EOxfXgFBiZMzn7BAlEtKHFxxg2UCo9gsJBtmIXTPQtI9C0n3AkaW
        VYwimXlluYmZOcZ6xdkZlXmZFXrJ+bmbGIHRsqz2T+QOxm8Xgg8xCnAwKvHwZlw4kCDEmlhW
        XJl7iFGCg1lJhLfMcF+CEG9KYmVValF+fFFpTmrxIUZpDhYlcd5vYakJQgLpiSWp2ampBalF
        MFkmDk6pBsY1XDxbGjesd0k6Ff7/0qvKe1t2bdJ3PRYeasqrbeKlvHO+0ALX6/YL2XiEQ9U0
        1sjzvtxvPSu1ijlS1uLIj5qeLzpbFyV7uq67/27iceEf2iIJTYtKIt8IG3iccZpxXNjqxoWa
        zH9eG41Mpsa5KrinKmXeX9DabL656n6jRG7HtfDf+mtr/yuxFGckGmoxFxUnAgB+qaEPkgIA
        AA==
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaHBiLmggYi9kcml2ZXJzL3Njc2kvdWZz
L3Vmc2hwYi5oIGluZGV4IDZlNmEwMjUyZGMxNS4uYjExMjhiMGNlNDg2IDEwMDY0NA0KLS0tIGEv
ZHJpdmVycy9zY3NpL3Vmcy91ZnNocGIuaA0KKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNocGIu
aA0KQEAgLTMwLDE5ICszMCwyOSBAQA0KICNkZWZpbmUgUElOTkVEX05PVF9TRVQJCQkJVTMyX01B
WA0KIA0KIC8qIGhwYiBzdXBwb3J0IGNodW5rIHNpemUgKi8NCi0jZGVmaW5lIEhQQl9NVUxUSV9D
SFVOS19ISUdICQkJMQ0KKyNkZWZpbmUgSFBCX0xFR0FDWV9DSFVOS19ISUdICQkJMQ0KKyNkZWZp
bmUgSFBCX01VTFRJX0NIVU5LX0xPVwkJCTcNCisjZGVmaW5lIEhQQl9NVUxUSV9DSFVOS19ISUdI
CQkJMTI4DQogDQpBY2NvcmRpbmcgdG8gdGhlIEpFREVDIHNwZWMsIGJNQVhfIERBVEFfU0laRV9G
T1JfSFBCX1NJTkdMRV9DTUQgY2FuIGJlIHNldCBmcm9tIDRrYiB0byAxMDI0a2IuIA0KVGhlIHRy
YW5zZmVyIGxlbmd0aCBzaG91bGQgYmUgcHJvdmlkZWQgdXAgdG8gMTAyMGtiIG9yIDEwMjRrYi4N
CldoeSBkaWQgeW91IHNldCBIUEJfTVVMVElfQ0hVTktfSElHSCB0byAxMjg/IA0KSXQgY2FuIHNl
bmRzIHRoZSBocGIgY29tbWFuZCB1cCB0byA1MTJrYi4gDQpUaGlzIGRvZXNuJ3Qgc2VlbSB0byBt
YXRjaCB0aGUgc3BlY3MuDQoNClRoYW5rcw0KWW9oYW4uDQo=
