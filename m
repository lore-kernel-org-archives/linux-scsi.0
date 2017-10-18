From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: Re: [PATCH V4 0/9] pm80xx updates
Date: Wed, 18 Oct 2017 10:10:34 +0200
Message-ID: <CAMGffEnsADXG-Q_4GyPhJ7aCxfFTggu-8QBeKJ7WtCoEd1-+BA@mail.gmail.com>
References: <20171018060915.8549-1-Viswas.G@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:52426 "EHLO
        mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1762692AbdJRIKz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Oct 2017 04:10:55 -0400
Received: by mail-qk0-f172.google.com with SMTP id b15so5200857qkg.9
        for <linux-scsi@vger.kernel.org>; Wed, 18 Oct 2017 01:10:55 -0700 (PDT)
In-Reply-To: <20171018060915.8549-1-Viswas.G@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Viswas G <Viswas.G@microsemi.com>
Cc: Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Vasanthalakshmi.Tharmarajan@microsemi.com, deepak.ukey@microsemi.com, Raj.Dinesh@microsemi.com, "Martin K. Petersen" <martin.petersen@oracle.com>

On Wed, Oct 18, 2017 at 8:09 AM, Viswas G <Viswas.G@microsemi.com> wrote:
>
> This patch set include some bug fixes and enhancement for pm80xx driver.
>
> Changes from V3:
>         - Fixed kbuild warnings for patch 4 and 5.
>
> Changes from V2:
>         - Corrected date.
>
> Changes from V1:
>         - sas_identify_frame_local structure moved to pm80xx_hwi.h
>         - sata abort handling patch split to four patches.
>                 - tag allocation for phy control request.
>                 - cleanup in pm8001_abort_task function.
>                 - modified port reset timer value for PM8006 card
>                 - corrected SATA abort handling sequence.
>
>
> Viswas G (9):
>   pm80xx : redefine sas_identify_frame structure
>   pm80xx : ILA and inactive firmware version through sysfs
>   pm80xx : Different SAS addresses for phys.
>   pm80xx : tag allocation for phy control request.
>   pm80xx : cleanup in pm8001_abort_task function.
>   pm80xx : modified port reset timer value for PM8006  card
>   pm80xx : corrected SATA abort handling sequence.
>   pm80xx : panic on ncq error cleaning up the read log.
>   pm80xx : corrected linkrate value.
>
>  drivers/scsi/pm8001/pm8001_ctl.c  |  54 +++++++++++++++++
>  drivers/scsi/pm8001/pm8001_hwi.c  |  11 +++-
>  drivers/scsi/pm8001/pm8001_init.c |  13 +++--
>  drivers/scsi/pm8001/pm8001_sas.c  | 119 +++++++++++++++++++++++++-------------
>  drivers/scsi/pm8001/pm8001_sas.h  |  10 ++++
>  drivers/scsi/pm8001/pm80xx_hwi.c  |  62 ++++++++++++++++----
>  drivers/scsi/pm8001/pm80xx_hwi.h  | 102 +++++++++++++++++++++++++++++++-
>  7 files changed, 313 insertions(+), 58 deletions(-)
>
> --
> 2.12.3
>
Thanks Viswas for the effort. I think it's good to go.

Jack Wang
