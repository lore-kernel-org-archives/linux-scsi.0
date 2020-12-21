Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DBE3C4332B
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 09:48:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF68822BEF
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 09:48:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgLUJsm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Dec 2020 04:48:42 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2272 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726128AbgLUJr7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2020 04:47:59 -0500
Received: from fraeml705-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Cztv02F6lz67SY5;
        Mon, 21 Dec 2020 17:09:00 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml705-chm.china.huawei.com (10.206.15.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2106.2; Mon, 21 Dec 2020 10:11:24 +0100
Received: from [10.210.168.224] (10.210.168.224) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 21 Dec 2020 09:11:22 +0000
Subject: Re: [PATCH 01/11] Documentation: scsi: libsas: Remove
 notify_ha_event()
To:     "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Daniel Wagner <dwagner@suse.de>,
        Jason Yan <yanaijie@huawei.com>,
        "Artur Paszkiewicz" <artur.paszkiewicz@intel.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
CC:     <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>
References: <20201218204354.586951-1-a.darwish@linutronix.de>
 <20201218204354.586951-2-a.darwish@linutronix.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <46a3c918-b40e-7cf8-49da-c8cd5d0b884a@huawei.com>
Date:   Mon, 21 Dec 2020 09:10:38 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20201218204354.586951-2-a.darwish@linutronix.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.168.224]
X-ClientProxiedBy: lhreml739-chm.china.huawei.com (10.201.108.189) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 18/12/2020 20:43, Ahmed S. Darwish wrote:
> The ->notify_ha_event() hook has long been removed from the libsas event
> interface.
> 
> Remove it from documentation.
> 
> Fixes: 042ebd293b86 ("scsi: libsas: kill useless ha_event and do some cleanup")
> Signed-off-by: Ahmed S. Darwish<a.darwish@linutronix.de>
> Cc:stable@vger.kernel.org
> Cc: John Garry<john.garry@huawei.com>
> Cc: Jason Yan<yanaijie@huawei.com>

Reviewed-by: John Garry <john.garry@huawei.com>
