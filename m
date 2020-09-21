Return-Path: <SRS0=3eE7=C6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AA16C4727E
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Sep 2020 22:18:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C229D23A60
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Sep 2020 22:18:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728087AbgIUWR6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Sep 2020 18:17:58 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2908 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726574AbgIUWR6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Sep 2020 18:17:58 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id 2724846A6D620468DA41;
        Mon, 21 Sep 2020 23:17:56 +0100 (IST)
Received: from [127.0.0.1] (10.210.166.25) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1913.5; Mon, 21 Sep
 2020 23:17:54 +0100
Subject: Re: [PATCH v8 00/18] blk-mq/scsi: Provide hostwide shared tags for
 SCSI HBAs
To:     <Don.Brace@microchip.com>, <martin.petersen@oracle.com>
CC:     <axboe@kernel.dk>, <jejb@linux.ibm.com>, <don.brace@microsemi.com>,
        <kashyap.desai@broadcom.com>, <ming.lei@redhat.com>,
        <bvanassche@acm.org>, <dgilbert@interlog.com>,
        <paolo.valente@linaro.org>, <hare@suse.de>, <hch@lst.de>,
        <sumit.saxena@broadcom.com>, <linux-block@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <esc.storagedev@microsemi.com>, <megaraidlinux.pdl@broadcom.com>,
        <chenxiang66@hisilicon.com>, <luojiaxing@huawei.com>
References: <1597850436-116171-1-git-send-email-john.garry@huawei.com>
 <df6a3bd3-a89e-5f2f-ece1-a12ada02b521@kernel.dk>
 <379ef8a4-5042-926a-b8a0-2d0a684a0e01@huawei.com>
 <yq1363xbtk7.fsf@ca-mkp.ca.oracle.com>
 <32def143-911f-e497-662e-a2a41572fe4f@huawei.com>
 <yq1imcdw6ni.fsf@ca-mkp.ca.oracle.com>
 <7e90cb73-632c-ad37-699f-cb40044029ee@huawei.com>
 <SN6PR11MB2848BF85607B18D23EC40B9BE13A0@SN6PR11MB2848.namprd11.prod.outlook.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <33612fc2-b70d-268e-5059-aadadf0c5dca@huawei.com>
Date:   Mon, 21 Sep 2020 23:15:03 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <SN6PR11MB2848BF85607B18D23EC40B9BE13A0@SN6PR11MB2848.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.166.25]
X-ClientProxiedBy: lhreml701-chm.china.huawei.com (10.201.108.50) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 21/09/2020 22:35, Don.Brace@microchip.com wrote:
>>> I'm waiting on the hpsa and smartpqi patches >>update, so please kindly merge only those >>patches, above.
>>> Thanks!
> John, the hpsa driver crashes, the  or more patches to allow internal commands from Hannas seem to be missing.
> 
> I'll let you know exactly which ones soon.
> 

Hi Don,

Right, that branch did not include Hannes patches as they did not apply 
cleanly, but I think that you need the same patches as before. I can 
create a branch for you to test which does include those tomorrow - let 
me know.

Alternatively I think that we could create a hpsa patch which does not 
rely on that series, like I mentioned here [0], but it would not be as 
clean.

Cheers,
John

https://lore.kernel.org/linux-scsi/dc0e72d8-7076-060c-3cd3-3d51ac7e6de8@huawei.com/
