Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8267C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Nov 2021 18:13:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235480AbhKVSQa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 13:16:30 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4148 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233434AbhKVSQ3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Nov 2021 13:16:29 -0500
Received: from fraeml712-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Hyb2w0NxGz686y1;
        Tue, 23 Nov 2021 02:12:24 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml712-chm.china.huawei.com (10.206.15.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 22 Nov 2021 19:13:21 +0100
Received: from [10.47.91.234] (10.47.91.234) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.20; Mon, 22 Nov
 2021 18:13:20 +0000
Subject: Re: [PATCH v2 06/20] scsi: core: Add support for reserved tags
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20211119195743.2817-1-bvanassche@acm.org>
 <20211119195743.2817-7-bvanassche@acm.org>
 <4f76acb2-68ff-6f6a-775b-81efc4cf10cc@huawei.com>
 <c5e09609-d61a-dd6d-0962-3c30a099638c@acm.org>
From:   John Garry <john.garry@huawei.com>
Message-ID: <c831196c-af7a-afc4-7468-c789d8b7876a@huawei.com>
Date:   Mon, 22 Nov 2021 18:13:15 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <c5e09609-d61a-dd6d-0962-3c30a099638c@acm.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.91.234]
X-ClientProxiedBy: lhreml705-chm.china.huawei.com (10.201.108.54) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 22/11/2021 17:25, Bart Van Assche wrote:
> On 11/22/21 12:15 AM, John Garry wrote:
>> On 19/11/2021 19:57, Bart Van Assche wrote:
>>> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
>>> index 72e1a347baa6..ec0f7705e06a 100644
>>> --- a/include/scsi/scsi_host.h
>>> +++ b/include/scsi/scsi_host.h
>>> @@ -367,10 +367,17 @@ struct scsi_host_template {
>>
>> why no field in struct Scsi_Host?
> 
> Why to duplicate this field in struct Scsi_Host? Do we expect that there
> will be SCSI drivers in the future for which the number of reserved tags
> is only known at runtime? This seems unlikely to me.


Fine, I was using this but I suppose it's not needed ATM.

Thanks,
John
