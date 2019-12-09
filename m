Return-Path: <SRS0=QSh0=Z7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33326C43603
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 08:29:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 068CA20726
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 08:29:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Zy5ddd2V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727213AbfLII31 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Dec 2019 03:29:27 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:43984 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726377AbfLII30 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Dec 2019 03:29:26 -0500
X-UUID: 9a5254a25154471da3765943abfdd9c2-20191209
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=PobjKoCgXRNn990HIlJZTubi4uiFA7wzU79j4/Le0Bk=;
        b=Zy5ddd2VHcyHhNuqA1B03JfCjdZM9g8ATySnJem1CmJrLkHY1EnJw5MrubGchT5J8tMWc+kLPU3Vvae+uluoRuE7YFrTv/eLabUrvhjAMmOiDFebOSXhgWPZauwETo5BXxrWegVPclXfvYki5yIxd77hfV64B5CBDWoVkqgwLiw=;
X-UUID: 9a5254a25154471da3765943abfdd9c2-20191209
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 212246112; Mon, 09 Dec 2019 16:29:18 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 9 Dec 2019 16:28:52 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 9 Dec 2019 16:29:00 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <pedrom.sousa@synopsys.com>, <jejb@linux.ibm.com>,
        <matthias.bgg@gmail.com>, <f.fainelli@gmail.com>
CC:     <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <beanhuo@micron.com>,
        <kuohong.wang@mediatek.com>, <peter.wang@mediatek.com>,
        <chun-hung.wu@mediatek.com>, <andy.teng@mediatek.com>,
        <leon.chen@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v2 1/2] soc: mediatek: add header for SiP service interface
Date:   Mon, 9 Dec 2019 16:29:13 +0800
Message-ID: <1575880154-6099-2-git-send-email-stanley.chu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1575880154-6099-1-git-send-email-stanley.chu@mediatek.com>
References: <1575880154-6099-1-git-send-email-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 1C9D4BFB12BEAF2AA31D11178215C377E0379A3988D3D52318AB1548C0C1868E2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

QWRkIGEgaGVhZGVyIGZvciB0aGUgU2lQIHNlcnZpY2UgaW50ZXJmYWNlIGluIG9yZGVyIHRvIGFj
Y2Vzcw0KdGhlIFVGU0hDSSBjb250cm9sbGVyIGZvciBzZWN1cmUgY29tbWFuZCBoYW5kbGluZyBp
biBNZWRpYVRlayBDaGlwc2V0cy4NCg0KU2lnbmVkLW9mZi1ieTogU3RhbmxleSBDaHUgPHN0YW5s
ZXkuY2h1QG1lZGlhdGVrLmNvbT4NCi0tLQ0KIGluY2x1ZGUvbGludXgvc29jL21lZGlhdGVrL210
a19zaXBfc3ZjLmggfCAzMCArKysrKysrKysrKysrKysrKysrKysrKysNCiAxIGZpbGUgY2hhbmdl
ZCwgMzAgaW5zZXJ0aW9ucygrKQ0KIGNyZWF0ZSBtb2RlIDEwMDY0NCBpbmNsdWRlL2xpbnV4L3Nv
Yy9tZWRpYXRlay9tdGtfc2lwX3N2Yy5oDQoNCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L3Nv
Yy9tZWRpYXRlay9tdGtfc2lwX3N2Yy5oIGIvaW5jbHVkZS9saW51eC9zb2MvbWVkaWF0ZWsvbXRr
X3NpcF9zdmMuaA0KbmV3IGZpbGUgbW9kZSAxMDA2NDQNCmluZGV4IDAwMDAwMDAwMDAwMC4uM2Q3
MjVmY2RkNWJhDQotLS0gL2Rldi9udWxsDQorKysgYi9pbmNsdWRlL2xpbnV4L3NvYy9tZWRpYXRl
ay9tdGtfc2lwX3N2Yy5oDQpAQCAtMCwwICsxLDMwIEBADQorLyogU1BEWC1MaWNlbnNlLUlkZW50
aWZpZXI6IEdQTC0yLjAgKi8NCisvKg0KKyAqIENvcHlyaWdodCAoQykgMjAxOSBNZWRpYVRlayBJ
bmMuDQorICovDQorDQorI2lmbmRlZiBfX01US19TSVBfU1ZDX0gNCisjZGVmaW5lIF9fTVRLX1NJ
UF9TVkNfSA0KKw0KKy8qIEVycm9yIENvZGUgKi8NCisjZGVmaW5lIFNJUF9TVkNfRV9TVUNDRVNT
ICAgICAgICAgICAgICAgMA0KKyNkZWZpbmUgU0lQX1NWQ19FX05PVF9TVVBQT1JURUQgICAgICAg
ICAtMQ0KKyNkZWZpbmUgU0lQX1NWQ19FX0lOVkFMSURfUEFSQU1TICAgICAgICAtMg0KKyNkZWZp
bmUgU0lQX1NWQ19FX0lOVkFMSURfUkFOR0UgICAgICAgICAtMw0KKyNkZWZpbmUgU0lQX1NWQ19F
X1BFUk1JU1NJT05fREVOSUVEICAgICAtNA0KKw0KKyNpZmRlZiBDT05GSUdfQVJNNjQNCisjZGVm
aW5lIE1US19TSVBfU01DX0NPTlZFTlRJT04gICAgICAgICAgQVJNX1NNQ0NDX1NNQ182NA0KKyNl
bHNlDQorI2RlZmluZSBNVEtfU0lQX1NNQ19DT05WRU5USU9OICAgICAgICAgIEFSTV9TTUNDQ19T
TUNfMzINCisjZW5kaWYNCisNCisjZGVmaW5lIE1US19TSVBfU01DX0NNRChmbl9pZCkgXA0KKwlB
Uk1fU01DQ0NfQ0FMTF9WQUwoQVJNX1NNQ0NDX0ZBU1RfQ0FMTCwgTVRLX1NJUF9TTUNfQ09OVkVO
VElPTiwgXA0KKwkJCSAgIEFSTV9TTUNDQ19PV05FUl9TSVAsIGZuX2lkKQ0KKw0KKy8qIFVGUyBy
ZWxhdGVkIFNNQyBjYWxsICovDQorI2RlZmluZSBNVEtfU0lQX1VGU19DT05UUk9MIFwNCisJTVRL
X1NJUF9TTUNfQ01EKDB4Mjc2KQ0KKw0KKyNlbmRpZg0KLS0gDQoyLjE4LjANCg==

