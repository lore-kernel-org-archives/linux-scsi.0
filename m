Return-Path: <SRS0=uVXb=YR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E310CA9EAF
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 09:54:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3EAE62166E
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 09:54:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391609AbfJXJyI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Oct 2019 05:54:08 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2052 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725775AbfJXJyI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Oct 2019 05:54:08 -0400
Received: from lhreml704-cah.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id CB95F723A76FB3298309;
        Thu, 24 Oct 2019 10:54:05 +0100 (IST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 lhreml704-cah.china.huawei.com (10.201.108.45) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 24 Oct 2019 10:54:05 +0100
Received: from [127.0.0.1] (10.202.226.45) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Thu, 24 Oct
 2019 10:54:05 +0100
Subject: Re: [PATCH 05/18] scsi: hisi_sas: Add timestamp for a debugfs dump
To:     kbuild test robot <lkp@intel.com>
CC:     <kbuild-all@lists.01.org>, <jejb@linux.vnet.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <linuxarm@huawei.com>, <linux-kernel@vger.kernel.org>,
        Luo Jiaxing <luojiaxing@huawei.com>
References: <1571674935-108326-6-git-send-email-john.garry@huawei.com>
 <201910241732.D736Hdxm%lkp@intel.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <8ffe7e01-d955-8dd5-bbc5-d66c31716667@huawei.com>
Date:   Thu, 24 Oct 2019 10:54:03 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <201910241732.D736Hdxm%lkp@intel.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.45]
X-ClientProxiedBy: lhreml730-chm.china.huawei.com (10.201.108.81) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 24/10/2019 10:20, kbuild test robot wrote:
> Hi John,
> 
> Thank you for the patch! Yet something to improve:
> 
> [auto build test ERROR on mkp-scsi/for-next]
> [cannot apply to v5.4-rc4 next-20191023]
> [if your patch is applied to the wrong git tree, please drop us a note to help
> improve the system. BTW, we also suggest to use '--base' option to specify the
> base tree in git format-patch, please see https://stackoverflow.com/a/37406982]
> 
> url:    https://github.com/0day-ci/linux/commits/John-Garry/hisi_sas-Misc-patches-mostly-debugfs/20191024-130727
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
> config: i386-allmodconfig (attached as .config)
> compiler: gcc-7 (Debian 7.4.0-14) 7.4.0
> reproduce:
>          # save the attached .config to linux build tree
>          make ARCH=i386
> 
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>>> ERROR: "__udivdi3" [drivers/scsi/hisi_sas/hisi_sas_main.ko] undefined!
> 

I'll send v2...

john

> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> 

