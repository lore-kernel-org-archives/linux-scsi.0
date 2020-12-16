Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 626F9C4361B
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Dec 2020 04:16:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16FF02311B
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Dec 2020 04:16:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725730AbgLPEQO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:16:14 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:47427 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725550AbgLPEQO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Dec 2020 23:16:14 -0500
X-UUID: 3444cbf2a01b44cd85755004dd496a35-20201216
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=yQi3mt/w9tFbZqkbK6lWAoImcIv1tuUJZaDChx6V8fQ=;
        b=grUzlU9CMmCJKlwi4G54Vi/bJbvryhp5q1dyErDVDk1awQzfgFoFXiCypCS4G7C82J+SAC1iRyauVPtrHqCaeGUj6XSX3pHfiM9VHSAQA11TP8RRrAqqEa4ODVhMtNmr2QzlUm80NzlV84QwkUTYXsMlnED9GbzpVwW282MQHdM=;
X-UUID: 3444cbf2a01b44cd85755004dd496a35-20201216
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 131592451; Wed, 16 Dec 2020 12:15:29 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by mtkexhb01.mediatek.inc
 (172.21.101.102) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 16 Dec
 2020 12:15:06 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 16 Dec 2020 12:15:05 +0800
Message-ID: <1608092106.10163.29.camel@mtkswgap22>
Subject: Re: [PATCH v5 4/7] scsi: ufs: Remove two WB related fields from
 struct ufs_dev_info
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Bean Huo <huobean@gmail.com>
CC:     <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <asutoshd@codeaurora.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <beanhuo@micron.com>,
        <bvanassche@acm.org>, <tomas.winkler@intel.com>,
        <cang@codeaurora.org>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Date:   Wed, 16 Dec 2020 12:15:06 +0800
In-Reply-To: <20201215230519.15158-5-huobean@gmail.com>
References: <20201215230519.15158-1-huobean@gmail.com>
         <20201215230519.15158-5-huobean@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gV2VkLCAyMDIwLTEyLTE2IGF0IDAwOjA1ICswMTAwLCBCZWFuIEh1byB3cm90ZToNCj4gRnJv
bTogQmVhbiBIdW8gPGJlYW5odW9AbWljcm9uLmNvbT4NCj4gDQo+IGRfd2JfYWxsb2NfdW5pdHMg
YW5kIGRfZXh0X3Vmc19mZWF0dXJlX3N1cCBvbmx5IGJlIHVzZWQgd2hpbGUgV0IgcHJvYmUuDQo+
IFRoZXkgYXJlIGp1c3QgdXNlZCB0byBjb25maXJtIHRoZSBjb25kaXRpb24gdGhhdCAiaWYgYldy
aXRlQm9vc3RlckJ1ZmZlclR5cGUNCj4gaXMgc2V0IHRvIDAxaCBidXQgZE51bVNoYXJlZFdyaXRl
Qm9vc3RlckJ1ZmZlckFsbG9jVW5pdHMgaXMgc2V0IHRvIHplcm8sDQo+IHRoZSBXcml0ZUJvb3N0
ZXIgZmVhdHVyZSBpcyBkaXNhYmxlZCIsIGFuZCBpZiBVRlMgZGV2aWNlIHN1cHBvcnRzIFdCLg0K
PiBBZnRlciB0aGF0LCBubyB1c2VyIHVzZXMgdGhlbSBhbnkgbW9yZS4gU28sIGRvbid0IG5lZWQg
dG8ga2VlcCB0aW1lIGluDQo+IHJ1bnRpbWUuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBCZWFuIEh1
byA8YmVhbmh1b0BtaWNyb24uY29tPg0KDQpSZXZpZXdlZC1ieTogU3RhbmxleSBDaHUgPHN0YW5s
ZXkuY2h1QG1lZGlhdGVrLmNvbT4NCg0K

