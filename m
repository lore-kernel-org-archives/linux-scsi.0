Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96853C05027
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Feb 2023 08:30:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbjBQIam (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Feb 2023 03:30:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjBQIal (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Feb 2023 03:30:41 -0500
Received: from ssh248.corpemail.net (ssh248.corpemail.net [210.51.61.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A8B5FBCB;
        Fri, 17 Feb 2023 00:30:31 -0800 (PST)
Received: from ([60.208.111.195])
        by ssh248.corpemail.net ((D)) with ASMTP (SSL) id NCW00122;
        Fri, 17 Feb 2023 16:30:22 +0800
Received: from jtjnmail201622.home.langchao.com (10.100.2.22) by
 jtjnmail201621.home.langchao.com (10.100.2.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 17 Feb 2023 16:30:26 +0800
Received: from jtjnmail201622.home.langchao.com ([fe80::15c3:8d74:3aa6:25f6])
 by jtjnmail201622.home.langchao.com ([fe80::15c3:8d74:3aa6:25f6%7]) with mapi
 id 15.01.2507.016; Fri, 17 Feb 2023 16:30:26 +0800
From:   =?gb2312?B?Qm8gTGl1ICjB9bKoKS3Ay7Ox0MXPog==?= <liubo03@inspur.com>
To:     "james.smart@broadcom.com" <james.smart@broadcom.com>,
        "dick.kennedy@broadcom.com" <dick.kennedy@broadcom.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?gb2312?B?Qm8gTGl1ICjB9bKoKS3Ay7Ox0MXPog==?= <liubo03@inspur.com>
Subject: =?gb2312?B?s7e72DogW1BBVENIXSBzY3NpOiBscGZjOiBGaXggZG91YmxlIHdvcmQgaW4g?=
 =?gb2312?Q?comments?=
Thread-Topic: [PATCH] scsi: lpfc: Fix double word in comments
Thread-Index: AQHZQqoVT5Z0Iy8j7kSXD4dcDhaoRg==
X-CallingTelephoneNumber: IPM.Note
X-VoiceMessageDuration: 35
X-FaxNumberOfPages: 0
Date:   Fri, 17 Feb 2023 08:30:26 +0000
Message-ID: <4d8d9d3530814679b55def4eec37336d@inspur.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.200.104.97]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
tUid:   202321716302249b21a45030ff03991707a4460887b5f
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Qm8gTGl1ICjB9bKoKS3Ay7Ox0MXPoiC9q7O3u9jTyrz+obBbUEFUQ0hdIHNjc2k6IGxwZmM6IEZp
eCBkb3VibGUgd29yZCBpbiBjb21tZW50c6GxoaM=
