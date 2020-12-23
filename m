Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E34E1C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Dec 2020 09:32:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E942207CF
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Dec 2020 09:32:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728312AbgLWJcg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Dec 2020 04:32:36 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:49007 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728157AbgLWJcf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Dec 2020 04:32:35 -0500
X-UUID: d7ce91a0a6804571a8c8bde62525667d-20201223
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=RruyHoJfjGpz9Y/Cv318TBTbT30be6zBjjgXRAhJhGQ=;
        b=XXSV0t6GI0B9ua/a+Nu5gFzIriCEMmVPgGrWlJLtJwmSCvwNunzpwHBeK6mj/U+7el5fVSha39I4GWqOx7IlbJJha1e6CubkYCtQqEYGCRzN8TIw+p+B3rSmZGVXT+EEdGYw05H41p2T6TXigbnnnKEgFaBiAFHaIv40vYMiBjw=;
X-UUID: d7ce91a0a6804571a8c8bde62525667d-20201223
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1879916761; Wed, 23 Dec 2020 17:31:51 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs06n1.mediatek.inc (172.21.101.129) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 23 Dec 2020 17:31:51 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 23 Dec 2020 17:31:50 +0800
Message-ID: <1608715910.14045.6.camel@mtkswgap22>
Subject: Re: [PATCH v4 1/2] ufs: add a vops to configure block parameter
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Kiwoong Kim <kwmad.kim@samsung.com>
CC:     <linux-scsi@vger.kernel.org>, <alim.akhtar@samsung.com>,
        <avri.altman@wdc.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <beanhuo@micron.com>,
        <asutoshd@codeaurora.org>, <cang@codeaurora.org>,
        <bvanassche@acm.org>, <grant.jung@samsung.com>,
        <sc.suh@samsung.com>, <hy50.seo@samsung.com>,
        <sh425.lee@samsung.com>, <bhoon95.kim@samsung.com>
Date:   Wed, 23 Dec 2020 17:31:50 +0800
In-Reply-To: <d937b2a64d597ce969ad3e36419f9814e5e202ae.1608689016.git.kwmad.kim@samsung.com>
References: <cover.1608689016.git.kwmad.kim@samsung.com>
         <CGME20201223021601epcas2p1311bd2ee57014e3b536de5a5ca286f85@epcas2p1.samsung.com>
         <d937b2a64d597ce969ad3e36419f9814e5e202ae.1608689016.git.kwmad.kim@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gV2VkLCAyMDIwLTEyLTIzIGF0IDExOjA1ICswOTAwLCBLaXdvb25nIEtpbSB3cm90ZToNCj4g
VGhlcmUgY291bGQgYmUgc29tZSBjYXNlcyB0byBzZXQgYmxvY2sgcGFyYW1ldGVycw0KPiBwZXIg
aG9zdCwgYmVjYXVzZSBvZiBpdHMgb3duIGRtYSBzdHJ1Y3R1cmUgb3Igd2hhdGV2ZXIuDQo+IA0K
PiBTaWduZWQtb2ZmLWJ5OiBLaXdvb25nIEtpbSA8a3dtYWQua2ltQHNhbXN1bmcuY29tPg0KDQpS
ZXZpZXdlZC1ieTogU3RhbmxleSBDaHUgPHN0YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NCg==

