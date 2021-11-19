Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7783C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 02:46:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89D7A61B29
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 02:46:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbhKSCt4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Nov 2021 21:49:56 -0500
Received: from exvmail.hynix.com ([166.125.252.79]:53980 "EHLO
        invmail.skhynix.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S231264AbhKSCt4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Nov 2021 21:49:56 -0500
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Nov 2021 21:49:55 EST
X-AuditID: a67dfc4e-335ff7000000da67-b4-61970c944540
Received: from hymail21.hynixad.com (10.156.135.51) by hymail08.hynixad.com
 (10.156.135.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.986.5; Fri, 19 Nov 2021
 11:31:48 +0900
Received: from hymail21.hynixad.com ([10.156.135.51]) by hymail21.hynixad.com
 ([10.156.135.51]) with mapi id 15.02.0986.005; Fri, 19 Nov 2021 11:31:48
 +0900
From:   =?ks_c_5601-1987?B?waS/5MfRKEpPVU5HIFlPSEFOKSBNb2JpbGUgU0U=?= 
        <yohan.joung@sk.com>
To:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        =?ks_c_5601-1987?B?w9bA57+1KENIT0kgSkFFIFlPVU5HKSBNb2JpbGUgU0U=?= 
        <jaeyoung21.choi@sk.com>,
        =?ks_c_5601-1987?B?sPvFwrz2KEtXQUsgVEFFU1UpIE1vYmlsZSBTRQ==?= 
        <taesu.kwak@sk.com>
Subject: Please check ufshpb init flow
Thread-Topic: Please check ufshpb init flow
Thread-Index: Adfc6j2tFkh4yQNUQbaUsbtOylGK5Q==
Date:   Fri, 19 Nov 2021 02:31:47 +0000
Message-ID: <e092e35414844175bf76868b820d907f@sk.com>
Accept-Language: ko-KR, en-US
Content-Language: ko-KR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.152.36.34]
Content-Type: text/plain; charset="ks_c_5601-1987"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsXCNUdUWXcKz/REg593JS26r+9gc2D0+LxJ
        LoAxissmJTUnsyy1SN8ugStj6oE/TAVbeCsW/T7K2MDYwdvFyMkhIWAicf/YSdYuRi4OIYFX
        jBKfH/9lhnAWMEq8aJvKBFLFJhAl8bh1BTtIQkTgLpPEm7YJbCAOs8AXRokdT56zgFQJC6hJ
        vPx9kRXEFhHQlvh6aROQzQFk60nc3ygNEmYRUJV4sXE2O0iYV8BUomFXIIjJKCArcfWaDEgF
        s4C4xOKv15ghjhOQWLLnPJQtKvHy8T9WCFtBYuX3C0wQ9UYSS1bPh7IVJaZ0P2QHsXkFBCVO
        znzCAlEvKXFwxQ2WCYwis5CsmIWkfRaS9llI2hcwsqxiFM7MK8tNzMzRK87OqMzLrNBLzs/d
        xAgM+mW1f/x2MH65EHyIUYCDUYmHNyN5WqIQa2JZcWXuIUYJDmYlEV6hhqmJQrwpiZVVqUX5
        8UWlOanFhxilOViUxHm/haUmCAmkJ5akZqemFqQWwWSZODilGhjj+paFHxI33Tn3scykWUcf
        /vrH4Nchxz57Vmdz6Iv+F69DEy5tutjyln/vJmOb9zOe7pPv/HcmmPHGg/JVt/gu/xTjtrS+
        +NHA8vDSf+/vyrm6Sj/qjbY1zw2ZmaqgbCn2M9jBT4DfpCV7i+feaHveIKVDpbnbBKV/lj7Z
        MO+MK2uk/Ku0swJKLMUZiYZazEXFiQCk9hSbdgIAAA==
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgZGFlanVuDQoNClBsZWFzZSBjaGVjayB1ZnNocGIgaW5pdCBmbG93Lg0Kc2VuZGluZyB3cml0
ZSBidWZmZXIoMHgwMykgc2VlbXMgc3BlYyB2aW9sYXRpb24gKEpFU0QyMjAgQ29tbWFuZHMgZm9y
IGV4Y2VwdGlvbmFsIGJlaGF2aW9yIG9uIFVBQywgU0FNIDVyMDUpIGJlZm9yZSBVQUMgY2xlYXIg
KHNkX3Byb2JlKS4NCkFueXdheSBocGIgcmVzZXQgcXVlcnkodWZzaHBiX2NoZWNrX2hwYl9yZXNl
dF9xdWVyeSkgc2VlbXMgc3VmZmljaWVudC4NCldoeSBkbyB3ZSBuZWVkIHRvIHNlbmQgd3JpdGUg
YnVmZmVyPw0KDQp2b2lkIHVmc2hwYl9pbml0X2hwYl9sdShzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBz
dHJ1Y3Qgc2NzaV9kZXZpY2UgKnNkZXYpDQp7DQpvdXQ6DQogICAgLyogQWxsIExVcyBhcmUgaW5p
dGlhbGl6ZWQgKi8NCiAgICBpZiAoYXRvbWljX2RlY19hbmRfdGVzdCgmaGJhLT51ZnNocGJfZGV2
LnNsYXZlX2NvbmZfY250KSkNCglUaGVyZSBzZWVtcyB0byBiZSBhIHByb2JsZW0gd2l0aCB0aGlz
IGxvZ2ljLg0KCUlmIGhwYiBpcyBzZXQgb24gdGhlIGxhc3QgTFVOLCB3cml0ZSBidWZmZXIgY29t
bWFuZCBpcyBzZW50IGJlZm9yZSBzZF9wcm9iZSBjb21wbGV0ZXMuDQogICAgICAgIHVmc2hwYl9o
cGJfbHVfcHJlcGFyZWQoaGJhKTsNCn0NCg0Kc3RhdGljIHZvaWQgdWZzaHBiX2hwYl9sdV9wcmVw
YXJlZChzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0Kew0KDQogICAgaW5pdF9zdWNjZXNzID0gIXVmc2hw
Yl9jaGVja19ocGJfcmVzZXRfcXVlcnkoaGJhKTsNCg0KICAgIHNob3N0X2Zvcl9lYWNoX2Rldmlj
ZShzZGV2LCBoYmEtPmhvc3QpIHsNCiAgICAgICAgaHBiID0gdWZzaHBiX2dldF9ocGJfZGF0YShz
ZGV2KTsNCiAgICAgICAgaWYgKCFocGIpDQogICAgICAgICAgICBjb250aW51ZTsNCg0KICAgICAg
ICBpZiAoaW5pdF9zdWNjZXNzKSB7DQogICAgICAgICAgICB1ZnNocGJfc2V0X3N0YXRlKGhwYiwg
SFBCX1BSRVNFTlQpOw0KICAgICAgICAgICAgaWYgKChocGItPmx1X3Bpbm5lZF9lbmQgLSBocGIt
Pmx1X3Bpbm5lZF9zdGFydCkgPiAwKQ0KICAgICAgICAgICAgICAgIHF1ZXVlX3dvcmsodWZzaHBi
X3dxLCAmaHBiLT5tYXBfd29yayk7DQogICAgICAgICAgICBpZiAoIWhwYi0+aXNfaGNtKQ0KICAg
ICAgICAgICAgICAgIHVmc2hwYl9pc3N1ZV91bWFwX2FsbF9yZXEoaHBiKTsgDQoJCVRoaXMgc2Vl
bXMgdW5uZWNlc3NhcnkuDQoJCQ0KICAgICAgICB9IGVsc2Ugew0KDQpUaGFua3MgDQp5b2hhbg0K
