Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D069C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 08:19:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 479E561040
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 08:19:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238351AbhJMIVP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Oct 2021 04:21:15 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3972 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238779AbhJMIVM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Oct 2021 04:21:12 -0400
Received: from fraeml707-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HTljS2Yrqz67k2V;
        Wed, 13 Oct 2021 16:16:12 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml707-chm.china.huawei.com (10.206.15.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 13 Oct 2021 10:19:06 +0200
Received: from [10.47.95.55] (10.47.95.55) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.8; Wed, 13 Oct
 2021 09:19:05 +0100
Subject: Re: [PATCH v4 20/46] scsi: hisi_sas: Switch to attribute groups
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20211012233558.4066756-1-bvanassche@acm.org>
 <20211012233558.4066756-21-bvanassche@acm.org>
From:   John Garry <john.garry@huawei.com>
Message-ID: <4b8e171e-5d44-f7cc-b6c3-bb7e01320345@huawei.com>
Date:   Wed, 13 Oct 2021 09:22:11 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20211012233558.4066756-21-bvanassche@acm.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.95.55]
X-ClientProxiedBy: lhreml703-chm.china.huawei.com (10.201.108.52) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 13/10/2021 00:35, Bart Van Assche wrote:
> struct device supports attribute groups directly but does not support
> struct device_attribute directly. Hence switch to attribute groups.
> 
> Signed-off-by: Bart Van Assche<bvanassche@acm.org>

Acked-by: John Garry <john.garry@huawei.com>
