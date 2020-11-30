Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5D55C64E7B
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 02:24:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D52420757
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 02:24:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="s2BfSBZ2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbgK3CYL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 29 Nov 2020 21:24:11 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:54438 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725930AbgK3CYL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Nov 2020 21:24:11 -0500
X-UUID: 1c3294f61bce408d98a842f630cf1821-20201130
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=rLpqHqCCCAQr25WgYvxu2aqjED7IxJn7APNLGPsEyJ0=;
        b=s2BfSBZ2IW5sIWPFhPVQispBebrofHSDUeNwUzZyNmKp6mZ5mM+JlhkM6feDt096lDT76qNgAaK+mj6ijY+e29MYiM2IvmAASpmGStfRzN8Hwb1eOMhivSM/cpzO5+WT64Aw0HpIx7oIi/mjo9BPMQMq4Kr6M4vTJZIXPrfe41M=;
X-UUID: 1c3294f61bce408d98a842f630cf1821-20201130
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1878706904; Mon, 30 Nov 2020 10:23:24 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs01n1.mediatek.inc (172.21.101.68) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 30 Nov 2020 10:23:16 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 30 Nov 2020 10:23:19 +0800
Message-ID: <1606703001.23925.4.camel@mtkswgap22>
Subject: Re: [PATCH 1/1] scsi: ufs: Remove scale down gear hard code
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Can Guo <cang@codeaurora.org>
CC:     <asutoshd@codeaurora.org>, <nguyenb@codeaurora.org>,
        <hongwus@codeaurora.org>, <rnayak@codeaurora.org>,
        <linux-scsi@vger.kernel.org>, <kernel-team@android.com>,
        <saravanak@google.com>, <salyzyn@google.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        "Bart Van Assche" <bvanassche@acm.org>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
Date:   Mon, 30 Nov 2020 10:23:21 +0800
In-Reply-To: <1606442334-22641-1-git-send-email-cang@codeaurora.org>
References: <1606442334-22641-1-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gVGh1LCAyMDIwLTExLTI2IGF0IDE3OjU4IC0wODAwLCBDYW4gR3VvIHdyb3RlOg0KPiBJbnN0
ZWFkIG9mIG1ha2luZyB0aGUgc2NhbGUgZG93biBnZWFyIGEgaGFyZCBjb2RlLCBtYWtlIGl0IGEg
bWVtYmVyIG9mDQo+IHVmc19jbGtfc2NhbGluZyBzdHJ1Y3QuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5
OiBDYW4gR3VvIDxjYW5nQGNvZGVhdXJvcmEub3JnPg0KDQpSZXZpZXdlZC1ieTogU3RhbmxleSBD
aHUgPHN0YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NCg0KDQo=

