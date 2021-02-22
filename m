Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F3B1C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 15:41:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F89C64E74
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 15:41:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230412AbhBVPli (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Feb 2021 10:41:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23826 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231598AbhBVPlZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Feb 2021 10:41:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614008397;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YVJvqqapXzMgsYgEljuBfWpFB4kMfVqiKtazRQyJIfY=;
        b=Ei8cVEwChTImIBiHiVb3KtwCxqun+L1XaglSDoE/qIUNQMEybNASXUT6J/wPCR2FjuVZC9
        AiSpkWftl8Ja9h5o9SPAuqvegjaoc6SGo3Uu8Xv/Li9qkabS4UPkqt2J4C/QtJt26eYPtF
        YxkHT233r1qOjRSkZd1VqYj09Svn9Vw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-8GJtuswfNvuUxwxV0lkJbQ-1; Mon, 22 Feb 2021 10:39:53 -0500
X-MC-Unique: 8GJtuswfNvuUxwxV0lkJbQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B6000195D560;
        Mon, 22 Feb 2021 15:39:51 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 327195C255;
        Mon, 22 Feb 2021 15:39:50 +0000 (UTC)
Subject: Re: [PATCH 00/24] Introducing mpi3mr driver
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com
References: <20201222101156.98308-1-kashyap.desai@broadcom.com>
From:   Tomas Henzl <thenzl@redhat.com>
Message-ID: <a5a9f0bc-30f9-04f7-9bff-cf2443bd6b05@redhat.com>
Date:   Mon, 22 Feb 2021 16:39:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20201222101156.98308-1-kashyap.desai@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/22/20 11:11 AM, Kashyap Desai wrote:
> This patch series covers logical patches of the new device driver for the
> MPI3MR high performance storage I/O & RAID controllers (Avenger series).
> The mpi3mr has true multiple h/w queue interfacing like nvme.
> 
> See more info -
> https://www.spinics.net/lists/linux-scsi/msg147868.html
> 
> The controllers managed by the mpi3mr driver are capable of reaching a
> very high performance numbers compared to existing controller due to the
> new hardware architectures. This Driver is tested with the internal
> versions of the MPI3MR I/O & RAID controllers.
> 
> Patches are logical split mainly for better code review. Full patch set is
> required for functional stability of this new driver.
> 
> You can find the source at - https://github.com/kadesai16/mpi3mr_v1

This was posted months ago, If I may suggest sort out the comments and
post a V2 of  the set.
Cheers,
tomash
> 
> 
> Kashyap Desai (24):
>   mpi3mr: add mpi30 Rev-R headers and Kconfig
>   mpi3mr: base driver code
>   mpi3mr: create operational request and reply queue pair
>   mpi3mr: add support of queue command processing
>   mpi3mr: add support of internal watchdog thread
>   mpi3mr: add support of event handling part-1
>   mpi3mr: add support of event handling pcie devices part-2
>   mpi3mr: add support of event handling part-3
>   mpi3mr: add support for recovering controller
>   mpi3mr: add support of timestamp sync with firmware
>   mpi3mr: print ioc info for debugging
>   mpi3mr: add bios_param shost template hook
>   mpi3mr: implement scsi error handler hooks
>   mpi3mr: add change queue depth support
>   mpi3mr: allow certain commands during pci-remove hook
>   mpi3mr: hardware workaround for UNMAP commands to nvme drives
>   mpi3mr: add support of threaded isr
>   mpi3mr: add complete support of soft reset
>   mpi3mr: print pending host ios for debug
>   mpi3mr: wait for pending IO completions upon detection of VD IO
>     timeout
>   mpi3mr: add support of PM suspend and resume
>   mpi3mr: add support of DSN secure fw check
>   mpi3mr: add eedp dif dix support
>   mpi3mr: add event handling debug prints
> 
>  drivers/scsi/Kconfig                      |    1 +
>  drivers/scsi/Makefile                     |    1 +
>  drivers/scsi/mpi3mr/Kconfig               |    7 +
>  drivers/scsi/mpi3mr/Makefile              |    4 +
>  drivers/scsi/mpi3mr/mpi/mpi30_api.h       |   23 +
>  drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h      | 2721 ++++++++++++++
>  drivers/scsi/mpi3mr/mpi/mpi30_image.h     |  285 ++
>  drivers/scsi/mpi3mr/mpi/mpi30_init.h      |  216 ++
>  drivers/scsi/mpi3mr/mpi/mpi30_ioc.h       | 1423 +++++++
>  drivers/scsi/mpi3mr/mpi/mpi30_sas.h       |   46 +
>  drivers/scsi/mpi3mr/mpi/mpi30_transport.h |  675 ++++
>  drivers/scsi/mpi3mr/mpi/mpi30_type.h      |   89 +
>  drivers/scsi/mpi3mr/mpi3mr.h              |  906 +++++
>  drivers/scsi/mpi3mr/mpi3mr_debug.h        |   60 +
>  drivers/scsi/mpi3mr/mpi3mr_fw.c           | 3944 ++++++++++++++++++++
>  drivers/scsi/mpi3mr/mpi3mr_os.c           | 4148 +++++++++++++++++++++
>  16 files changed, 14549 insertions(+)
>  create mode 100644 drivers/scsi/mpi3mr/Kconfig
>  create mode 100644 drivers/scsi/mpi3mr/Makefile
>  create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_api.h
>  create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
>  create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_image.h
>  create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_init.h
>  create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
>  create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_sas.h
>  create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_transport.h
>  create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_type.h
>  create mode 100644 drivers/scsi/mpi3mr/mpi3mr.h
>  create mode 100644 drivers/scsi/mpi3mr/mpi3mr_debug.h
>  create mode 100644 drivers/scsi/mpi3mr/mpi3mr_fw.c
>  create mode 100644 drivers/scsi/mpi3mr/mpi3mr_os.c
> 

