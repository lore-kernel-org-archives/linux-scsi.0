From: vinayak holikatti <vinholikatti@gmail.com>
Subject: Re: [PATCH V6 Resend 0/4] [SCSI] ufs: Adds glue drivers to ufshcd
Date: Mon, 25 Feb 2013 21:48:05 +0530
Message-ID: <CAKVbJB-Q+3VZBu+vw_y94EKgKXVLhaO2Ue369mEPiLF2j_u5sg@mail.gmail.com>
References: <1361808875-2803-1-git-send-email-vinholikatti@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f175.google.com ([209.85.216.175]:54245 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758979Ab3BYQSI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Feb 2013 11:18:08 -0500
In-Reply-To: <1361808875-2803-1-git-send-email-vinholikatti@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, santoshsy@gmail.com, arnd@linaro.org, linux-samsung-soc@vger.kernel.org, venkat@linaro.org, subhashj@codeaurora.org, sthumma@codeaurora.org, merez@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>

James,

I have rebased these patches with top scsi-misc tree.


On Mon, Feb 25, 2013 at 9:44 PM, Vinayak Holikatti
<vinholikatti@gmail.com> wrote:
> This patch set adds following features
>  - Seggregate PCI specific code in ufshcd.c and corrected copyright
>  - Adds PCI glue driver ufshcd-pci.c and ufshcd.c become core module
>  - Adds Platform glue driver ufshcd-pltfrm.c
>  - Update correct transfer size in Command UPIU
>
> Vinayak Holikatti (4):
>   [SCSI] drivers/scsi/ufs: Seggregate PCI Specific Code
>   [SCSI] drivers/scsi/ufs: Separate PCI code into glue driver
>   [SCSI] ufs: Add Platform glue driver for ufshcd
>   [SCSI] ufs: Correct the expected data transfersize
>
>  drivers/scsi/ufs/Kconfig         |   87 +++++---
>  drivers/scsi/ufs/Makefile        |    2 +
>  drivers/scsi/ufs/ufs.h           |   44 ++---
>  drivers/scsi/ufs/ufshcd-pci.c    |  211 +++++++++++++++++++
>  drivers/scsi/ufs/ufshcd-pltfrm.c |  217 +++++++++++++++++++
>  drivers/scsi/ufs/ufshcd.c        |  425 ++++++++------------------------------
>  drivers/scsi/ufs/ufshcd.h        |  202 ++++++++++++++++++
>  drivers/scsi/ufs/ufshci.h        |   44 ++---
>  8 files changed, 811 insertions(+), 421 deletions(-)
>  create mode 100644 drivers/scsi/ufs/ufshcd-pci.c
>  create mode 100644 drivers/scsi/ufs/ufshcd-pltfrm.c
>  create mode 100644 drivers/scsi/ufs/ufshcd.h
>
> --
> 1.7.5.4
>
