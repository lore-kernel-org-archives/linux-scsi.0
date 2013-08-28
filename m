From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH v3 0/6] scsi: ufs: some fixes and updates
Date: Wed, 28 Aug 2013 16:16:24 +0530
Message-ID: <521DD500.1050801@codeaurora.org>
References: <1374280885-11526-1-git-send-email-mita@fixstars.com> <1374280885-11526-3-git-send-email-mita@fixstars.com> <001b01ce8a06$514953c0$f3dbfb40$%jun@samsung.com> <003501cea26a$2c056ff0$84104fd0$%jun@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:35538 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab3H1Kqb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Aug 2013 06:46:31 -0400
In-Reply-To: <003501cea26a$2c056ff0$84104fd0$%jun@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: linux-scsi@vger.kernel.org, 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Santosh Y' <santoshsy@gmail.com>, "'James E.J. Bottomley'" <James.Bottomley@HansenPartnership.com>

Hi Santosh,

These patches looks good to me (Have already gave Reviewed-by to all 
patches). Please check if its fine to be pushed to scsi-next?

Regards,
Subhash

On 8/26/2013 8:10 PM, Seungwon Jeon wrote:
> This path series contain driver's fixes and updates.
>
> Changes in v3:
>   - Rebased with scsi-next
>
> Changes in v2:
> - [scsi: ufs: amend the ocs handling with fatal error] is excluded.
>     Host behavior needs to be defined clearly in UFSHCI specification.
> - Some minor changes are applied with comments from Subhash, Sujit and Santosh.
>
> Seungwon Jeon (6):
>        scsi: ufs: find out sense data over scsi status values
>        scsi: ufs: fix the setting interrupt aggregation counter
>        scsi: ufs: add dme configuration primitives
>        scsi: ufs: add unipro attribute IDs
>        scsi: ufs: add operation for the uic power mode change
>        scsi: ufs: configure the attribute for power mode
>
>   drivers/scsi/ufs/ufs.h    |    1 +
>   drivers/scsi/ufs/ufshcd.c |  328 ++++++++++++++++++++++++++++++++++++++-------
>   drivers/scsi/ufs/ufshcd.h |   54 ++++++++
>   drivers/scsi/ufs/ufshci.h |   22 +++-
>   drivers/scsi/ufs/unipro.h |  151 +++++++++++++++++++++
>   5 files changed, 507 insertions(+), 49 deletions(-)
>
> Thanks,
> Seungwon Jeon
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

