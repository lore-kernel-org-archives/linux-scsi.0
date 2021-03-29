Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A18FC433C1
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 06:32:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5BDC6192B
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 06:32:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbhC2GcG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 02:32:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:34802 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230167AbhC2Gbv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Mar 2021 02:31:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E80E0B329;
        Mon, 29 Mar 2021 06:31:49 +0000 (UTC)
Subject: Re: [PATCH 5/8] scsi: remove the unchecked_isa_dma flag
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Khalid Aziz <khalid@gonehiking.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        Ondrej Zary <linux@rainbow-software.org>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20210326055822.1437471-1-hch@lst.de>
 <20210326055822.1437471-6-hch@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <6fb5fcb6-497c-f526-57dd-7625cd55a015@suse.de>
Date:   Mon, 29 Mar 2021 08:31:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210326055822.1437471-6-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/26/21 6:58 AM, Christoph Hellwig wrote:
> Remove the unchecked_isa_dma now that all users are gone.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  Documentation/scsi/scsi_mid_low_api.rst |  4 --
>  drivers/scsi/esas2r/esas2r_main.c       |  1 -
>  drivers/scsi/hosts.c                    |  7 +---
>  drivers/scsi/scsi_debugfs.c             |  1 -
>  drivers/scsi/scsi_lib.c                 | 52 +++----------------------
>  drivers/scsi/scsi_scan.c                |  6 +--
>  drivers/scsi/scsi_sysfs.c               |  2 -
>  drivers/scsi/sg.c                       | 10 +----
>  drivers/scsi/sr_ioctl.c                 | 12 ++----
>  drivers/scsi/st.c                       | 20 ++++------
>  drivers/scsi/st.h                       |  2 -
>  include/scsi/scsi_cmnd.h                |  7 ++--
>  include/scsi/scsi_host.h                |  6 ---
>  13 files changed, 25 insertions(+), 105 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
