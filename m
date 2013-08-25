From: "Dolev Raviv" <draviv@codeaurora.org>
Subject: Re: [PATCH v2 0/6] scsi: ufs: some fixes and updates
Date: Sun, 25 Aug 2013 11:23:49 -0000
Message-ID: <7a1998216c6ef0102a65f751c5ac8174.squirrel@www.codeaurora.org>
References: <1374280885-11526-1-git-send-email-mita@fixstars.com>
    <1374280885-11526-3-git-send-email-mita@fixstars.com>
    <001b01ce8a06$514953c0$f3dbfb40$%jun@samsung.com>
    <002b01cea000$ade40890$09ac19b0$%jun@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:58148 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218Ab3HYLXu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Aug 2013 07:23:50 -0400
In-Reply-To: <002b01cea000$ade40890$09ac19b0$%jun@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: linux-scsi@vger.kernel.org, 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Santosh Y' <santoshsy@gmail.com>, "'James E.J. Bottomley'" <jbottomley@parallels.com>

Hi Jeon,
Can you specify your dependencies pleas. I was having trouble applying it
above scsi/misc branch with the following patches:

Sujit Reddy Thumma (4):
  scsi: ufs: Fix broken task management command implementation
  scsi: ufs: Fix hardware race conditions while aborting a command
  scsi: ufs: Fix device and host reset methods
  scsi: ufs: Improve UFS fatal error handling

> This path series contain driver's fixes and updates.
>
> Changes in v2:
> - [scsi: ufs: amend the ocs handling with fatal error] is excluded.
>    Host behavior needs to be defined clearly in UFSHCI specification.
> - Some minor changes are applied with comments from Subhash, Sujit and
> Santosh.
>
> Seungwon Jeon (6):
>       scsi: ufs: find out sense data over scsi status values
>       scsi: ufs: fix the setting interrupt aggregation counter
>       scsi: ufs: add dme configuration primitives
>       scsi: ufs: add unipro attribute IDs
>       scsi: ufs: add operation for the uic power mode change
>       scsi: ufs: configure the attribute for power mode
>
>  drivers/scsi/ufs/ufs.h    |    1 +
>  drivers/scsi/ufs/ufshcd.c |  336
> ++++++++++++++++++++++++++++++++++++++-------
>  drivers/scsi/ufs/ufshcd.h |   54 +++++++
>  drivers/scsi/ufs/ufshci.h |   22 +++-
>  drivers/scsi/ufs/unipro.h |  151 ++++++++++++++++++++
>  5 files changed, 513 insertions(+), 51 deletions(-)
>
> Thanks,
> Seungwon Jeon
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation

