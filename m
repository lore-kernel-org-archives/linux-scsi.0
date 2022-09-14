Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E2F7ECAAD3
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Sep 2022 16:54:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiINQx7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Sep 2022 12:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbiINQxf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Sep 2022 12:53:35 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E585816B4
        for <linux-scsi@vger.kernel.org>; Wed, 14 Sep 2022 09:53:33 -0700 (PDT)
Received: from fraeml738-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4MSRFh0MrBz67PvV;
        Thu, 15 Sep 2022 00:52:08 +0800 (CST)
Received: from lhrpeml500003.china.huawei.com (7.191.162.67) by
 fraeml738-chm.china.huawei.com (10.206.15.219) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 14 Sep 2022 18:53:30 +0200
Received: from [10.48.151.55] (10.48.151.55) by lhrpeml500003.china.huawei.com
 (7.191.162.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 14 Sep
 2022 17:53:29 +0100
Message-ID: <16bee2e1-ed9d-8fc5-da55-90cee8f90316@huawei.com>
Date:   Wed, 14 Sep 2022 17:53:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v4 2/4] scsi: esas2r: Introduce scsi_template_proc_dir()
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        Bradley Grove <linuxdrivers@attotech.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        "Hannes Reinecke" <hare@suse.de>,
        Mike Christie <michael.christie@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220913195716.3966875-1-bvanassche@acm.org>
 <20220913195716.3966875-3-bvanassche@acm.org>
 <d63c326b-fa17-694c-cb72-aa746919218c@huawei.com>
 <3ee85c43-161f-58a1-0319-8062547a630b@acm.org>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <3ee85c43-161f-58a1-0319-8062547a630b@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.48.151.55]
X-ClientProxiedBy: lhrpeml100004.china.huawei.com (7.191.162.219) To
 lhrpeml500003.china.huawei.com (7.191.162.67)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/09/2022 17:43, Bart Van Assche wrote:
> On 9/14/22 02:06, John Garry wrote:
>> On 13/09/2022 20:57, Bart Van Assche wrote:
>>> This patch does not change any functionality.
>>
>> ... intentionally :)

I was just half-joking, so please ignore me.

It's common to write that there is no intentional change in 
functionality, as maybe there is some unknown change in functionality.

Thanks,
John
