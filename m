From: Santosh Y <santoshsy@gmail.com>
Subject: Re: [PATCH 0/9] scsi:ufs: query, bkops support and other fixes
Date: Tue, 30 Jul 2013 00:35:05 +0530
Message-ID: <CALMYJDsLgt=AOKyuj5GP284HWiawsG3PgZ5iXq7o2991CV_4QA@mail.gmail.com>
References: <1375031437-10206-1-git-send-email-santoshsy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f42.google.com ([209.85.214.42]:41444 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060Ab3G2TF0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jul 2013 15:05:26 -0400
Received: by mail-bk0-f42.google.com with SMTP id jk14so523022bkc.1
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jul 2013 12:05:25 -0700 (PDT)
In-Reply-To: <1375031437-10206-1-git-send-email-santoshsy@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, Santosh Y <santoshsy@gmail.com>

On Sun, Jul 28, 2013 at 10:40 PM, Santosh Y <santoshsy@gmail.com> wrote:
> Hi James,
>
> Please apply the following patches to 'misc' branch.
>
> Thanks,
> Santosh
>
> Akinobu Mita (3):
>   ufshcd-pci: release ioremapped region during removing driver
>   ufs: don't disable_irq() if the IRQ can be shared among devices
>   ufs: don't stop controller before scsi_remove_host()
>
> Dolev Raviv (1):
>   scsi: ufs: Set fDeviceInit flag to initiate device initialization
>
> Sujit Reddy Thumma (3):
>   scsi: ufs: Add support for sending NOP OUT UPIU
>   scsi: ufs: Add support for host assisted background operations
>   scsi: ufs: Add runtime PM support for UFS host controller driver
>
> Wei Yongjun (1):
>   ufshcd-pltfrm: remove redundant dev_err call in ufshcd_pltfrm_probe()
>
> Wolfram Sang (1):
>   drivers/scsi/ufs: don't check resource with devm_ioremap_resource
>
>  drivers/scsi/ufs/ufs.h           |  155 ++++-
>  drivers/scsi/ufs/ufshcd-pci.c    |   99 ++--
>  drivers/scsi/ufs/ufshcd-pltfrm.c |   55 +-
>  drivers/scsi/ufs/ufshcd.c        | 1170 ++++++++++++++++++++++++++++++++++----
>  drivers/scsi/ufs/ufshcd.h        |   59 +-
>  drivers/scsi/ufs/ufshci.h        |    2 +-
>  6 files changed, 1374 insertions(+), 166 deletions(-)
>
> --
> 1.8.3.1
>

Hi James,

Please ignore the above patch-sets, I'll resend the series with a
minor correction.

Thanks,
Santosh
