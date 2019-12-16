Return-Path: <SRS0=9qbq=2G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7A11C43603
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Dec 2019 03:53:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADF3D22B48
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Dec 2019 03:53:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="bh6KUwlk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbfLPDxA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Dec 2019 22:53:00 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:58814 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726704AbfLPDxA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Dec 2019 22:53:00 -0500
X-UUID: 1f40dedb05484bf79ec042414cecbf52-20191216
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=5K/XbBKs8iA6ab+03BUBztdPLrJv72ygYwkxrqAIQ9U=;
        b=bh6KUwlkLwzGgZnlR+cuClZ/hjtLp+eIRQIbEtrhd6Mt/ZtPR2P+kfmdWKMT+mCO0HmeTtPhU7oav/7+WJG98HjJOe8Mq+8SRo5pQOr+oOgwYwzh/YvTcjkXAKf/BX+G60suXHd1wA2lRRo0bkdcF6e4hlK3ynQmhqx7QhmHIuA=;
X-UUID: 1f40dedb05484bf79ec042414cecbf52-20191216
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 86540602; Mon, 16 Dec 2019 11:52:51 +0800
Received: from mtkcas09.mediatek.inc (172.21.101.178) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 16 Dec 2019 11:51:41 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas09.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 16 Dec 2019 11:52:51 +0800
Message-ID: <1576468370.13056.2.camel@mtkswgap22>
Subject: Re: [PATCH v2 1/2 RESEND] soc: mediatek: add header for SiP service
 interface
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        <f.fainelli@gmail.com>, <matthias.bgg@gmail.com>
CC:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "pedrom.sousa@synopsys.com" <pedrom.sousa@synopsys.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        Kuohong Wang =?UTF-8?Q?=28=E7=8E=8B=E5=9C=8B=E9=B4=BB=29?= 
        <kuohong.wang@mediatek.com>,
        Peter Wang =?UTF-8?Q?=28=E7=8E=8B=E4=BF=A1=E5=8F=8B=29?= 
        <peter.wang@mediatek.com>,
        Chun-Hung Wu =?UTF-8?Q?=28=E5=B7=AB=E9=A7=BF=E5=AE=8F=29?= 
        <Chun-hung.Wu@mediatek.com>,
        Andy Teng =?UTF-8?Q?=28=E9=84=A7=E5=A6=82=E5=AE=8F=29?= 
        <Andy.Teng@mediatek.com>,
        Leon Chen =?UTF-8?Q?=28=E9=99=B3=E6=96=87=E9=8F=98=29?= 
        <Leon.Chen@mediatek.com>
Date:   Mon, 16 Dec 2019 11:52:50 +0800
In-Reply-To: <1576468137-17220-2-git-send-email-stanley.chu@mediatek.com>
References: <1576468137-17220-1-git-send-email-stanley.chu@mediatek.com>
         <1576468137-17220-2-git-send-email-stanley.chu@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 89A95AE056A1C55C4F5ED8FC96F4CCD94C675532D4D860D6EF86D25D953A31ED2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgTWF0dGhpYXMgYW5kIEZsb3JpYW4sDQoNCkNvdWxkIHlvdSBwbGVhc2UgaGVscCByZXZpZXcg
dGhpcyByZXZpc2VkIHYyIHBhdGNoID8NCg0KT3IgcGxlYXNlIGFkdmlzZSBpZiBhbnkgZXhwZXJ0
IGNvdWxkIGhlbHAgPw0KDQpUaGFua3Mgc28gbXVjaC4NClN0YW5sZXkNCg0KT24gTW9uLCAyMDE5
LTEyLTE2IGF0IDExOjQ4ICswODAwLCBTdGFubGV5IENodSB3cm90ZToNCj4gQWRkIGEgaGVhZGVy
IGZvciB0aGUgU2lQIHNlcnZpY2UgaW50ZXJmYWNlIGluIG9yZGVyIHRvIGFjY2Vzcw0KPiB0aGUg
VUZTSENJIGNvbnRyb2xsZXIgZm9yIHNlY3VyZSBjb21tYW5kIGhhbmRsaW5nIGluIE1lZGlhVGVr
IENoaXBzZXRzLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogU3RhbmxleSBDaHUgPHN0YW5sZXkuY2h1
QG1lZGlhdGVrLmNvbT4NCg0K

