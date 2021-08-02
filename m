Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8D42C4338F
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Aug 2021 08:17:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A329F610A2
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Aug 2021 08:17:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232633AbhHBIRj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Aug 2021 04:17:39 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:49632 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S232562AbhHBIRi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Aug 2021 04:17:38 -0400
X-UUID: 83111e63d5604802a2e2b2cdbd25e108-20210802
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=1Hq5NbxHDWPd+f828K3qe8qqqqB4vYIAmXgOcfw2RjA=;
        b=ZSKkYgYK1TNbsdvhKg9eGYp0i6OsK12ouR2FwYxu/8y97pJAC/F6UFrB5q0vllIDx7wyGzJXpnOI+yVna5TQ3YppRqQGghp8Liuo+3s4uOYyhoFsJyH0jstnCN7N8m8G6iKon9IMFMiAiku3NdiHK7F5qGS1chENhFcfpPNHTNE=;
X-UUID: 83111e63d5604802a2e2b2cdbd25e108-20210802
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 2038557911; Mon, 02 Aug 2021 16:17:16 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs06n1.mediatek.inc (172.21.101.129) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 2 Aug 2021 16:17:15 +0800
Received: from mtksdccf07 (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 2 Aug 2021 16:17:14 +0800
Message-ID: <0317d88c245f458a8d273857235f9c06d63153b3.camel@mediatek.com>
Subject: Re: [PATCH v3 04/18] scsi: ufs: Rename the second
 ufshcd_probe_hba() argument
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        "Avri Altman" <avri.altman@wdc.com>, Bean Huo <beanhuo@micron.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Can Guo <cang@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Date:   Mon, 2 Aug 2021 16:17:14 +0800
In-Reply-To: <20210722033439.26550-5-bvanassche@acm.org>
References: <20210722033439.26550-1-bvanassche@acm.org>
         <20210722033439.26550-5-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQmFydCwNCg0KT24gV2VkLCAyMDIxLTA3LTIxIGF0IDIwOjM0IC0wNzAwLCBCYXJ0IFZhbiBB
c3NjaGUgd3JvdGU6DQo+IFJlbmFtZSB0aGUgc2Vjb25kIGFyZ3VtZW50IG9mIHVmc2hjZF9wcm9i
ZV9oYmEoKSBzdWNoIHRoYXQgdGhlIG5hbWUNCj4gb2YNCj4gdGhhdCBhcmd1bWVudCByZWZsZWN0
cyBpdHMgcHVycG9zZSBpbnN0ZWFkIG9mIGhvdyB0aGUgZnVuY3Rpb24gaXMNCj4gY2FsbGVkLg0K
PiBTZWUgYWxzbyBjb21taXQgMWI5ZTIxNDEyZjcyICgic2NzaTogdWZzOiBTcGxpdCB1ZnNoY2Rf
cHJvYmVfaGJhKCkNCj4gYmFzZWQNCj4gb24gaXRzIGNhbGxlZCBmbG93IikuDQo+IA0KDQpSZXZp
ZXdlZC1ieTogU3RhbmxleSBDaHUgPHN0YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NCg==

