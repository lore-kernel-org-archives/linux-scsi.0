Return-Path: <SRS0=ZPSI=2K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AF71C43603
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 08:37:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DE6E24680
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 08:37:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="tRAaeaKF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbfLTIgk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Dec 2019 03:36:40 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:19551 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726651AbfLTIgk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Dec 2019 03:36:40 -0500
X-UUID: 486b4763ae8f46d19ef5196867a99f4e-20191220
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=12E3/w0zLzo1lHYmnmqiu5tF62G08uQTQTzZ3/Kf2H4=;
        b=tRAaeaKFYWIg559X/Tg4dmJjeXBnzdD9rFLx8t+bS1unU2nCsIrJnV/Z9aRrNY41EhT7r3UZ23VwEsGwpk7/DEE2fDXSzZA74nRFU1aWzuhpK/jPYz9IXUr4UoCXmGB3UnhMxqJS328gaZtdI1TjtWxM4LPZO+lGAXDETxvKWEE=;
X-UUID: 486b4763ae8f46d19ef5196867a99f4e-20191220
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 2047778073; Fri, 20 Dec 2019 16:36:34 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 20 Dec 2019 16:35:58 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 20 Dec 2019 16:35:38 +0800
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
Subject: [PATCH v1 1/6] soc: mediatek: add header for SiP service interface
Date:   Fri, 20 Dec 2019 16:36:23 +0800
Message-ID: <1576830988-22435-2-git-send-email-stanley.chu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1576830988-22435-1-git-send-email-stanley.chu@mediatek.com>
References: <1576830988-22435-1-git-send-email-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 1B5F7BFC16B0E8191AE28A1FFB78843557E482DF05CE81504A7CB1D2CDB00ED22000:8
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
a19zaXBfc3ZjLmggfCAyOSArKysrKysrKysrKysrKysrKysrKysrKysNCiAxIGZpbGUgY2hhbmdl
ZCwgMjkgaW5zZXJ0aW9ucygrKQ0KIGNyZWF0ZSBtb2RlIDEwMDY0NCBpbmNsdWRlL2xpbnV4L3Nv
Yy9tZWRpYXRlay9tdGtfc2lwX3N2Yy5oDQoNCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L3Nv
Yy9tZWRpYXRlay9tdGtfc2lwX3N2Yy5oIGIvaW5jbHVkZS9saW51eC9zb2MvbWVkaWF0ZWsvbXRr
X3NpcF9zdmMuaA0KbmV3IGZpbGUgbW9kZSAxMDA2NDQNCmluZGV4IDAwMDAwMDAwMDAwMC4uOTcz
MTE5NTlkN2Q3DQotLS0gL2Rldi9udWxsDQorKysgYi9pbmNsdWRlL2xpbnV4L3NvYy9tZWRpYXRl
ay9tdGtfc2lwX3N2Yy5oDQpAQCAtMCwwICsxLDI5IEBADQorLyogU1BEWC1MaWNlbnNlLUlkZW50
aWZpZXI6IEdQTC0yLjAgKi8NCisvKg0KKyAqIENvcHlyaWdodCAoQykgMjAxOSBNZWRpYVRlayBJ
bmMuDQorICovDQorI2lmbmRlZiBfX01US19TSVBfU1ZDX0gNCisjZGVmaW5lIF9fTVRLX1NJUF9T
VkNfSA0KKw0KKy8qIEVycm9yIENvZGUgKi8NCisjZGVmaW5lIFNJUF9TVkNfRV9TVUNDRVNTICAg
ICAgICAgICAgICAgMA0KKyNkZWZpbmUgU0lQX1NWQ19FX05PVF9TVVBQT1JURUQgICAgICAgICAt
MQ0KKyNkZWZpbmUgU0lQX1NWQ19FX0lOVkFMSURfUEFSQU1TICAgICAgICAtMg0KKyNkZWZpbmUg
U0lQX1NWQ19FX0lOVkFMSURfUkFOR0UgICAgICAgICAtMw0KKyNkZWZpbmUgU0lQX1NWQ19FX1BF
Uk1JU1NJT05fREVOSUVEICAgICAtNA0KKw0KKyNpZmRlZiBDT05GSUdfQVJNNjQNCisjZGVmaW5l
IE1US19TSVBfU01DX0NPTlZFTlRJT04gICAgICAgICAgQVJNX1NNQ0NDX1NNQ182NA0KKyNlbHNl
DQorI2RlZmluZSBNVEtfU0lQX1NNQ19DT05WRU5USU9OICAgICAgICAgIEFSTV9TTUNDQ19TTUNf
MzINCisjZW5kaWYNCisNCisjZGVmaW5lIE1US19TSVBfU01DX0NNRChmbl9pZCkgXA0KKwlBUk1f
U01DQ0NfQ0FMTF9WQUwoQVJNX1NNQ0NDX0ZBU1RfQ0FMTCwgTVRLX1NJUF9TTUNfQ09OVkVOVElP
TiwgXA0KKwkJCSAgIEFSTV9TTUNDQ19PV05FUl9TSVAsIGZuX2lkKQ0KKw0KKy8qIFVGUyByZWxh
dGVkIFNNQyBjYWxsICovDQorI2RlZmluZSBNVEtfU0lQX1VGU19DT05UUk9MIFwNCisJTVRLX1NJ
UF9TTUNfQ01EKDB4Mjc2KQ0KKw0KKyNlbmRpZg0KLS0gDQoyLjE4LjANCg==

