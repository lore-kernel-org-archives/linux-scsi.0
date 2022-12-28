Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CA3CC4708D
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Dec 2022 09:45:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbiL1Jog (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Dec 2022 04:44:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232916AbiL1Jo0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Dec 2022 04:44:26 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2E726445
        for <linux-scsi@vger.kernel.org>; Wed, 28 Dec 2022 01:44:25 -0800 (PST)
Received: from dggpemm500017.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4NhmjC2v4Wz9t1t;
        Wed, 28 Dec 2022 17:40:31 +0800 (CST)
Received: from [10.174.178.220] (10.174.178.220) by
 dggpemm500017.china.huawei.com (7.185.36.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Wed, 28 Dec 2022 17:44:23 +0800
Message-ID: <83cf0f00-f9cd-1cdc-e66b-58f6f7e9a160@huawei.com>
Date:   Wed, 28 Dec 2022 17:44:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 0/2] scsi: iscsi: host ipaddress UAF fixes
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        <dinghui@sangfor.com.cn>, <haowenchao22@gmail.com>,
        <lduncan@suse.com>, <cleech@redhat.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <jejb@linux.ibm.com>
References: <20221219195818.8509-1-michael.christie@oracle.com>
From:   Wenchao Hao <haowenchao@huawei.com>
In-Reply-To: <20221219195818.8509-1-michael.christie@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.220]
X-ClientProxiedBy: dggpeml500003.china.huawei.com (7.185.36.200) To
 dggpemm500017.china.huawei.com (7.185.36.178)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022/12/20 3:58, Mike Christie wrote:
> The following patches made apply over Martin's or Linus's trees. They
> fix 2 use after free bugs caused by iscsi_tcp using the session's socket
> to export the local IP address on the iscsi host to emulate the host's
> local IP address.
> 
> Note that the naming is not great because the libiscsi session removal
> and freeing functions are close to the iSCSI class's names. That will be
> fixed in a separate patch for the 6.3 kernel because it was a pretty big
> change fix up all the naming.
> 
> 
> .
Sorry, I got COVID-19 and just recovered, so did not response the email in time.

This looks good to me.
