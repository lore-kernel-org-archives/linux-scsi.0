Return-Path: <SRS0=UMfj=7Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B172BC433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Jun 2020 15:10:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DF0B20838
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Jun 2020 15:10:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="nxDS8YNj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbgFLPKM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Jun 2020 11:10:12 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:44902 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726361AbgFLPKM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Jun 2020 11:10:12 -0400
X-UUID: 5b40850d71ee4948ab30841009a1dcad-20200612
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=FhlTOagA00bCQ3L5jvPszIOhSoVmzjOeACRwX600eCw=;
        b=nxDS8YNjbuEE5nE3jh8aKWHzeTZg0ENxNnTd4fNzFVRaz9KH7EoXW1sejF7+VIR0TORneSOJbqx4r5sKzgfG27m9JFPeGZneIgZXsNUNVv3tHXAvLhjBQXB+thPdHT6/tdnH52iIDSmw4MKPr+fHbSvUUvccFv+QLQ/Xo7tjdsE=;
X-UUID: 5b40850d71ee4948ab30841009a1dcad-20200612
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1127766091; Fri, 12 Jun 2020 23:10:07 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 12 Jun 2020 23:10:02 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 12 Jun 2020 23:10:01 +0800
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
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v1 1/2] scsi: ufs: Remove unused field in struct uic_command
Date:   Fri, 12 Jun 2020 23:09:59 +0800
Message-ID: <20200612151000.27639-2-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200612151000.27639-1-stanley.chu@mediatek.com>
References: <20200612151000.27639-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 1AC755333E14547879D60C82DC18A2B1EE8A90CB7AA0E8DCB830A8B739C76C1F2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UmVtb3ZlIHVudXNlZCBmaWVsZCAiY21kX2FjdGl2ZSIgaW4gc3RydWN0IHVmc19jb21tYW5kLg0K
DQpTaWduZWQtb2ZmLWJ5OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0K
LS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaCB8IDIgLS0NCiAxIGZpbGUgY2hhbmdlZCwg
MiBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmgg
Yi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oDQppbmRleCBiZjk3ZDYxNmU1OTcuLjgxNGU0NDg3
MWZmMCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmgNCisrKyBiL2RyaXZl
cnMvc2NzaS91ZnMvdWZzaGNkLmgNCkBAIC04OCw3ICs4OCw2IEBAIGVudW0gZGV2X2NtZF90eXBl
IHsNCiAgKiBAYXJndW1lbnQxOiBVSUMgY29tbWFuZCBhcmd1bWVudCAxDQogICogQGFyZ3VtZW50
MjogVUlDIGNvbW1hbmQgYXJndW1lbnQgMg0KICAqIEBhcmd1bWVudDM6IFVJQyBjb21tYW5kIGFy
Z3VtZW50IDMNCi0gKiBAY21kX2FjdGl2ZTogSW5kaWNhdGUgaWYgVUlDIGNvbW1hbmQgaXMgb3V0
c3RhbmRpbmcNCiAgKiBAcmVzdWx0OiBVSUMgY29tbWFuZCByZXN1bHQNCiAgKiBAZG9uZTogVUlD
IGNvbW1hbmQgY29tcGxldGlvbg0KICAqLw0KQEAgLTk3LDcgKzk2LDYgQEAgc3RydWN0IHVpY19j
b21tYW5kIHsNCiAJdTMyIGFyZ3VtZW50MTsNCiAJdTMyIGFyZ3VtZW50MjsNCiAJdTMyIGFyZ3Vt
ZW50MzsNCi0JaW50IGNtZF9hY3RpdmU7DQogCWludCByZXN1bHQ7DQogCXN0cnVjdCBjb21wbGV0
aW9uIGRvbmU7DQogfTsNCi0tIA0KMi4xOC4wDQo=

