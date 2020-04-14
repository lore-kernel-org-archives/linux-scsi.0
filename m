Return-Path: <SRS0=dx4r=56=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEA15C2BA2B
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 01:39:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7C2F2072D
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 01:39:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403814AbgDNBjU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Apr 2020 21:39:20 -0400
Received: from smtp.infotech.no ([82.134.31.41]:42691 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728252AbgDNBjT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Apr 2020 21:39:19 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 7A8D220425A;
        Tue, 14 Apr 2020 03:39:16 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 2ZpwWByjkMTG; Tue, 14 Apr 2020 03:39:15 +0200 (CEST)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id F28A120414B;
        Tue, 14 Apr 2020 03:39:13 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH] scsi: sg: fix memory leak in sg_build_indirect
To:     Markus Elfring <Markus.Elfring@web.de>,
        Li Bin <huawei.libin@huawei.com>, linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "James E. J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Xie XiuQi <xiexiuqi@huawei.com>
References: <8b5551e6-46e2-9def-8ab6-ec5ba252c5ea@web.de>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <0162f996-eb48-fda5-8355-1c9bc1162177@interlog.com>
Date:   Mon, 13 Apr 2020 21:39:04 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <8b5551e6-46e2-9def-8ab6-ec5ba252c5ea@web.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-04-13 3:35 p.m., Markus Elfring wrote:
>> Fix a memory leak when there have failed, that we should free the pages
>> under the condition rem_sz > 0.
> 
> I suggest to improve the change description.
> 
> * Please use an imperative wording.

nominative, vocative, accusative, genitive ...

I have made some comment suggestions in response to the original posts
from the author.

> * Will the tag “Fixes” become relevant?

Yes, both patches from the author are fixes. These leaks would typically
appear on a system under resource pressure (specifically low memory) and
would tend to make the situation worse.

Doug Gilbert


