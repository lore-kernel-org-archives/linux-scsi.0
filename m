From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 0/4] mpt3sas driver Enhancements and
Date: Fri, 20 Jan 2017 09:53:42 +0100
Message-ID: <20170120085342.GC3279@linux-x5ow.site>
References: <1484840950-13656-1-git-send-email-chaitra.basappa@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42664 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751769AbdATIxq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Jan 2017 03:53:46 -0500
Content-Disposition: inline
In-Reply-To: <1484840950-13656-1-git-send-email-chaitra.basappa@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chaitra P B <chaitra.basappa@broadcom.com>
Cc: JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, krishnaraddi.mankani@broadcom.com, linux-kernel@vger.kernel.org, suganath-prabu.subramani@broadcom.com, sreekanth.reddy@broadcom.com

On Thu, Jan 19, 2017 at 09:19:06PM +0530, Chaitra P B wrote:
> Here is the change list:
> Posting 4 patches for mpt3sas driver enhancement and defect fixes.
>   * Handle cable event for notifying degraded speed.
>   * Performance improvement for Crusader.
>   * Fix Firmware fault state 0x2100 during heavy 4K RR
>     FIO stress test.
>   * Updated driver version to 15.100.00.00
> 
> Chaitra P B (4):
>   mpt3sas: Added print to notify cable running at a      degraded
>     speed.
>   mpt3sas: Fix for Crusader to achieve product targets with      SAS
>     devices.
>   mpt3sas: Fix Firmware fault state 0x2100 during heavy 4K RR      FIO
>     stress test.
>   mpt3sas: Bump driver version to 15.100.00.00
> 
>  drivers/scsi/mpt3sas/mpi/mpi2_ioc.h  |    2 +
>  drivers/scsi/mpt3sas/mpt3sas_base.c  |   20 ++++++++++++++
>  drivers/scsi/mpt3sas/mpt3sas_base.h  |    7 +++--
>  drivers/scsi/mpt3sas/mpt3sas_ctl.c   |    4 ++-
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c |   47 +++++++++++++++++++++++++++++----
>  5 files changed, 70 insertions(+), 10 deletions(-)

Please be sure you have appropriate Signed-off-by lines on all of your
patches, thanks.

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
