Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF22FC8300F
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 09:41:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F80B206ED
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 09:41:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727628AbgK3Jle (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Nov 2020 04:41:34 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2172 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbgK3Jld (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Nov 2020 04:41:33 -0500
Received: from fraeml741-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Cl0Xq0jfqz67Jpb;
        Mon, 30 Nov 2020 17:38:35 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml741-chm.china.huawei.com (10.206.15.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 30 Nov 2020 10:40:51 +0100
Received: from [10.47.3.199] (10.47.3.199) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1913.5; Mon, 30 Nov
 2020 09:40:50 +0000
Subject: Re: [PATCH v1 2/3] megaraid_sas: iouring iopoll support
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, <linux-scsi@vger.kernel.org>
CC:     Sumit Saxena <sumit.saxena@broadcom.com>,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        <linux-block@vger.kernel.org>
References: <20201015133702.62879-1-kashyap.desai@broadcom.com>
 <494a87e9-2994-0965-e5d5-56f2a3b13f0b@suse.de>
 <2dae79b3-2083-75e0-73fc-ab52c5546bc8@huawei.com>
 <ed32d15fb0b00ff255ffa4284710456b@mail.gmail.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <9b41364c-3164-15c6-ac7b-2bc8d9e1f235@huawei.com>
Date:   Mon, 30 Nov 2020 09:40:25 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <ed32d15fb0b00ff255ffa4284710456b@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.3.199]
X-ClientProxiedBy: lhreml704-chm.china.huawei.com (10.201.108.53) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 30/11/2020 09:17, Kashyap Desai wrote:
>> be inefficient also.
> 
> John -
> 
> Noted. I was able to get expected performance on multiple host using
> atomic_add_() API.
> We can improve based on any real time issue.  Is it fine ?

sure, it's your driver :)

> 
> @Hannes - I will add Reviewed-by Tag in V2 series.
> 

