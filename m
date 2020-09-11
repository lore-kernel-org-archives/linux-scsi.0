Return-Path: <SRS0=m8O6=CU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E87D8C433E2
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Sep 2020 03:38:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B587321D81
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Sep 2020 03:38:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Cv+Gcg9q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725800AbgIKDiN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Sep 2020 23:38:13 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:59431 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725774AbgIKDht (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Sep 2020 23:37:49 -0400
X-UUID: 37f86f7ef02e4ca1a2d72297214d09f2-20200911
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=/mYD66patFgq7ha/cJhn7mSkoKmWOdFvvY0fkbfVMfM=;
        b=Cv+Gcg9qMb1hXk4Px7oFdExxlSU0WCl0Oe9MVzsESHOs9A4Hdf4xS7BF/7jOA0473zywGO8F50aSloN7XRJ/9U9W/XFpgIcTxcNoWN9j/P2prhXNDd4DgTYpDrHrQaclbE2+xhW1hbN9gaG6H9483hdLXDbS9b/UJ8iYlwFzoiQ=;
X-UUID: 37f86f7ef02e4ca1a2d72297214d09f2-20200911
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1128609697; Fri, 11 Sep 2020 11:37:46 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 11 Sep 2020 11:37:37 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 11 Sep 2020 11:37:37 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <robh+dt@kernel.org>, <robh@kernel.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC:     <matthias.bgg@gmail.com>, <bvanassche@acm.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, <arvin.wang@mediatek.com>,
        <HenryC.Chen@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v2 2/2] dt-bindings: ufs-mediatek: Add mt8192-ufshci compatible string
Date:   Fri, 11 Sep 2020 11:37:35 +0800
Message-ID: <20200911033735.21751-3-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200911033735.21751-1-stanley.chu@mediatek.com>
References: <20200911033735.21751-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 0BB81318896B0759360427A59F7D86010AAC42047CB7D2214515CB89FB74033A2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

QWRkICJtZWRpYXRlayxtdDgxOTItdWZzaGNpIiBjb21wYXRpYmxlIHN0cmluZyB0byBmb3IgTWVk
aWFUZWsNClVGUyBob3N0IGNvbnRyb2xsZXIgcHJlc2VudCBvbiBNVDgxOTIgY2hpcHNldHMuDQoN
ClNpZ25lZC1vZmYtYnk6IFN0YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5jb20+DQot
LS0NCiBEb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvdWZzL3Vmcy1tZWRpYXRlay50
eHQgfCA0ICsrKy0NCiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9u
KC0pDQoNCmRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvdWZz
L3Vmcy1tZWRpYXRlay50eHQgYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvdWZz
L3Vmcy1tZWRpYXRlay50eHQNCmluZGV4IDcyYWFiODU0NzMwOC4uNjNhOTUzYjY3MmQyIDEwMDY0
NA0KLS0tIGEvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL3Vmcy91ZnMtbWVkaWF0
ZWsudHh0DQorKysgYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvdWZzL3Vmcy1t
ZWRpYXRlay50eHQNCkBAIC05LDcgKzksOSBAQCBjb250YWluIGEgcGhhbmRsZSByZWZlcmVuY2Ug
dG8gVUZTIE0tUEhZIG5vZGUuDQogUmVxdWlyZWQgcHJvcGVydGllcyBmb3IgVUZTIG5vZGVzOg0K
IC0gY29tcGF0aWJsZSAgICAgICAgIDogQ29tcGF0aWJsZSBsaXN0LCBjb250YWlucyB0aGUgZm9s
bG93aW5nIGNvbnRyb2xsZXI6DQogICAgICAgICAgICAgICAgICAgICAgICAibWVkaWF0ZWssbXQ4
MTgzLXVmc2hjaSIgZm9yIE1lZGlhVGVrIFVGUyBob3N0IGNvbnRyb2xsZXINCi0gICAgICAgICAg
ICAgICAgICAgICAgIHByZXNlbnQgb24gTVQ4MXh4IGNoaXBzZXRzLg0KKyAgICAgICAgICAgICAg
ICAgICAgICAgcHJlc2VudCBvbiBNVDgxODMgY2hpcHNldHMuDQorICAgICAgICAgICAgICAgICAg
ICAgICAibWVkaWF0ZWssbXQ4MTkyLXVmc2hjaSIgZm9yIE1lZGlhVGVrIFVGUyBob3N0IGNvbnRy
b2xsZXINCisgICAgICAgICAgICAgICAgICAgICAgIHByZXNlbnQgb24gTVQ4MTkyIGNoaXBzZXRz
Lg0KIC0gcmVnICAgICAgICAgICAgICAgIDogQWRkcmVzcyBhbmQgbGVuZ3RoIG9mIHRoZSBVRlMg
cmVnaXN0ZXIgc2V0Lg0KIC0gcGh5cyAgICAgICAgICAgICAgIDogcGhhbmRsZSB0byBtLXBoeS4N
CiAtIGNsb2NrcyAgICAgICAgICAgICA6IExpc3Qgb2YgcGhhbmRsZSBhbmQgY2xvY2sgc3BlY2lm
aWVyIHBhaXJzLg0KLS0gDQoyLjE4LjANCg==

