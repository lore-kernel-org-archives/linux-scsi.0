Return-Path: <SRS0=3W2l=CX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 307E4C2BC11
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Sep 2020 05:01:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3F40217BA
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Sep 2020 05:01:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="vErOI+JR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbgINFBT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Sep 2020 01:01:19 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:11768 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725996AbgINFBI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Sep 2020 01:01:08 -0400
X-UUID: 47c549bb81f4499d81b64f801e431f63-20200914
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=/mYD66patFgq7ha/cJhn7mSkoKmWOdFvvY0fkbfVMfM=;
        b=vErOI+JRIK7eqRGBe7E4IfHCmiM/hAOa0oDV3CYkqaGX7vFIJRgjCvDUBpxwAYBXFdsWBBuPD8W0eL3UVrhy0AW1vOIAtdd1dKwPuKsdao48JMj18o3BlUq6ySqcG7cGIgaog+huWZhu3zoPCkjk7R3ROMg41JteM2ncHJ+2xyY=;
X-UUID: 47c549bb81f4499d81b64f801e431f63-20200914
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1937689054; Mon, 14 Sep 2020 13:00:56 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 14 Sep 2020 13:00:53 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 14 Sep 2020 13:00:54 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <robh+dt@kernel.org>, <robh@kernel.org>, <mark.rutland@arm.com>,
        <chunfeng.yun@mediatek.com>, <yingjoe.chen@mediatek.com>,
        <kishon@ti.com>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <pedrom.sousa@synopsys.com>
CC:     <vivek.gautam@codeaurora.org>, <liwei213@huawei.com>,
        <linux-mediatek@lists.infradead.org>, <matthias.bgg@gmail.com>,
        <kuohong.wang@mediatek.com>, <peter.wang@mediatek.com>,
        <chun-hung.wu@mediatek.com>, <andy.teng@mediatek.com>,
        <chaotian.jing@mediatek.com>, <cc.chou@mediatek.com>,
        <jiajie.hao@mediatek.com>, <arvin.wang@mediatek.com>,
        <henryc.chen@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v3 2/2] dt-bindings: ufs-mediatek: Add mt8192-ufshci compatible string
Date:   Mon, 14 Sep 2020 13:00:52 +0800
Message-ID: <20200914050052.3974-3-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200914050052.3974-1-stanley.chu@mediatek.com>
References: <20200914050052.3974-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
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

