Return-Path: <SRS0=On0Q=2P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D929C2D0DA
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Dec 2019 07:16:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E3CE20722
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Dec 2019 07:16:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="WtV2YH5W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725976AbfLYHQg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Dec 2019 02:16:36 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:16451 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725865AbfLYHQg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Dec 2019 02:16:36 -0500
X-UUID: 222844dc96bc4919b4109d599f8c3ff6-20191225
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=o8+sG+Yks62IvzNXADTVvN2dRy5y/RuLQWyYMMZgYew=;
        b=WtV2YH5WIkgCYk8VMdW9yAe+ws5YwApp16TWOP6z5YqXuk0/ixvXWFdaB05WSJnI7c5R55e0Nq6g7rI8mGN3EkKzuODzwvtnfCoeh37wtxoDjzukYsZaOT/0+iDONomGvBKQL7Jrk6DgsNbNtM2LpISD063Cp1l7xVPIlSF5SRA=;
X-UUID: 222844dc96bc4919b4109d599f8c3ff6-20191225
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1202755123; Wed, 25 Dec 2019 15:16:30 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs01n1.mediatek.inc (172.21.101.68) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 25 Dec 2019 15:16:03 +0800
Received: from [172.21.77.33] (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Wed, 25 Dec 2019 15:15:25 +0800
Message-ID: <1577258189.13056.49.camel@mtkswgap22>
Subject: Re: [PATCH 1/6] ufs: Fix indentation in ufshcd_query_attr_retry()
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        <linux-scsi@vger.kernel.org>, Bean Huo <beanhuo@micron.com>,
        Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Date:   Wed, 25 Dec 2019 15:16:29 +0800
In-Reply-To: <20191224220248.30138-2-bvanassche@acm.org>
References: <20191224220248.30138-1-bvanassche@acm.org>
         <20191224220248.30138-2-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQmFydCwNCg0KT24gVHVlLCAyMDE5LTEyLTI0IGF0IDE0OjAyIC0wODAwLCBCYXJ0IFZhbiBB
c3NjaGUgd3JvdGU6DQo+IFJlbW92ZSBhIHNwYWNlIHRoYXQgb2NjdXJzIGFmdGVyIGEgdGFiLg0K
PiANCj4gQ2M6IEJlYW4gSHVvIDxiZWFuaHVvQG1pY3Jvbi5jb20+DQo+IENjOiBDYW4gR3VvIDxj
YW5nQGNvZGVhdXJvcmEub3JnPg0KPiBDYzogQXZyaSBBbHRtYW4gPGF2cmkuYWx0bWFuQHdkYy5j
b20+DQo+IENjOiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KPiBDYzog
VG9tYXMgV2lua2xlciA8dG9tYXMud2lua2xlckBpbnRlbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6
IEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPg0KPiAtLS0NCj4gIGRyaXZlcnMv
c2NzaS91ZnMvdWZzaGNkLmMgfCAyICstDQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24o
KyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vm
c2hjZC5jIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KPiBpbmRleCBkNmQwZjgzYzkwNDQu
LjQ4ZjJmOTRkNTFiYyAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0K
PiArKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQo+IEBAIC0yODY5LDcgKzI4NjksNyBA
QCBzdGF0aWMgaW50IHVmc2hjZF9xdWVyeV9hdHRyX3JldHJ5KHN0cnVjdCB1ZnNfaGJhICpoYmEs
DQo+ICAJaW50IHJldCA9IDA7DQo+ICAJdTMyIHJldHJpZXM7DQo+ICANCj4gLQkgZm9yIChyZXRy
aWVzID0gUVVFUllfUkVRX1JFVFJJRVM7IHJldHJpZXMgPiAwOyByZXRyaWVzLS0pIHsNCj4gKwlm
b3IgKHJldHJpZXMgPSBRVUVSWV9SRVFfUkVUUklFUzsgcmV0cmllcyA+IDA7IHJldHJpZXMtLSkg
ew0KPiAgCQlyZXQgPSB1ZnNoY2RfcXVlcnlfYXR0cihoYmEsIG9wY29kZSwgaWRuLCBpbmRleCwN
Cj4gIAkJCQkJCXNlbGVjdG9yLCBhdHRyX3ZhbCk7DQo+ICAJCWlmIChyZXQpDQoNClJldmlld2Vk
LWJ5OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0K

