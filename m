Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ED34C4338F
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 18:08:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B337610FD
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 18:08:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231247AbhHRSJ2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Aug 2021 14:09:28 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3668 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbhHRSJ0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Aug 2021 14:09:26 -0400
Received: from fraeml738-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GqbTz1TQFz6D9Rq;
        Thu, 19 Aug 2021 02:07:51 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml738-chm.china.huawei.com (10.206.15.219) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 18 Aug 2021 20:08:50 +0200
Received: from [10.47.81.140] (10.47.81.140) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Wed, 18 Aug
 2021 19:08:49 +0100
Subject: Re: [PATCH 0/3] Remove scsi_cmnd.tag
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     <satishkh@cisco.com>, <sebaddel@cisco.com>, <kartilak@cisco.com>,
        <jejb@linux.ibm.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <hare@suse.de>, <hch@lst.de>,
        <bvanassche@acm.org>
References: <1628862553-179450-1-git-send-email-john.garry@huawei.com>
 <yq14kbppa42.fsf@ca-mkp.ca.oracle.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <176ce4f2-42c9-bba6-c8f9-70a08faa21b8@huawei.com>
Date:   Wed, 18 Aug 2021 19:08:48 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <yq14kbppa42.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.81.140]
X-ClientProxiedBy: lhreml712-chm.china.huawei.com (10.201.108.63) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 16/08/2021 18:34, Martin K. Petersen wrote:
> 
> John,
> 
>> There is no need for scsi_cmnd.tag, so remove it.
> 
> Applied to 5.15/scsi-staging, thanks!
> 

Hi Martin,

As you may have seen, some arm32 build has also broken. My build 
coverage was not good enough, and I don't see a point in me playing 
whack-a-mole with the kernel test robot. So how about revert the final 
patch or even all of them, and I can try get better build coverage and 
then re-post? Or maybe you or Bart have a better idea?

Thanks!
