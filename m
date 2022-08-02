Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AFB7C00140
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Aug 2022 11:23:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236614AbiHBLXm convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Aug 2022 07:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231860AbiHBLXl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Aug 2022 07:23:41 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F01A3E740;
        Tue,  2 Aug 2022 04:23:39 -0700 (PDT)
Received: from kwepemi100016.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Lxsvs5jP5zWfFn;
        Tue,  2 Aug 2022 19:19:37 +0800 (CST)
Received: from canpemm500008.china.huawei.com (7.192.105.151) by
 kwepemi100016.china.huawei.com (7.221.188.123) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 2 Aug 2022 19:23:36 +0800
Received: from canpemm500008.china.huawei.com ([7.192.105.151]) by
 canpemm500008.china.huawei.com ([7.192.105.151]) with mapi id 15.01.2375.024;
 Tue, 2 Aug 2022 19:23:36 +0800
From:   "lijinlin (A)" <lijinlin3@huawei.com>
To:     "lduncan@suse.com" <lduncan@suse.com>,
        "cleech@redhat.com" <cleech@redhat.com>,
        "michael.christie@oracle.com" <michael.christie@oracle.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "mark.mielke@gmail.com" <mark.mielke@gmail.com>
CC:     "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linfeilong <linfeilong@huawei.com>,
        "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
Subject: RE: [PATCH] scsi: iscsi: iscsi_tcp: Fix null-ptr-deref while calling
 getpeername()
Thread-Topic: [PATCH] scsi: iscsi: iscsi_tcp: Fix null-ptr-deref while calling
 getpeername()
Thread-Index: AQHYplPSHTFXshUY502LyLNPnnKlQa2bdgFg
Date:   Tue, 2 Aug 2022 11:23:36 +0000
Message-ID: <d8afc88468ab481eb325e842ad384e0e@huawei.com>
References: <20220802101939.3972556-1-lijinlin3@huawei.com>
In-Reply-To: <20220802101939.3972556-1-lijinlin3@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.179.2]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

So sorry, this patch has problem, please ignore.

Thanks
Li Jinlin
