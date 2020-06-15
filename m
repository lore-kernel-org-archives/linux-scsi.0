Return-Path: <SRS0=1R64=74=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4AB4C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 14:31:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA2F1206B7
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 14:31:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="S6ajybk2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730177AbgFOOb3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Jun 2020 10:31:29 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:43822 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729243AbgFOOb3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jun 2020 10:31:29 -0400
X-UUID: 24c58351812b4bacb9165230d860cf28-20200615
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=nisAnoc7mvlaGA1pizlDXlUzsDkZZeGHJrykO92DJN0=;
        b=S6ajybk2DfDg1YRK3IOl75f0smY0hXt0B/w3F4KOpVO9L/elgTS7eNdz2s0HXSpJv9g8NqnV+4w2iqdKpNXfpZO7wmZWww+hxAw3qIf2OPPdIr4CkBU7J2AqljClttyapA6UGBbN+oejsLM5IMjdtAMi2YmGseP7rhvbuD4ldd4=;
X-UUID: 24c58351812b4bacb9165230d860cf28-20200615
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1383805496; Mon, 15 Jun 2020 22:31:25 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs05n2.mediatek.inc (172.21.101.140) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 15 Jun 2020 22:31:21 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 15 Jun 2020 22:31:22 +0800
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
Subject: [PATCH v1 0/3] scsi: ufs: Export UFS debugging dump for vendors
Date:   Mon, 15 Jun 2020 22:31:20 +0800
Message-ID: <20200615143123.6627-1-stanley.chu@mediatek.com>
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
dXAgaW4gdWZzaGNkX21ha2VfaGJhX29wZXJhdGlvbmFsKCkuDQoNClN0YW5sZXkgQ2h1ICgzKToN
CiAgc2NzaTogdWZzOiBSZW1vdmUgcmVkdW5kYW50IGxhYmVsICJvdXQiIGluDQogICAgdWZzaGNk
X21ha2VfaGJhX29wZXJhdGlvbmFsKCkNCiAgc2NzaTogdWZzOiBNYW5hZ2UgYW5kIGV4cG9ydCBV
RlMgZGVidWdnaW5nIGluZm9ybWF0aW9uIGR1bXANCiAgc2NzaTogdWZzLW1lZGlhdGVrOiBQcmlu
dCBob3N0IGluZm9ybWF0aW9uIGZvciBmYWlsZWQgc3Vwc2VuZCBhbmQNCiAgICByZXN1bWUNCg0K
IGRyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMgfCAxNiArKysrKysrLS0tLQ0KIGRyaXZl
cnMvc2NzaS91ZnMvdWZzaGNkLmMgICAgICAgfCA1MSArKysrKysrKysrKysrKysrKysrLS0tLS0t
LS0tLS0tLS0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oICAgICAgIHwgIDggKysrKysrDQog
MyBmaWxlcyBjaGFuZ2VkLCA0OCBpbnNlcnRpb25zKCspLCAyNyBkZWxldGlvbnMoLSkNCg0KLS0g
DQoyLjE4LjANCg==

