Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 486FDC433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 07:01:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26A9F206D4
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 07:01:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="noBLcc+J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbgG2HBD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 03:01:03 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:52267 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726314AbgG2HBC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jul 2020 03:01:02 -0400
X-UUID: a131defefa254890b22a2b39d581cb53-20200729
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=q5ldSUPNgQ68Q35WAqjWkWypxVf1COme3q/I/kw3nEY=;
        b=noBLcc+JLDU8aEnadp7afUkBhGKCJMbvpWrgm7CgjoD22tLskUREy55QqQqdCsSp2Yv3pb9Ik2g7EFCIL8LA60+EbZSNnyaQleaRhyhT/e3FVo1plBAV7xyP8tvx9+aLKSIV/lD8i7/6XP/UmJDOr0Zgvphg+2TmgvnaQFEEboY=;
X-UUID: a131defefa254890b22a2b39d581cb53-20200729
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1352443270; Wed, 29 Jul 2020 15:00:56 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 29 Jul 2020 15:00:54 +0800
Received: from [172.21.77.33] (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 29 Jul 2020 15:00:51 +0800
Message-ID: <1596006055.17247.7.camel@mtkswgap22>
Subject: Re: [PATCH v7 4/8] scsi: ufs: Add some debug infos to
 ufshcd_print_host_state
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Can Guo <cang@codeaurora.org>
CC:     "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "hongwus@codeaurora.org" <hongwus@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "sh425.lee@samsung.com" <sh425.lee@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>,
        "Alim Akhtar" <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        "Bart Van Assche" <bvanassche@acm.org>,
        Satya Tangirala <satyat@google.com>,
        "open list" <linux-kernel@vger.kernel.org>
Date:   Wed, 29 Jul 2020 15:00:55 +0800
In-Reply-To: <1595912460-8860-5-git-send-email-cang@codeaurora.org>
References: <1595912460-8860-1-git-send-email-cang@codeaurora.org>
         <1595912460-8860-5-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gVHVlLCAyMDIwLTA3LTI4IGF0IDEzOjAwICswODAwLCBDYW4gR3VvIHdyb3RlOg0KPiBUaGUg
aW5mb3Mgb2YgdGhlIGxhc3QgaW50ZXJydXB0IHN0YXR1cyBhbmQgaXRzIHRpbWVzdGFtcCBhcmUg
dmVyeSBoZWxwZnVsDQo+IHdoZW4gZGVidWcgc3lzdGVtIHN0YWJpbGl0eSBpc3N1ZXMsIGUuZy4g
SVJRIHN0YXJ2YXRpb24sIHNvIGFkZCB0aGVtIHRvDQo+IHVmc2hjZF9wcmludF9ob3N0X3N0YXRl
LiBNZWFud2hpbGUsIFVGUyBkZXZpY2UgaW5mb3MgbGlrZSBtb2RlbCBuYW1lIGFuZA0KPiBpdHMg
RlcgdmVyc2lvbiBhbHNvIGNvbWUgaW4gaGFuZHkgZHVyaW5nIGRlYnVnLiBJbiBhZGRpdGlvbiwg
dGhpcyBjaGFuZ2UNCj4gbWFrZXMgY2xlYW51cCB0byBzb21lIHByaW50cyBpbiB1ZnNoY2RfcHJp
bnRfaG9zdF9yZWdzIGFzIHNpbWlsYXIgcHJpbnRzDQo+IGFyZSBhbHJlYWR5IGF2YWlsYWJsZSBp
biB1ZnNoY2RfcHJpbnRfaG9zdF9zdGF0ZS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IENhbiBHdW8g
PGNhbmdAY29kZWF1cm9yYS5vcmc+DQo+IFJldmlld2VkLWJ5OiBBdnJpIEFsdG1hbiA8YXZyaS5h
bHRtYW5Ad2RjLmNvbT4NCg0KUmV2aWV3ZWQtYnk6IFN0YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBt
ZWRpYXRlay5jb20+DQoNCg==

