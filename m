Return-Path: <SRS0=1R64=74=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E705C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 14:48:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1C6A2071A
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 14:48:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="qZ+TumLN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730613AbgFOOsK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Jun 2020 10:48:10 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:54973 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728304AbgFOOsK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jun 2020 10:48:10 -0400
X-UUID: fa472e43d6fe4f8c856300306a90c37a-20200615
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=JT5TIMa/y9db8xDofK6AotJvJ9TLioruJwaz49+x9qM=;
        b=qZ+TumLNeaPS7vMEsVUlf5qn1Mjp62vePzYEaOeqwC1ai314FUCMa0u3x2IebNynmjXMDmVSqodO3/feCOlUvJnVqswlzfwYAgQ53qgim2uujpWpaOY/Dk6iW1o2Ii4H6GxPxFyn6IPbvdHeDwpxI79lo5/OLjgjdz0SE2QdUwE=;
X-UUID: fa472e43d6fe4f8c856300306a90c37a-20200615
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 2018647581; Mon, 15 Jun 2020 22:48:08 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 15 Jun 2020 22:48:03 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 15 Jun 2020 22:48:02 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <asutoshd@codeaurora.org>
CC:     <beanhuo@micron.com>, <cang@codeaurora.org>,
        <matthias.bgg@gmail.com>, <bvanassche@acm.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <cc.chou@mediatek.com>,
        <chaotian.jing@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v2 0/3] scsi: ufs: Export UFS debugging dump for vendors
Date:   Mon, 15 Jun 2020 22:48:02 +0800
Message-ID: <20200615144805.6921-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksDQoNClRoaXMgc2VyaWVzIGNyZWF0ZXMgYW4gdW5pZmllZCBlbnRyeSBmdW5jdGlvbiBmb3Ig
VUZTIGRlYnVnZ2luZyBpbmZvcm1hdGlvbiBkdW1wLCBhbmQgZXhwb3J0cyBpdCB0byB2ZW5kb3Jz
IHRvIGhlbHAgZGVidWdnaW5nLg0KDQpJbiB0aGUgc2FtZSB0aW1lLCBkbyBhIHNtYWxsIGNsZWFu
dXAgaW4gdWZzaGNkX21ha2VfaGJhX29wZXJhdGlvbmFsKCkuDQoNCnYxIC0+IHYyOg0KICAtIEZp
eCBpbmNvcnJlY3QgcmV0dXJuZWQgdmFsdWUgaW4gcGF0Y2hbM10ncyB1ZnNfbXRrX2xpbmtfc2V0
X2hwbSgpDQoNClN0YW5sZXkgQ2h1ICgzKToNCiAgc2NzaTogdWZzOiBSZW1vdmUgcmVkdW5kYW50
IGxhYmVsICJvdXQiIGluDQogICAgdWZzaGNkX21ha2VfaGJhX29wZXJhdGlvbmFsKCkNCiAgc2Nz
aTogdWZzOiBNYW5hZ2UgYW5kIGV4cG9ydCBVRlMgZGVidWdnaW5nIGluZm9ybWF0aW9uIGR1bXAN
CiAgc2NzaTogdWZzLW1lZGlhdGVrOiBQcmludCBob3N0IGluZm9ybWF0aW9uIGZvciBmYWlsZWQg
c3Vwc2VuZCBhbmQNCiAgICByZXN1bWUNCg0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVr
LmMgfCAxNiArKysrKysrLS0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgICAgICAgfCA1
MSArKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vm
c2hjZC5oICAgICAgIHwgIDggKysrKysrDQogMyBmaWxlcyBjaGFuZ2VkLCA0NyBpbnNlcnRpb25z
KCspLCAyOCBkZWxldGlvbnMoLSkNCg0KLS0gDQoyLjE4LjANCg==

