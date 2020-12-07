Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77AE0C4167B
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 05:20:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42FA4221E2
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 05:20:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbgLGFUK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 00:20:10 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:37563 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725681AbgLGFUK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2020 00:20:10 -0500
X-UUID: 2a0a26349aa04380bf9ad07260c2bb99-20201207
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=AXgl3v3hUN1KoezVgxjai1p60MW27hu4dKaI+hqPAR4=;
        b=EJ5uDMOQtenk539xah6gXBy6WeUkP5ZlzUnzD6uQpn6YDHqtpDcm5JYmYYpKQxfIgpL0XK94iRq42c9jQwohqg0MtGOSZDH/C6YKuguAKYqa3ERX44SuKyIgkp4NCwd1Wu1RoGjGXjoJAIly2e553LMMZsroAWoLavhahRhlBfo=;
X-UUID: 2a0a26349aa04380bf9ad07260c2bb99-20201207
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 838548732; Mon, 07 Dec 2020 13:19:23 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 7 Dec 2020 13:19:21 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 7 Dec 2020 13:19:20 +0800
Message-ID: <1607318361.3580.3.camel@mtkswgap22>
Subject: Re: [PATCH v2 3/3] scsi: ufs: Changes comment in the function
 ufshcd_wb_probe()
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Bean Huo <huobean@gmail.com>
CC:     <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <asutoshd@codeaurora.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <beanhuo@micron.com>,
        <bvanassche@acm.org>, <tomas.winkler@intel.com>,
        <cang@codeaurora.org>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Date:   Mon, 7 Dec 2020 13:19:21 +0800
In-Reply-To: <20201206101335.3418-4-huobean@gmail.com>
References: <20201206101335.3418-1-huobean@gmail.com>
         <20201206101335.3418-4-huobean@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gU3VuLCAyMDIwLTEyLTA2IGF0IDExOjEzICswMTAwLCBCZWFuIEh1byB3cm90ZToNCj4gRnJv
bTogQmVhbiBIdW8gPGJlYW5odW9AbWljcm9uLmNvbT4NCj4gDQo+IFVTRkhDRCBzdXBwb3J0cyBX
cml0ZUJvb3N0ZXIgIkxVIGRlZGljYXRlZCBidWZmZXLigJ0gbW9kZSBhbmQNCj4g4oCcc2hhcmVk
IGJ1ZmZlcuKAnSBtb2RlIGJvdGgsIHNvIGNoYW5nZXMgdGhlIGNvbW1lbnQgaW4gdGhlDQo+IGZ1
bmN0aW9uIHVmc2hjZF93Yl9wcm9iZSgpLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQmVhbiBIdW8g
PGJlYW5odW9AbWljcm9uLmNvbT4NCj4gUmV2aWV3ZWQtYnk6IENhbiBHdW8gPGNhbmdAY29kZWF1
cm9yYS5vcmc+DQoNClJldmlld2VkLWJ5OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0
ZWsuY29tPg0K

