From: Lee Duncan <lduncan@suse.com>
Subject: Re: [PATCH 00/13] use setup_timer() helper function.
Date: Fri, 22 Sep 2017 12:25:28 -0700
Message-ID: <075d0d82-2d9b-7282-f1e5-f992b56ec398@suse.com>
References: <1506073905-12985-1-git-send-email-allen.lkml@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54756 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751795AbdIVTZi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 Sep 2017 15:25:38 -0400
In-Reply-To: <1506073905-12985-1-git-send-email-allen.lkml@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Allen Pais <allen.lkml@gmail.com>, linux-scsi@vger.kernel.org
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux@armlinux.org.uk, oliver@neukum.org, aliakc@web.de, lenehan@twibble.org, cleech@redhat.com, matthew@wil.cx

On 09/22/2017 02:51 AM, Allen Pais wrote:
> This series uses setup_timer() helper function. The series
> addresses the files under drivers/scsi/*.
> 
> Allen Pais (13):
>   scsi: sym53c8xx: use setup_timer() helper.
>   scsi: qla2xxx: use setup_timer() helper.
>   scsi: esas2r: use setup_timer() helper.
>   scsi: bnx2i: use setup_timer() helper.
>   scsi: arcmsr: use setup_timer() helper.
>   scsi: be2iscsi: use setup_timer() helper.
>   scsi: qla4xxx: use setup_timer() helper.
>   scsi: ncr53c8xx: use setup_timer() helper.
>   scsi: arm: fas216: use setup_timer() helper.
>   scsi: libiscsi: use setup_timer() helper.
>   scsi: dc395x: use setup_timer() helper.
>   scsi: qla2xxx: use setup_timer() helper.
>   scsi: bfa: use setup_timer() helper.
> 
>  drivers/scsi/arcmsr/arcmsr_hba.c    | 10 ++++------
>  drivers/scsi/arm/fas216.c           |  4 +---
>  drivers/scsi/be2iscsi/be_main.c     |  5 ++---
>  drivers/scsi/bfa/bfad.c             |  4 +---
>  drivers/scsi/bnx2i/bnx2i_iscsi.c    | 14 +++++---------
>  drivers/scsi/dc395x.c               |  4 +---
>  drivers/scsi/esas2r/esas2r_main.c   |  4 +---
>  drivers/scsi/libiscsi.c             |  5 ++---
>  drivers/scsi/ncr53c8xx.c            |  4 +---
>  drivers/scsi/qla2xxx/qla_inline.h   |  5 ++---
>  drivers/scsi/qla2xxx/qla_os.c       |  5 ++---
>  drivers/scsi/qla4xxx/ql4_os.c       |  5 ++---
>  drivers/scsi/sym53c8xx_2/sym_glue.c |  4 +---
>  13 files changed, 25 insertions(+), 48 deletions(-)
> 

Please add for the whole series:

Acked-by: Lee Duncan <lduncan@suse.com>

-- 
Lee Duncan
SUSE Labs
