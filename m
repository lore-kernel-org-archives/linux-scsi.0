Return-Path: <SRS0=4aQo=EM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36C0FC5517A
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Nov 2020 06:11:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFFA820867
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Nov 2020 06:11:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="kWF5PMzh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbgKFGLK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Nov 2020 01:11:10 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:55789 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726451AbgKFGLK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Nov 2020 01:11:10 -0500
X-UUID: 856dcf3837364771b9c5b9b1a159b9c2-20201106
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=p5DSa8Nnu7wbNc1hwM5sOPH42DGFe7+JpMveJyzKtq4=;
        b=kWF5PMzh+jNvqReBydVOg+VSfsydUpB0kv2dkmVMLYJ/DxiWcl9CpwQ8A1uKGVeWREMw76Gf5h1SWvZJ/RncPU/40J9P/cZduzsic6wMBsLr/S8kpZS0Q2uEFAg3OaQkvpCnhjIwYU54q+GuXhXEZM/1ALS1DaG+hK4Choyh8oE=;
X-UUID: 856dcf3837364771b9c5b9b1a159b9c2-20201106
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 874927008; Fri, 06 Nov 2020 14:11:00 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 6 Nov 2020 14:10:58 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 6 Nov 2020 14:10:58 +0800
Message-ID: <1604643059.13152.19.camel@mtkswgap22>
Subject: Re: [PATCH v1 0/6] scsi: ufs: Add some proprietary features in
 MediaTek UFS platforms
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>,
        <matthias.bgg@gmail.com>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, <jiajie.hao@mediatek.com>,
        <alice.chao@mediatek.com>
Date:   Fri, 6 Nov 2020 14:10:59 +0800
In-Reply-To: <20201029115750.24391-1-stanley.chu@mediatek.com>
References: <20201029115750.24391-1-stanley.chu@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgTWFydGluLCBBdnJpLA0KDQpPbiBUaHUsIDIwMjAtMTAtMjkgYXQgMTk6NTcgKzA4MDAsIFN0
YW5sZXkgQ2h1IHdyb3RlOg0KPiBIaSwNCj4gDQo+IFRoaXMgcGF0Y2ggc2VyaWVzIHByb3ZpZGVz
IHNvbWUgZmVhdHVyZXMgYW5kIGZpeGVzIGluIE1lZGlhVGVrIFVGUyBwbGF0Zm9ybXMsDQoNClNv
cnJ5IGZvciB0aGUgZ2VudGxlIHBpbmcuIEp1c3QgcGxlYXNlIGNvbnNpZGVyIHRoaXMgcGF0Y2gg
c2VyaWVzIGZvcg0KbWVyZ2luZyB0byBrZXJuZWwgdmVyc2lvbiA1LjExLg0KDQpUaGFua3MsDQpT
dGFubGV5IENodS4NCg0KPiANCj4gMS4gU3VwcG9ydCBWQTA5IHJlZ3VsYXRvciBvcGVyYXRpb25z
DQo+IDIuIFN1cHBvcnQgb3B0aW9uIHRvIGRpc2FibGUgYXV0by1oaWJlcm44DQo+IDMuIFN1cHBv
cnQgSFMtRzQNCj4gNC4gRGVjb3VwbGUgZmVhdHVyZXMgZnJvbSBwbGF0Zm9ybSBiaW5kaW5ncw0K
PiA1LiBNaXNjIGZpeGVzDQo+IA0KPiBTdGFubGV5IENodSAoNik6DQo+ICAgc2NzaTogdWZzLW1l
ZGlhdGVrOiBBc3NpZ24gYXJndW1lbnRzIHdpdGggY29ycmVjdCB0eXBlDQo+ICAgc2NzaTogdWZz
LW1lZGlhdGVrOiBTdXBwb3J0IFZBMDkgcmVndWxhdG9yIG9wZXJhdGlvbnMNCj4gICBzY3NpOiB1
ZnMtbWVkaWF0ZWs6IERlY291cGxlIGZlYXR1cmVzIGZyb20gcGxhdGZvcm0gYmluZGluZ3MNCj4g
ICBzY3NpOiB1ZnMtbWVkaWF0ZWs6IFN1cHBvcnQgb3B0aW9uIHRvIGRpc2FibGUgYXV0by1oaWJl
cm44DQo+ICAgc2NzaTogdWZzOiBBZGQgZW51bXMgZm9yIFVuaVBybyB2ZXJzaW9uIGhpZ2hlciB0
aGFuIDEuNg0KPiAgIHNjc2k6IHVmcy1tZWRpYXRlazogQWRkIEhTLUc0IHN1cHBvcnQNCj4gDQo+
ICBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5jIHwgMjE4ICsrKysrKysrKysrKysrKysr
KysrKysrLS0tLS0tLS0tDQo+ICBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay5oIHwgIDIy
ICsrLS0NCj4gIGRyaXZlcnMvc2NzaS91ZnMvdW5pcHJvLmggICAgICAgfCAgIDYgKy0NCj4gIDMg
ZmlsZXMgY2hhbmdlZCwgMTc5IGluc2VydGlvbnMoKyksIDY3IGRlbGV0aW9ucygtKQ0KPiANCg0K

