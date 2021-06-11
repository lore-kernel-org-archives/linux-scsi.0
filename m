Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=BAYES_00,
	CHARSET_FARAWAY_HEADER,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2305EC4743D
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Jun 2021 05:07:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F030361278
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Jun 2021 05:07:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbhFKFJm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Jun 2021 01:09:42 -0400
Received: from exvmail4.hynix.com ([166.125.252.92]:42672 "EHLO
        invmail4.hynix.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229562AbhFKFJl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Jun 2021 01:09:41 -0400
X-AuditID: a67dfc5b-c37ff70000013791-af-60c2ef9c244e
Received: from hymail21.hynixad.com (10.156.135.51) by hymail22.hynixad.com
 (10.156.135.52) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.792.3; Fri, 11 Jun 2021
 14:07:39 +0900
Received: from hymail21.hynixad.com ([10.156.135.51]) by hymail21.hynixad.com
 ([10.156.135.51]) with mapi id 15.02.0792.010; Fri, 11 Jun 2021 14:07:39
 +0900
From:   =?ks_c_5601-1987?B?waS/5MfRKEpPVU5HIFlPSEFOKSBNb2JpbGUgU0U=?= 
        <yohan.joung@sk.com>
To:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>
CC:     "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "d_hyun.kwon@samsung.com" <d_hyun.kwon@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        "j-young.choi@samsung.com" <j-young.choi@samsung.com>,
        "jaemyung.lee@samsung.com" <jaemyung.lee@samsung.com>,
        "javier.gonz@samsung.com" <javier.gonz@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "jh.i.park@samsung.com" <jh.i.park@samsung.com>,
        "jieon.seol@samsung.com" <jieon.seol@samsung.com>,
        "keosung.park@samsung.com" <keosung.park@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "sungjun07.park@samsung.com" <sungjun07.park@samsung.com>,
        =?ks_c_5601-1987?B?w9bA57+1KENIT0kgSkFFIFlPVU5HKSBNb2JpbGUgU0U=?= 
        <jaeyoung21.choi@sk.com>
Subject: Re: [PATCH v37 3/4] scsi: ufs: Prepare HPB read for cached sub-region
Thread-Topic: Re: [PATCH v37 3/4] scsi: ufs: Prepare HPB read for cached
 sub-region
Thread-Index: AddefoShGrvD08D4TZWSbfCJbPtUOg==
Date:   Fri, 11 Jun 2021 05:07:39 +0000
Message-ID: <29bb775275b941c08c3f3f0d835620fe@sk.com>
Accept-Language: ko-KR, en-US
Content-Language: ko-KR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.152.36.34]
Content-Type: text/plain; charset="ks_c_5601-1987"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsXCNUdUSXfO+0MJBp8eCltc3jWHzaL7+g42
        ByaPz5vkAhijuGxSUnMyy1KL9O0SuDIm3bnLWvCMo+Ltu3OsDYwnOLoYOTkkBEwkdvzrYuxi
        5OIQEnjFKHH6wEoWCGcBo0T3oqlMIFVsAlESj1tXsIPYIgKWEgf3bGIFKWIWaOWU+HR4CxtI
        QljAT6L34VsmiKJQifZ/vYwQtp7EotbrYDUsAqoSa//cZQGxeQVMJa7tagWq5+BgFJCVuHpN
        BiTMLCAusfjrNWaI6wQkluw5D2WLSrx8/I8VwlaQWPn9AhNEvZHEktXzoWxFiSndD9khxgtK
        nJz5hAWiXlLi4IobLBMYRWYhWTELSfssJO2zkLQvYGRZxSiUmVeWm5iZY6KXUZmXWaGXnJ+7
        iREY/stq/0TvYPx0IfgQowAHoxIP7w3hQwlCrIllxZW5hxglOJiVRHh3rgQK8aYkVlalFuXH
        F5XmpBYfYpTmYFES5/0WlpogJJCeWJKanZpakFoEk2Xi4JRqYPTeamZ3NO9xjXHEpH9Ba9Kl
        Fq5Ibec1sLgv8VVb6PByqdvxTu0Kky98PfmpREF89pe4w6cfmc/yENQ+w67nL2B2g+En/8/J
        oXmLF2z9/qt5Xt1nucBI5WpxdmPl4ntFZxyyppx8mZ/3TXilrMVkieXm+huez/yrIPHzvv2m
        H+wm1wVvf/1wQVyJpTgj0VCLuag4EQCE6fYpewIAAA==
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PisJLyoNCj4rCSAqIElmIHRoZSByZWdpb24gc3RhdGUgaXMgYWN0aXZlLCBtY3R4IG11c3QgYmUg
YWxsb2NhdGVkLg0KPisJICogSW4gdGhpcyBjYXNlLCBjaGVjayB3aGV0aGVyIHRoZSByZWdpb24g
aXMgZXZpY3RlZCBvcg0KPisJICogbWN0eCBhbGxjYXRpb24gZmFpbC4NCj4rCSAqLw0KPisJaWYg
KHVubGlrZWx5KCFzcmduLT5tY3R4KSkgew0KPisJCWRldl9lcnIoJmhwYi0+c2Rldl91ZnNfbHUt
PnNkZXZfZGV2LA0KPisJCQkibm8gbWN0eCBpbiByZWdpb24gJWQgc3VicmVnaW9uICVkLlxuIiwN
Cj4rCQkJc3Jnbi0+cmduX2lkeCwgc3Jnbi0+c3Jnbl9pZHgpOw0KPisJCXJldHVybiB0cnVlOw0K
PisJfQ0KPisNCj4rCWlmICgoc3Jnbl9vZmZzZXQgKyBjbnQpID4gYml0bWFwX2xlbikNCj4rCQli
aXRfbGVuID0gYml0bWFwX2xlbiAtIHNyZ25fb2Zmc2V0Ow0KPisJZWxzZQ0KPisJCWJpdF9sZW4g
PSBjbnQ7DQo+Kw0KPisJaWYgKGZpbmRfbmV4dF9iaXQoc3Jnbi0+bWN0eC0+cHBuX2RpcnR5LCBi
aXRtYXBfbGVuLA0KPisJCQkgIHNyZ25fb2Zmc2V0KSA8IGJpdF9sZW4gKyBzcmduX29mZnNldCkN
Cj4rCQlyZXR1cm4gdHJ1ZTsNCj4rDQoNCkl0IHNlZW1zIHVubmVjZXNzYXJ5IHRvIHNlYXJjaCB0
aHJvdWdoIGJpdG1hcF9sZW4NCkhvdyBhYm91dCBzZWFyY2hpbmcgYnkgdHJhbnNmZXIgc2l6ZT8N
Cg0KaWYgKGZpbmRfbmV4dF9iaXQoc3Jnbi0+bWN0eC0+cHBuX2RpcnR5LA0KICAgICAgICAgICAg
ICBiaXRfbGVuICsgc3Jnbl9vZmZzZXQsIHNyZ25fb2Zmc2V0KSA8IGJpdF9sZW4gKyBzcmduX29m
ZnNldCkNCg0KVGhhbmtzDQpZb2hhbg0K
