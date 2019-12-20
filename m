Return-Path: <SRS0=ZPSI=2K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1AA7C43603
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 01:15:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7834D2465E
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 01:15:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Ci2rThDU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbfLTBPt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Dec 2019 20:15:49 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:41367 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726992AbfLTBPt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Dec 2019 20:15:49 -0500
X-UUID: afd64deefe824a50879f7521ac2dd63e-20191220
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=b5yv46h23CCjvOR/ZEHao3boQBcXYWw6ORSfeX263tk=;
        b=Ci2rThDUMl9Cfu6SBl5GeIj9lzmSQupXu3Q8z8/3N0UGrGBA6HZGijnUnZJtooVoYfH02k6Ilb+zuKBJlus8OUK/o1c21uNO/8cJl85YLKXX4TmslAO1d4uwNj4OeUAoJchiSJSvu42AXKE/kP4tJebSL9Pqp2b/6UWiMpwRKHs=;
X-UUID: afd64deefe824a50879f7521ac2dd63e-20191220
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1228277607; Fri, 20 Dec 2019 09:15:41 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 20 Dec 2019 09:15:06 +0800
Received: from [172.21.77.33] (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 20 Dec 2019 09:14:47 +0800
Message-ID: <1576804540.13056.22.camel@mtkswgap22>
Subject: Re: [PATCH v2 1/2 RESEND] soc: mediatek: add header for SiP service
 interface
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Alim Akhtar <alim.akhtar@gmail.com>
CC:     "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Leon Chen =?UTF-8?Q?=28=E9=99=B3=E6=96=87=E9=8F=98=29?= 
        <Leon.Chen@mediatek.com>,
        "Andy Teng ( =?ISO-8859-1?Q?=1B$B{}G!9(=1B(B?=)" 
        <Andy.Teng@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Chun-Hung Wu =?UTF-8?Q?=28=E5=B7=AB=E9=A7=BF=E5=AE=8F=29?= 
        <Chun-hung.Wu@mediatek.com>,
        Kuohong Wang =?UTF-8?Q?=28=E7=8E=8B=E5=9C=8B=E9=B4=BB=29?= 
        <kuohong.wang@mediatek.com>,
        open list <linux-kernel@vger.kernel.org>,
        "Avri Altman" <avri.altman@wdc.com>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        Peter Wang =?UTF-8?Q?=28=E7=8E=8B=E4=BF=A1=E5=8F=8B=29?= 
        <peter.wang@mediatek.com>, Alim Akhtar <alim.akhtar@samsung.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "Bean Huo (beanhuo)" <beanhuo@micron.com>
Date:   Fri, 20 Dec 2019 09:15:40 +0800
In-Reply-To: <CAGOxZ50RKYAEw=HwYMH=Jm7cagUV12C-fwhauJhJqx6HscAmFA@mail.gmail.com>
References: <1576468137-17220-1-git-send-email-stanley.chu@mediatek.com>
         <1576468137-17220-2-git-send-email-stanley.chu@mediatek.com>
         <CAGOxZ50RKYAEw=HwYMH=Jm7cagUV12C-fwhauJhJqx6HscAmFA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQWxpbSwNCg0KT24gRnJpLCAyMDE5LTEyLTIwIGF0IDAyOjAwICswODAwLCBBbGltIEFraHRh
ciB3cm90ZToNCj4gPiArLyogVUZTIHJlbGF0ZWQgU01DIGNhbGwgKi8NCj4gPiArI2RlZmluZSBN
VEtfU0lQX1VGU19DT05UUk9MIFwNCj4gPiArICAgICAgIE1US19TSVBfU01DX0NNRCgweDI3NikN
Cj4gPiArDQo+IEhvdyBhYm91dCBtb3ZpbmcgVUZTIHNwZWNpZmljIHN0dWZmIHRvIE1USyBVRlMg
ZHJpdmVyIGFuZCBpbmNsdWRlIHRoaXMNCj4gaGVhZGVyIGluIGRyaXZlciBmaWxlPw0KPiBSZXN0
IGxvb2tzIGZpbmUuDQoNClRoYW5rcyBzbyBtdWNoIGZvciB5b3VyIHJldmlldy4NCg0KT3VyIGlu
dGVudGlvbiBpcyB0byBjb2xsZWN0IGFsbCBTTUMgY2FsbCBjb21tYW5kIHR5cGVzIGluIE1lZGlh
VGVrDQpDaGlwc2V0cyBoZXJlIGZvciBlYXNpZXIgbWFuYWdlbWVudC4NCg0KVGhpcyBpcyB0aGUg
Zmlyc3QgdGltZSB3ZSBzaG93IHRoaXMgaGVhZGVyIHRodXMgb25seSBVRlMgcmVsYXRlZCBzdHVm
Zg0KaXMgcHJlc2VudCBoZXJlLg0KDQo+ID4gKyNlbmRpZg0KPiA+IC0tDQo+ID4gMi4xOC4wDQo+
IA0KPiANCg0KVGhhbmtzLA0KU3RhbmxleQ0KDQoNCg0KDQo=

