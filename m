Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24458C54EE9
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Sep 2022 13:20:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbiISNUs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Sep 2022 09:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230243AbiISNUn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Sep 2022 09:20:43 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D2946543;
        Mon, 19 Sep 2022 06:20:41 -0700 (PDT)
Received: from dggpeml500020.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MWQG73FJBzpT0S;
        Mon, 19 Sep 2022 21:17:51 +0800 (CST)
Received: from dggpeml500008.china.huawei.com (7.185.36.147) by
 dggpeml500020.china.huawei.com (7.185.36.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 19 Sep 2022 21:20:38 +0800
Received: from [10.67.111.83] (10.67.111.83) by dggpeml500008.china.huawei.com
 (7.185.36.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 19 Sep
 2022 21:20:38 +0800
Message-ID: <919a7e27-2f61-ad58-b366-078ff058ddef@huawei.com>
Date:   Mon, 19 Sep 2022 21:20:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH -next] scsi: qla2xxx: Fix build error
 implicit-function-declaration
To:     Daniel Wagner <dwagner@suse.de>
CC:     <njavali@marvell.com>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <aeasi@marvell.com>, <himanshu.madhani@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20220919030810.1626-1-renzhijie2@huawei.com>
 <20220919071721.upsccdkhzp3zanui@carbon.lan>
From:   Ren Zhijie <renzhijie2@huawei.com>
In-Reply-To: <20220919071721.upsccdkhzp3zanui@carbon.lan>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.111.83]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500008.china.huawei.com (7.185.36.147)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


在 2022/9/19 15:17, Daniel Wagner 写道:
> On Mon, Sep 19, 2022 at 11:08:10AM +0800, Ren Zhijie wrote:
>> +#ifdef CONFIG_TRACING
>>   static void
>>   qla_trace_init(void)
>>   {
>> @@ -2868,7 +2871,7 @@ qla_trace_uninit(void)
>>   		return;
>>   	trace_array_put(qla_trc_array);
>>   }
>> -
>> +#endif
> FWIW, the qla2xxx driver uses a different pattern for ifdefs
>
> 	static void
> 	qla_trace_init(void)
> 	{
> 	#ifdef CONFIG_TRACING
> 	[...]
>          #endif
>          }
>
> This avoid to updated the callside with ifdefs.

Thanks, I will send patch v2.

Ren

> .
.
