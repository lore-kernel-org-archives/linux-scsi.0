From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: [PATCH 0/8] pm80xx: Driver updates
Date: Wed, 29 Jul 2015 11:10:49 +0200
Message-ID: <CAD+HZHVFqmT43PeJL=C1u1dwEi=T8_t_sS5wbc8Dv8EMUdUDsg@mail.gmail.com>
References: <1438151240-4097-1-git-send-email-Viswas.G@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:33094 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbbG2JKv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jul 2015 05:10:51 -0400
Received: by laah7 with SMTP id h7so2378264laa.0
        for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2015 02:10:49 -0700 (PDT)
In-Reply-To: <1438151240-4097-1-git-send-email-Viswas.G@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Viswas G <Viswas.G@pmcs.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <JBottomley@parallels.com>, Tomas Henzl <thenzl@redhat.com>, Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>

2015-07-29 8:27 GMT+02:00  <Viswas.G@pmcs.com>:
> From: Viswas G <Viswas.G@pmcs.com>
>
> This patch set contains bug fixes for pm80xx driver.
> Please consider these patches for next kernel release.
>
> Viswas G (8):
>   pm80xx: Updated link rate
>   pm80xx: Corrected device state changes in I_T_Nexus_Reset
>   pm80xx: Update For Thermal Page Code
>   pm80xx: Fix for Incorrect DMA Unmapping of SG List
>   pm80xx: Remove unnecessary phy disconnect while link error
>   pm80xx: Add PORT RECOVERY TIMEOUT support
>   pm80xx: Handling Invalid SSP Response frame
>   pm80xx: Bump pm80xx driver version to 0.1.38
>
>  drivers/scsi/pm8001/pm8001_defs.h |    1 +
>  drivers/scsi/pm8001/pm8001_hwi.c  |    4 +
>  drivers/scsi/pm8001/pm8001_sas.c  |   15 ++++-
>  drivers/scsi/pm8001/pm8001_sas.h  |   12 +++-
>  drivers/scsi/pm8001/pm80xx_hwi.c  |  111 +++++++++++++++++++++++++++----------
>  drivers/scsi/pm8001/pm80xx_hwi.h  |    5 +-
>  6 files changed, 112 insertions(+), 36 deletions(-)
>
For the whole patchset:

Reviewed-by: Jack Wang <jinpu.wang@profitbricks.com>

PS: company policy requests to use the email address of the company,
please cc me to above address next time, I will send a patch to update
my email
in MAINTAINERS file.

Thanks
Jack
