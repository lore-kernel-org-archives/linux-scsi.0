Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF247C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:27:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A948561360
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:27:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbhDTC1f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 22:27:35 -0400
Received: from mail-1.ca.inter.net ([208.85.220.69]:46207 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbhDTC1d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 22:27:33 -0400
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id BC3A22EA270;
        Mon, 19 Apr 2021 22:27:02 -0400 (EDT)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id RhCMs5xarAen; Mon, 19 Apr 2021 22:07:23 -0400 (EDT)
Received: from [192.168.48.23] (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id 2DD302EA2A1;
        Mon, 19 Apr 2021 22:27:02 -0400 (EDT)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH 027/117] advansys: Convert to the scsi_status union
To:     Matthew Wilcox <willy@infradead.org>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.com>
References: <20210420000845.25873-1-bvanassche@acm.org>
 <20210420000845.25873-28-bvanassche@acm.org>
 <20210420014917.GH2531743@casper.infradead.org>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <f77989f9-f0fa-b878-f3ec-60065845f9c8@interlog.com>
Date:   Mon, 19 Apr 2021 22:27:01 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210420014917.GH2531743@casper.infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-04-19 9:49 p.m., Matthew Wilcox wrote:
> On Mon, Apr 19, 2021 at 05:07:15PM -0700, Bart Van Assche wrote:
>> An explanation of the purpose of this patch is available in the patch
>> "scsi: Introduce the scsi_status union".
> 
> That is not the correct way to write a changelog.
> 

And it is non-bisectable (I guess) and could only be made bisectable
(without some ugly unions) by rolling it up into one patch. But having
separate patches definitely makes it easier for me to look at the
sg and scsi_debug driver changes, which look fine at first glance.

Is there any way to mark a patchset like this non-bisectable? And
I think a separate patch that explains why this is being done (cause
the cover-sheet gets lost). Then git might think of a way not to
repeat that explanation 107 times.

Doug Gilbert

