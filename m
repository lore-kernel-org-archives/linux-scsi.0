Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CB71C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 11:45:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0970A6145D
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 11:45:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbhENLq2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 07:46:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:36334 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229445AbhENLq1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 14 May 2021 07:46:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E6E19AC46;
        Fri, 14 May 2021 11:45:15 +0000 (UTC)
Subject: Re: [PATCH v5 06/24] mpi3mr: add support of event handling part-1
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com, sathya.prakash@broadcom.com
References: <20210513083608.2243297-1-kashyap.desai@broadcom.com>
 <20210513083608.2243297-7-kashyap.desai@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Message-ID: <df554261-87fe-f43d-d2b0-a43f4367b6a5@suse.de>
Date:   Fri, 14 May 2021 13:45:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210513083608.2243297-7-kashyap.desai@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/13/21 10:35 AM, Kashyap Desai wrote:
> Firmware can report various MPI Events.
> Support for certain Events (as listed below) are enabled in the driver
> and their processing in driver is covered in this patch.
> 
> MPI3_EVENT_DEVICE_ADDED
> MPI3_EVENT_DEVICE_INFO_CHANGED
> MPI3_EVENT_DEVICE_STATUS_CHANGE
> MPI3_EVENT_ENCL_DEVICE_STATUS_CHANGE
> MPI3_EVENT_SAS_TOPOLOGY_CHANGE_LIST
> MPI3_EVENT_SAS_DISCOVERY
> MPI3_EVENT_SAS_DEVICE_DISCOVERY_ERROR
> 
> Key support in this patch is device add/removal.
> 
> Fix some compilation warning reported by kernel test robot.
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Reported-by: kernel test robot <lkp@intel.com>
> Reviewed-by: Tomas Henzl <thenzl@redhat.com>
> Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
> 
> Cc: sathya.prakash@broadcom.com
> ---
>  drivers/scsi/mpi3mr/mpi/mpi30_api.h  |    2 +
>  drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h | 1884 ++++++++++++++++++++++++++
>  drivers/scsi/mpi3mr/mpi/mpi30_sas.h  |   37 +
>  drivers/scsi/mpi3mr/mpi3mr.h         |  202 +++
>  drivers/scsi/mpi3mr/mpi3mr_fw.c      |  197 ++-
>  drivers/scsi/mpi3mr/mpi3mr_os.c      | 1457 +++++++++++++++++++-
>  6 files changed, 3776 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
>  create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_sas.h
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)
