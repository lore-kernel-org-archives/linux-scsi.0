Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32230C433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 11:31:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 056BA61458
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 11:31:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbhENLcQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 07:32:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:56222 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229445AbhENLcP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 14 May 2021 07:32:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E605EAF4F;
        Fri, 14 May 2021 11:31:03 +0000 (UTC)
Subject: Re: [PATCH v5 01/24] mpi3mr: add mpi30 Rev-R headers and Kconfig
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com, sathya.prakash@broadcom.com,
        bvanassche@acm.org, thenzl@redhat.com, himanshu.madhani@oracle.com,
        hch@infradead.org
References: <20210513083608.2243297-1-kashyap.desai@broadcom.com>
 <20210513083608.2243297-2-kashyap.desai@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Message-ID: <82c04921-cb62-35f6-33d3-d4a0f85fb531@suse.de>
Date:   Fri, 14 May 2021 13:31:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210513083608.2243297-2-kashyap.desai@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/13/21 10:35 AM, Kashyap Desai wrote:
> This adds the Kconfig and mpi30 headers.
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> 
> Cc: sathya.prakash@broadcom.com
> Cc: bvanassche@acm.org
> Cc: thenzl@redhat.com
> Cc: hare@suse.de
> Cc: himanshu.madhani@oracle.com
> Cc: hch@infradead.org
> ---
>  drivers/scsi/Kconfig                      |    1 +
>  drivers/scsi/Makefile                     |    1 +
>  drivers/scsi/mpi3mr/Kconfig               |    7 +
>  drivers/scsi/mpi3mr/mpi/mpi30_api.h       |   18 +
>  drivers/scsi/mpi3mr/mpi/mpi30_image.h     |  220 +++++
>  drivers/scsi/mpi3mr/mpi/mpi30_init.h      |  163 ++++
>  drivers/scsi/mpi3mr/mpi/mpi30_ioc.h       | 1009 +++++++++++++++++++++
>  drivers/scsi/mpi3mr/mpi/mpi30_transport.h |  486 ++++++++++
>  8 files changed, 1905 insertions(+)
>  create mode 100644 drivers/scsi/mpi3mr/Kconfig
>  create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_api.h
>  create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_image.h
>  create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_init.h
>  create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
>  create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_transport.h
> 

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)
