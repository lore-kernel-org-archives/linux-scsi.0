Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C51D0C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 13:32:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BED4613AC
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 13:32:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235093AbhJENdx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Oct 2021 09:33:53 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3935 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234103AbhJENdx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Oct 2021 09:33:53 -0400
Received: from fraeml735-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HNz2P5GFfz67bWP;
        Tue,  5 Oct 2021 21:29:17 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml735-chm.china.huawei.com (10.206.15.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 5 Oct 2021 15:32:01 +0200
Received: from [10.47.95.252] (10.47.95.252) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.8; Tue, 5 Oct 2021
 14:32:00 +0100
Subject: Re: [PATCH v5 00/14] blk-mq: Reduce static requests memory footprint
 for shared sbitmap
To:     Jens Axboe <axboe@kernel.dk>, <kashyap.desai@broadcom.com>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ming.lei@redhat.com>, <hare@suse.de>, <linux-scsi@vger.kernel.org>
References: <1633429419-228500-1-git-send-email-john.garry@huawei.com>
 <ae33dde8-96e8-2978-5f32-c7e0a6136e8e@kernel.dk>
From:   John Garry <john.garry@huawei.com>
Message-ID: <81d9e019-b730-221e-a8c0-f72a8422a2ec@huawei.com>
Date:   Tue, 5 Oct 2021 14:34:39 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <ae33dde8-96e8-2978-5f32-c7e0a6136e8e@kernel.dk>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.95.252]
X-ClientProxiedBy: lhreml709-chm.china.huawei.com (10.201.108.58) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 05/10/2021 13:35, Jens Axboe wrote:
>> Baseline is 1b2d1439fc25 (block/for-next) Merge branch 'for-5.16/io_uring'
>> into for-next
> Let's get this queued up for testing, thanks John.

Cheers, appreciated

@Kashyap, You mentioned that when testing you saw a performance 
regression from v5.11 -> v5.12 - any idea on that yet? Can you describe 
the scenario, like IO scheduler and how many disks and the type? Does 
disabling host_tagset_enable restore performance?

 From checking differences between those kernels, I don't see anything 
directly relevant in sbitmap support or in the megaraid sas driver.

Thanks,
John
