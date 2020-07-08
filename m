Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D13FC433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 02:01:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FEC520738
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 02:01:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="MRan9/om"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728676AbgGHCBx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jul 2020 22:01:53 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:23346 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728479AbgGHCBx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jul 2020 22:01:53 -0400
X-UUID: 1585e8770eb04512b66bf9cb16ab4603-20200708
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=3xtxTzPiW0CanIMce5p8oG8UKD98IIt2qXbJx0YJW1g=;
        b=MRan9/ompgUzz12fZBglDygi4lp853GIiP0wqXG3VVgVEVk3LR1HX9cCRoAsOaZZbPJjc3ajnaZ5r3JeclUOITF9aIbhe7vlFiGuxQgmaU9FXeCic+EDcCyg4lEC7yBjAiDe/oOfkhluJGRVwW3+DyhQOZXSKUJSfvlnDtA9DS8=;
X-UUID: 1585e8770eb04512b66bf9cb16ab4603-20200708
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 630566050; Wed, 08 Jul 2020 10:01:51 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs05n2.mediatek.inc (172.21.101.140) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 8 Jul 2020 10:01:48 +0800
Received: from [172.21.77.33] (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 8 Jul 2020 10:01:49 +0800
Message-ID: <1594173709.10600.3.camel@mtkswgap22>
Subject: Re: [RFC PATCH v4 2/3] ufs: exynos: introduce command history
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Kiwoong Kim <kwmad.kim@samsung.com>
CC:     <linux-scsi@vger.kernel.org>, <alim.akhtar@samsung.com>,
        <avri.altman@wdc.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <beanhuo@micron.com>,
        <asutoshd@codeaurora.org>, <cang@codeaurora.org>,
        <bvanassche@acm.org>, <grant.jung@samsung.com>,
        <sc.suh@samsung.com>, <hy50.seo@samsung.com>,
        <sh425.lee@samsung.com>
Date:   Wed, 8 Jul 2020 10:01:49 +0800
In-Reply-To: <40302a83cf4fd1f9e636a029db8ba579dbbda230.1594097045.git.kwmad.kim@samsung.com>
References: <cover.1594097045.git.kwmad.kim@samsung.com>
         <CGME20200708015244epcas2p44358cef6bc03288c723ef77549aaaca2@epcas2p4.samsung.com>
         <40302a83cf4fd1f9e636a029db8ba579dbbda230.1594097045.git.kwmad.kim@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgS2l3b29uZywNCg0KT24gV2VkLCAyMDIwLTA3LTA4IGF0IDEwOjQ0ICswOTAwLCBLaXdvb25n
IEtpbSB3cm90ZToNCj4gVGhpcyBpbmNsdWRlcyBmdW5jdGlvbnMgdG8gcmVjb3JkIGNvbnRleHRz
IG9mIGluY29taW5nIGNvbW1hbmRzDQo+IGluIGEgY2lyY3VsYXIgcXVldWUuIHVmc2hjZC5jIGhh
cyBhbHJlYWR5IHNvbWUgZnVuY3Rpb24NCj4gdHJhY2VyIGNhbGxzIHRvIGdldCBjb21tYW5kIGhp
c3RvcnkgYnV0IGZ0cmFjZSB3b3VsZCBiZQ0KPiBnb25lIHdoZW4gc3lzdGVtIGRpZXMgYmVmb3Jl
IHlvdSBnZXQgdGhlIGluZm9ybWF0aW9uLA0KPiBzdWNoIGFzIHBhbmljIGNhc2VzLg0KPiANCj4g
VGhpcyBwYXRjaCBhbHNvIGltcGxlbWVudHMgY2FsbGJhY2tzIGNvbXBsX3hmZXJfcmVxDQo+IHRv
IHN0b3JlIElPIGNvbnRleHRzIGF0IGNvbXBsZXRpb24gdGltZXMuDQo+IA0KPiBXaGVuIHlvdSB0
dXJuIG9uIENPTkZJR19TQ1NJX1VGU19FWFlOT1NfQ01EX0xPRywNCj4gdGhlIGRyaXZlciBjb2xs
ZWN0cyB0aGUgaW5mb3JtYXRpb24gZnJvbSBpbmNvbWluZyBjb21tYW5kcw0KPiBpbiB0aGUgY2ly
Y3VsYXIgcXVldWUuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBLaXdvb25nIEtpbSA8a3dtYWQua2lt
QHNhbXN1bmcuY29tPg0KPiBBY2tlZC1CeTogU3RhbmxleSBDaHUgPHN0YW5sZXkuY2h1QG1lZGlh
dGVrLmNvbT4NCg0KSSBhbSBzb3JyeSwgSSBkaWQgbm90IGFjayB0aGlzIHBhdGNoLg0KQ291bGQg
eW91IHBsZWFzZSBmaXggdGhlIHRhZz8NCg0KQWN0dWFsbHkgSSBhY2tlZCBhbm90aGVyIHBhdGNo
IDogKQ0KInVmczogaW50cm9kdWNlIGEgY2FsbGJhY2sgdG8gZ2V0IGluZm8gb2YgY29tbWFuZCBj
b21wbGV0aW9uIg0KDQpQbGVhc2Ugc2VlDQpodHRwczovL3BhdGNod29yay5rZXJuZWwub3JnL3Bh
dGNoLzExNjQwOTAxLw0KDQpUaGFua3MsDQpTdGFubGV5IENodQ0K

