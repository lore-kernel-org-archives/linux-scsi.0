Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D972C433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 07:59:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E36AF619D9
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 07:59:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234231AbhCaH7Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 Mar 2021 03:59:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:43836 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234222AbhCaH7J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 Mar 2021 03:59:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5D584AF42;
        Wed, 31 Mar 2021 07:59:08 +0000 (UTC)
Subject: Re: [PATCH 4/8] advansys: remove ISA support
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Khalid Aziz <khalid@gonehiking.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        Ondrej Zary <linux@rainbow-software.org>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20210331073001.46776-1-hch@lst.de>
 <20210331073001.46776-5-hch@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <18f2c49e-5581-1657-cbc3-8e5a5dee2c98@suse.de>
Date:   Wed, 31 Mar 2021 09:59:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210331073001.46776-5-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/31/21 9:29 AM, Christoph Hellwig wrote:
> This is the last piece in the kernel requiring the block layer ISA
> bounce buffering, and it does not actually look used.  So remove it
> to see if anyone screams, in which case we'll need to find a solution
> to fix it back up.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
> Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  drivers/scsi/advansys.c | 321 ++++------------------------------------
>  1 file changed, 32 insertions(+), 289 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
