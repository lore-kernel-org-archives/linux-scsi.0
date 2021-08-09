Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32B39C4338F
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 17:11:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18A0960EBC
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 17:11:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233950AbhHIRLw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 13:11:52 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3619 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233449AbhHIRLv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 13:11:51 -0400
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Gk2fZ16wqz6D9Hn;
        Tue, 10 Aug 2021 01:11:02 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Mon, 9 Aug 2021 19:11:29 +0200
Received: from [10.47.80.4] (10.47.80.4) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Mon, 9 Aug 2021
 18:11:28 +0100
Subject: Re: [PATCH v2 06/11] blk-mq: Pass driver tags to
 blk_mq_clear_rq_mapping()
To:     kernel test robot <lkp@intel.com>, <axboe@kernel.dk>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <kbuild-all@lists.01.org>, <linux-block@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <kashyap.desai@broadcom.com>, <hare@suse.de>, <ming.lei@redhat.com>
References: <1628519378-211232-7-git-send-email-john.garry@huawei.com>
 <202108100007.jrbSQNQh-lkp@intel.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <290c5399-9810-5fa1-b097-334ab1a3c22f@huawei.com>
Date:   Mon, 9 Aug 2021 18:10:56 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <202108100007.jrbSQNQh-lkp@intel.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.80.4]
X-ClientProxiedBy: lhreml712-chm.china.huawei.com (10.201.108.63) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09/08/2021 18:00, kernel test robot wrote:
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot<lkp@intel.com>
> 
> All warnings (new ones prefixed by >>):
> 
>>> block/blk-mq.c:2313:6: warning: no previous prototype for 'blk_mq_clear_rq_mapping' [-Wmissing-prototypes]
>      2313 | void blk_mq_clear_rq_mapping(struct blk_mq_tags *drv_tags,
>           |      ^~~~~~~~~~~~~~~~~~~~~~~
> 
> 
> vim +/blk_mq_clear_rq_mapping +2313 block/blk-mq.c
> 
>    2311	
>    2312	/* called before freeing request pool in @tags */
>> 2313	void blk_mq_clear_rq_mapping(struct blk_mq_tags *drv_tags,
>    2314				     struct blk_mq_tags *tags)

I will fix in a new version after other review.

Thanks
