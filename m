Return-Path: <SRS0=TzWF=Z5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB9CDC2D0C3
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Dec 2019 06:39:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CA9824680
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Dec 2019 06:39:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="dFQTnbuk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfLGGjW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 7 Dec 2019 01:39:22 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:39603 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725978AbfLGGjV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Dec 2019 01:39:21 -0500
X-UUID: 202a1b9ab8a94936b724c02845a026f3-20191207
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=qz9simjY54XSvDI25tNlpRELcfVBXCKb+vRfUEdSjks=;
        b=dFQTnbukODvJ272L2Xev50buLt/kQadssaH6YaHKPGQMKrdOMrZr4WNhc2grZoWy6XEWWenQsNJF6AyNleVL0LnVsjnf6pgraHf/fLQ0PtW8XQ+AV6xe7Sqw2va2ovBYrO/9a5weOgOOAZkjtPyctD4RLSpfeycKkRXpPIIoeSQ=;
X-UUID: 202a1b9ab8a94936b724c02845a026f3-20191207
Received: from mtkmrs01.mediatek.inc [(172.21.131.159)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1401057786; Sat, 07 Dec 2019 14:39:11 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Sat, 7 Dec 2019 14:38:50 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Sat, 7 Dec 2019 14:38:44 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <pedrom.sousa@synopsys.com>, <jejb@linux.ibm.com>,
        <matthias.bgg@gmail.com>
CC:     <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <beanhuo@micron.com>,
        <kuohong.wang@mediatek.com>, <peter.wang@mediatek.com>,
        <chun-hung.wu@mediatek.com>, <andy.teng@mediatek.com>,
        <leon.chen@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v1 1/2] soc: mediatek: add header for SiP service interface
Date:   Sat, 7 Dec 2019 14:39:07 +0800
Message-ID: <1575700748-28191-2-git-send-email-stanley.chu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1575700748-28191-1-git-send-email-stanley.chu@mediatek.com>
References: <1575700748-28191-1-git-send-email-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

QWRkIGEgaGVhZGVyIGZvciB0aGUgU2lQIHNlcnZpY2UgaW50ZXJmYWNlIGRlZmluZWQgdG8gYWNj
ZXNzDQp0aGUgVUZTSENJIGNvbnRyb2xsZXIgaGFuZGxpbmcgc2VjdXJlIGNvbW1hbmRzIGluIE1l
ZGlhVGVrIENoaXBzZXRzLg0KDQpTaWduZWQtb2ZmLWJ5OiBTdGFubGV5IENodSA8c3RhbmxleS5j
aHVAbWVkaWF0ZWsuY29tPg0KLS0tDQogaW5jbHVkZS9saW51eC9zb2MvbWVkaWF0ZWsvbXRrX3Np
cF9zdmMuaCB8IDI2ICsrKysrKysrKysrKysrKysrKysrKysrKw0KIDEgZmlsZSBjaGFuZ2VkLCAy
NiBpbnNlcnRpb25zKCspDQogY3JlYXRlIG1vZGUgMTAwNjQ0IGluY2x1ZGUvbGludXgvc29jL21l
ZGlhdGVrL210a19zaXBfc3ZjLmgNCg0KZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvc29jL21l
ZGlhdGVrL210a19zaXBfc3ZjLmggYi9pbmNsdWRlL2xpbnV4L3NvYy9tZWRpYXRlay9tdGtfc2lw
X3N2Yy5oDQpuZXcgZmlsZSBtb2RlIDEwMDY0NA0KaW5kZXggMDAwMDAwMDAwMDAwLi43YjY5YWEw
NmY1OGQNCi0tLSAvZGV2L251bGwNCisrKyBiL2luY2x1ZGUvbGludXgvc29jL21lZGlhdGVrL210
a19zaXBfc3ZjLmgNCkBAIC0wLDAgKzEsMjYgQEANCisvKiBTUERYLUxpY2Vuc2UtSWRlbnRpZmll
cjogR1BMLTIuMCAqLw0KKy8qDQorICogQ29weXJpZ2h0IChDKSAyMDE5IE1lZGlhVGVrIEluYy4N
CisgKi8NCisNCisjaWZuZGVmIF9fTVRLX1NJUF9TVkNfSA0KKyNkZWZpbmUgX19NVEtfU0lQX1NW
Q19IDQorDQorLyogRXJyb3IgQ29kZSAqLw0KKyNkZWZpbmUgU0lQX1NWQ19FX1NVQ0NFU1MgICAg
ICAgICAgICAgICAwDQorI2RlZmluZSBTSVBfU1ZDX0VfTk9UX1NVUFBPUlRFRCAgICAgICAgIC0x
DQorI2RlZmluZSBTSVBfU1ZDX0VfSU5WQUxJRF9QQVJBTVMgICAgICAgIC0yDQorI2RlZmluZSBT
SVBfU1ZDX0VfSU5WQUxJRF9SQU5HRSAgICAgICAgIC0zDQorI2RlZmluZSBTSVBfU1ZDX0VfUEVS
TUlTU0lPTl9ERU5JRUQgICAgIC00DQorDQorI2lmZGVmIENPTkZJR19BUk02NA0KKyNkZWZpbmUg
TVRLX1NJUF9TTUNfQUFSQ0hfQklUICAgICAgICAgICAweDQwMDAwMDAwDQorI2Vsc2UNCisjZGVm
aW5lIE1US19TSVBfU01DX0FBUkNIX0JJVCAgICAgICAgICAgMHgwMDAwMDAwMA0KKyNlbmRpZg0K
Kw0KKy8qIFVGUyByZWxhdGVkIFNNQyBjYWxsICovDQorI2RlZmluZSBNVEtfU0lQX1VGU19DT05U
Uk9MIFwNCisJKDB4ODIwMDAyNzYgfCBNVEtfU0lQX1NNQ19BQVJDSF9CSVQpDQorDQorI2VuZGlm
DQotLSANCjIuMTguMA0K

