Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 103DDC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Nov 2021 06:01:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233370AbhKWGEL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Nov 2021 01:04:11 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:28168 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbhKWGEK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Nov 2021 01:04:10 -0500
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HytkQ65g9z8vVp;
        Tue, 23 Nov 2021 13:59:10 +0800 (CST)
Received: from [127.0.0.1] (10.40.193.166) by dggeme756-chm.china.huawei.com
 (10.3.19.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.20; Tue, 23
 Nov 2021 14:01:00 +0800
Subject: Re: [PATCH 00/15] Add runtime PM support for libsas
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
References: <1637117108-230103-1-git-send-email-chenxiang66@hisilicon.com>
 <yq1mtm06beg.fsf@ca-mkp.ca.oracle.com>
CC:     <jejb@linux.ibm.com>, <linux-scsi@vger.kernel.org>,
        <linuxarm@huawei.com>, <john.garry@huawei.com>
From:   "chenxiang (M)" <chenxiang66@hisilicon.com>
Message-ID: <9aa59039-0868-5d4e-a499-48af999c0ce5@hisilicon.com>
Date:   Tue, 23 Nov 2021 14:01:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <yq1mtm06beg.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.40.193.166]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggeme756-chm.china.huawei.com (10.3.19.102)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



ÔÚ 2021/11/19 12:04, Martin K. Petersen Ð´µÀ:
>> Right now hisi_sas driver has already supported runtime PM, and it
>> works well on base functions.
> The commit messages for this series need work.
>
Ok, thanks.

