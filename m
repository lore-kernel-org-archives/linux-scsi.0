Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4502C19F2D
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Aug 2022 01:54:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240060AbiHEByP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Aug 2022 21:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235658AbiHEByO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Aug 2022 21:54:14 -0400
Received: from invmail.skhynix.com (exvmail.hynix.com [166.125.252.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D6C05B83
        for <linux-scsi@vger.kernel.org>; Thu,  4 Aug 2022 18:54:09 -0700 (PDT)
X-AuditID: a67dfc4e-cc1ff700000138f0-f2-62ec783e23dd
Received: from hymail21.hynixad.com (10.156.135.51) by hymail23.hynixad.com
 (10.156.135.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.986.15; Fri, 5 Aug 2022
 10:54:06 +0900
Received: from hymail21.hynixad.com ([10.156.135.51]) by hymail21.hynixad.com
 ([10.156.135.51]) with mapi id 15.02.0986.015; Fri, 5 Aug 2022 10:54:06 +0900
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
Thread-Index: AQHYoUKOvUbRZtx3z0GI27+IE7yewa2cTOUQgACEW4CAATMjMIAAduaAgAESlAA=
Date:   Fri, 5 Aug 2022 01:54:06 +0000
Message-ID: <f0464649f7e144c4a0536659201fc48b@sk.com>
References: <20220726225232.1362251-1-bvanassche@acm.org>
 <55fce3baaabf4e33aeaccbe5b4e1f145@sk.com>
 <6263c2a5-e7b6-c9e5-69e8-b6d93604d82d@acm.org>
 <d8945bdf320240b2bdf6ee411eff6c8a@sk.com>
 <7a6499c6-4e98-072e-ce09-ddda7179b93e@acm.org>
In-Reply-To: <7a6499c6-4e98-072e-ce09-ddda7179b93e@acm.org>
Accept-Language: ko-KR, en-US
Content-Language: ko-KR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.152.36.223]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJLMWRmVeSWpSXmKPExsXCNUdUSde+4k2SwcE9zBbd13ewOTB6fN4k
        F8AYxWWTkpqTWZZapG+XwJXROfsde8EkrorztztZGxg/cHYxcnJICJhI7F3xh7mLkYtDSOAV
        o8SCt+uYIJy5jBKXntxkBaliEwiVuHF7JSOILSIQJ9E66xUjSBGzwBUmiUkf/7KDJIQFPCTW
        fZ4BlOAAKvKUuD8lBML0k9j4IQKkgkVAReLLglawkbwCphLHz/cyQuz6zChxeMcHFpAEp4C1
        xOFnG5hBehkFZCWuXpMBCTMLiEss/nqNGeJoAYkle85D2aISLx//Y4WwFSV+/9nKCtLKLKAp
        sX6XPkSrosSU7ofsEGsFJU7OfMICUS4pcXDFDZYJjGKzkGyYhdA9C0n3LCTdCxhZVjEKZ+aV
        5SZm5ugVZ2dU5mVW6CXn525iBEbIsto/fjsYv1wIPsQowMGoxMN7YMvrJCHWxLLiytxDjBIc
        zEoivD93AIV4UxIrq1KL8uOLSnNSiw8xSnOwKInzfgtLTRASSE8sSc1OTS1ILYLJMnFwSjUw
        yvcuunZvseVjeekXkT6L4h1eRO2/4FK9LOdwscjEHr91i679tax+9XO69JJpuVxzY6UfLdj9
        u/9X7cRdAtv39ZYsKuydk2230tE1d07jz4fpHVMjv+xz4f6lJe7YlvW4pOCpzXdzcw6T53qf
        eY6L31siprzpQ37sMwkes3Xms8tiXQTXNzF1K7EUZyQaajEXFScCAG24S7yMAgAA
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiA+IEluIGJsb2NrIGxheWVyLCBtYXhfc2VnbWVudF9zaXplIGlzIG9idGFpbmVkIGZyb20gZ2V0
X21heF9zZWdtZW50X3NpemUuDQo+ID4gc2VnX2JvdW5kYXJ5X21hc2sgaXMgc2V0IHRvIFBBR0Vf
U0laRSAtIDEgaW4gdGhlIHVmcyBkcml2ZXIuDQo+ID4gVGhlIHNlZ21lbnQgc2l6ZSBpcyB0aGUg
UEFHRSBzaXplLCBhbmQgdGhlIG1heCBidWZmZXIgc2l6ZSBpcyBzZWdtZW50DQo+ID4gc2l6ZSAq
IG1heCBzZWdtZW50IGNvdW50ICggUEFHRSBTSVpFICogMTI4ICkgPSA1MTIgS2lCICBpbiBibG9j
ayBsYXllcg0KPiA+IFJpZ2h0Pw0KPiANCj4gVGhhbmtzIGZvciBoYXZpbmcgcmVwb3J0ZWQgdGhp
cy4gSSBoYWQgb3Zlcmxvb2tlZCB0aGF0IHRoZSBVRlMgaG9zdA0KPiBjb250cm9sbGVyIGRyaXZl
ciBzZXRzIHRoZSBkbWFfYm91bmRhcnkgbWVtYmVyIG9mIHRoZSBob3N0X3RlbXBsYXRlIGZpZWxk
Lg0KPiBJcyBteSB1bmRlcnN0YW5kaW5nIGNvcnJlY3QgdGhhdCBVRlMgaG9zdCBjb250cm9sbGVy
cyBzaG91bGQgc3VwcG9ydCBETUENCj4gc2VnbWVudHMgdGhhdCBjb25zaXN0IG9mIG11bHRpcGxl
IHBoeXNpY2FsIHBhZ2VzPw0KbWF4IHZhbHVlIG9mIGRhdGEgYnl0ZSBjb3VudCBpcyAyNTZrYiBp
biBQUkRULiANCjI1NmtiIChkYXRhIGJ5dGUgY291bnQpICogMTI4IChtYXggc2VnbWVudHMpID0g
MzI3NjhrYg0KSWYgcGh5c2ljYWwgcGFnZXMgYXJlIGNvbnRpbnVvdXMsIGl0IHNlZW1zIHRoYXQg
SU8gY2FuIGJlIGRlbGl2ZXJlZCB1cCB0byAzMm1iLg0KcGVyZm9ybWFuY2UgY2hlY2tzIGFyZSBy
ZXF1aXJlZCwgYnV0IHdlIGRvbid0IGhhdmUgdG8gY29uc2lkZXIgc2F0dXJhdGlvbi4NCmJlY2F1
c2UgdGhlIGRldmljZSB2ZW5kb3IgY2FuIHNldCBvcHRfeGZlcl9ibG9ja3MgLg0KVGhhbmtzLCAN
CnlvaGFuDQo+IA0KPiBUaGFua3MsDQo+IA0KPiBCYXJ0Lg0K
