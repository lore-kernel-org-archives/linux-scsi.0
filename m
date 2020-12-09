Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BFC0C4361B
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 08:23:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD7B823B97
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 08:23:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbgLIIXM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Dec 2020 03:23:12 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:37611 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726253AbgLIIXM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2020 03:23:12 -0500
X-UUID: 5cbf7747fc934a73b9dccfafea129beb-20201209
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=tZQgclW7QtXGrfoKik3mkK/gxZ2Tg8scqcXCmVvIFJ0=;
        b=Dc4ejFaoTxbMHcV0vefC1/HaqdU1fbqcMvlIiSGRhl3/vvbuYI8L7nE1cqWEo/v9LfiAFkUS/0V5ZB3ykI9kPszYoLFYuNAfQ3NxdAVKEheLAzClWW/6FLsNqN7yo0Yt6gA8Ola3iZXWFEq7oryHtK3PKNvVjLkCWoB+ybDnJ+4=;
X-UUID: 5cbf7747fc934a73b9dccfafea129beb-20201209
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 364962277; Wed, 09 Dec 2020 16:22:28 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by mtkexhb02.mediatek.inc
 (172.21.101.103) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 9 Dec
 2020 16:22:27 +0800
Received: from [172.21.77.33] (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 9 Dec 2020 16:22:27 +0800
Message-ID: <1607502147.3580.33.camel@mtkswgap22>
Subject: Re: [PATCH v1 2/2] scsi: ufs: Clean up some lines from
 ufshcd_hba_exit()
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Can Guo <cang@codeaurora.org>
CC:     <asutoshd@codeaurora.org>, <nguyenb@codeaurora.org>,
        <hongwus@codeaurora.org>, <rnayak@codeaurora.org>,
        <linux-scsi@vger.kernel.org>, <kernel-team@android.com>,
        <saravanak@google.com>, <salyzyn@google.com>,
        "Alim Akhtar" <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        "Bart Van Assche" <bvanassche@acm.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Wed, 9 Dec 2020 16:22:27 +0800
In-Reply-To: <1607497100-27570-3-git-send-email-cang@codeaurora.org>
References: <1607497100-27570-1-git-send-email-cang@codeaurora.org>
         <1607497100-27570-3-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQ2FuLA0KDQpPbiBUdWUsIDIwMjAtMTItMDggYXQgMjI6NTggLTA4MDAsIENhbiBHdW8gd3Jv
dGU6DQo+IHVmc2hjZF9oYmFfZXhpdCgpIGlzIGFsd2F5cyBjYWxsZWQgYWZ0ZXIgdWZzaGNkX2V4
aXRfY2xrX3NjYWxpbmcoKSBhbmQNCj4gdWZzaGNkX2V4aXRfY2xrX2dhdGluZygpLCBzbyBubyBu
ZWVkIHRvIHN1c3BlbmQgY2xvY2sgc2NhbGluZyBhZ2FpbiBpbg0KPiB1ZnNoY2RfaGJhX2V4aXQo
KS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IENhbiBHdW8gPGNhbmdAY29kZWF1cm9yYS5vcmc+DQo+
IC0tLQ0KPiAgZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyB8IDUgKy0tLS0NCj4gIDEgZmlsZSBj
aGFuZ2VkLCAxIGluc2VydGlvbigrKSwgNCBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQg
YS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0K
PiBpbmRleCAxMjI2NmJkLi4wYTViMTk3IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3Njc2kvdWZz
L3Vmc2hjZC5jDQo+ICsrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCj4gQEAgLTc3NjUs
NiArNzc2NSw3IEBAIHN0YXRpYyB2b2lkIHVmc2hjZF9hc3luY19zY2FuKHZvaWQgKmRhdGEsIGFz
eW5jX2Nvb2tpZV90IGNvb2tpZSkNCj4gIAlpZiAocmV0KSB7DQo+ICAJCXBtX3J1bnRpbWVfcHV0
X3N5bmMoaGJhLT5kZXYpOw0KPiAgCQl1ZnNoY2RfZXhpdF9jbGtfc2NhbGluZyhoYmEpOw0KPiAr
CQl1ZnNoY2RfZXhpdF9jbGtfZ2F0aW5nKGhiYSk7DQoNCkhvdyBhYm91dCBtb3ZpbmcgYWJvdmUg
dHdvIGxpbmVzIHRvIHVmc2hjZF9oYmFfZXhpdCgpPw0KDQpPdGhlcndpc2UgbG9va3MgZ29vZCB0
byBtZSENClJldmlld2VkLWJ5OiBTdGFubGV5IENodSA8c3RhbmxleWMuY2h1QG1lZGlhdGVrLmNv
bT4NCg0KPiAgCQl1ZnNoY2RfaGJhX2V4aXQoaGJhKTsNCj4gIAl9DQo+ICB9DQo+IEBAIC04MjAz
LDEwICs4MjA0LDYgQEAgc3RhdGljIHZvaWQgdWZzaGNkX2hiYV9leGl0KHN0cnVjdCB1ZnNfaGJh
ICpoYmEpDQo+ICAJaWYgKGhiYS0+aXNfcG93ZXJlZCkgew0KPiAgCQl1ZnNoY2RfdmFyaWFudF9o
YmFfZXhpdChoYmEpOw0KPiAgCQl1ZnNoY2Rfc2V0dXBfdnJlZyhoYmEsIGZhbHNlKTsNCj4gLQkJ
dWZzaGNkX3N1c3BlbmRfY2xrc2NhbGluZyhoYmEpOw0KPiAtCQlpZiAodWZzaGNkX2lzX2Nsa3Nj
YWxpbmdfc3VwcG9ydGVkKGhiYSkpDQo+IC0JCQlpZiAoaGJhLT5kZXZmcmVxKQ0KPiAtCQkJCXVm
c2hjZF9zdXNwZW5kX2Nsa3NjYWxpbmcoaGJhKTsNCj4gIAkJdWZzaGNkX3NldHVwX2Nsb2Nrcyho
YmEsIGZhbHNlKTsNCj4gIAkJdWZzaGNkX3NldHVwX2hiYV92cmVnKGhiYSwgZmFsc2UpOw0KPiAg
CQloYmEtPmlzX3Bvd2VyZWQgPSBmYWxzZTsNCg0K

