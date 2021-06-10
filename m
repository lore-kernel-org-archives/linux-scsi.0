Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,
	CHARSET_FARAWAY_HEADER,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B50FC48BCD
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 02:12:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AB25613EF
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 02:12:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbhFJCO0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Jun 2021 22:14:26 -0400
Received: from exvmail3.skhynix.com ([166.125.252.90]:46152 "EHLO
        invmail3.skhynix.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229557AbhFJCO0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jun 2021 22:14:26 -0400
X-AuditID: a67dfc59-d75ff70000008761-4c-60c1750cf881
Received: from hymail21.hynixad.com (10.156.135.51) by hymail19.hynixad.com
 (10.156.135.49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.792.3; Thu, 10 Jun 2021
 11:12:28 +0900
Received: from hymail21.hynixad.com ([10.156.135.51]) by hymail21.hynixad.com
 ([10.156.135.51]) with mapi id 15.02.0792.010; Thu, 10 Jun 2021 11:12:28
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
        "sungjun07.park@samsung.com" <sungjun07.park@samsung.com>
Subject: Re: [PATCH v36 4/4] scsi: ufs: Add HPB 2.0 support
Thread-Topic: Re: [PATCH v36 4/4] scsi: ufs: Add HPB 2.0 support
Thread-Index: AdddnBVr0vzEwO50RpirWSKIimBtxQ==
Date:   Thu, 10 Jun 2021 02:12:27 +0000
Message-ID: <b64cf2a49a1b43f09961eb4d5d4ea5c2@sk.com>
Accept-Language: ko-KR, en-US
Content-Language: ko-KR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.152.36.34]
Content-Type: text/plain; charset="ks_c_5601-1987"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFLMWRmVeSWpSXmKPExsXCNUdUWZen9GCCwdJNihaXd81hs+i+voPN
        gcnj8ya5AMYoLpuU1JzMstQifbsEroyJj64yFtxir2jZMpG5gfEAexcjJ4eEgInE4cULgWwu
        DiGBV4wSryaeZIFwFjBKzFjxlhGkik0gSuJx6wqwDhEBS4mDezaxghQxCyzlkHhzZjkTSEJY
        wFriYFsXG0SRg8SuabdZIGw9iYmvDjKD2CwCqhL3rvWA2bwCphL/f80CGsTBwSggK3H1mgxI
        mFlAXGLx12vMENcJSCzZcx7KFpV4+fgfK4StILHy+wUmiHojiSWr50PZihJTuh+yQ4wXlDg5
        8wkLRL2kxMEVN1gmMIrMQrJiFpL2WUjaZyFpX8DIsopRJDOvLDcxM8dYrzg7ozIvs0IvOT93
        EyMwBpbV/oncwfjtQvAhRgEORiUe3owLBxKEWBPLiitzDzFKcDArifCWGe5LEOJNSaysSi3K
        jy8qzUktPsQozcGiJM77LSw1QUggPbEkNTs1tSC1CCbLxMEp1cDoU/f0kEOyGs/ORUyhGvsO
        hb7jfiLparFccceJJVdOqFmGPreYnMhWkKJzaP7NBfdEyxpypjg2sOr3Xjxq+G9zV2/94sWb
        Xz+Y5fOwyN5jmZWXlXn2E0/9Xfdfe595GqZgey9aLTFF7vSdUO7l5d0HHece/brF0fXF5Z6X
        s5PZT8y6XbezfqmoEktxRqKhFnNRcSIAzHUF+n0CAAA=
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
CQkJMTI4DQogDQpBY2NvcmRpbmcgdG8gdGhlIEpFREVDIHNwZWMsIGJNQVhfREFUQV9TSVpFX0ZP
Ul9IUEJfU0lOR0xFX0NNRCBjYW4gYmUgc2V0IGZyb20gNGtiIHRvIDEwMjRrYi4gDQpUaGUgdHJh
bnNmZXIgbGVuZ3RoIHNob3VsZCBiZSBwcm92aWRlZCB1cCB0byAxMDIwa2Igb3IgMTAyNGtiLg0K
V2h5IGRpZCB5b3Ugc2V0IEhQQl9NVUxUSV9DSFVOS19ISUdIIHRvIDEyOD8gDQpJdCBjYW4gc2Vu
ZHMgdGhlIGhwYiBjb21tYW5kIHVwIHRvIDUxMmtiLiANClRoaXMgZG9lc24ndCBzZWVtIHRvIG1h
dGNoIHRoZSBzcGVjcy4NCg0KVGhhbmtzDQpZb2hhbi4NCg0K
