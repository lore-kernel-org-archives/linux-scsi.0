From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: Re: [PATCH scsi] mpt3sas: mpt3sas_base_unmap_resources can be static
Date: Fri, 28 Aug 2015 10:02:48 +0530
Message-ID: <CAK=zhgpWgOvWw2b91wBYgwWH0x3cJBpa+ntUysPEY9n=k44D=A@mail.gmail.com>
References: <201508280958.jLBYjhIZ%fengguang.wu@intel.com>
	<20150828012022.GA6922@ivytown2>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:36633 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbbH1Ecs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Aug 2015 00:32:48 -0400
Received: by obkg7 with SMTP id g7so33639120obk.3
        for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2015 21:32:48 -0700 (PDT)
In-Reply-To: <20150828012022.GA6922@ivytown2>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kbuild test robot <fengguang.wu@intel.com>
Cc: kbuild-all@01.org, James Bottomley <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn <jthumshirn@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Chaitra Basappa <chaitra.basappa@avagotech.com>

Hi,

Please consider this patch as Ack-by: Sreekanth Reddy
<sreekanth.reddy@avagotech.com>

Thanks,
Sreekanth

On Fri, Aug 28, 2015 at 6:50 AM, kbuild test robot
<fengguang.wu@intel.com> wrote:
>
> Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
> ---
>  mpt3sas_base.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index 7e8ede2..6ee54dd 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -1816,7 +1816,7 @@ _base_enable_msix(struct MPT3SAS_ADAPTER *ioc)
>   * mpt3sas_base_unmap_resources - free controller resources
>   * @ioc: per adapter object
>   */
> -void
> +static void
>  mpt3sas_base_unmap_resources(struct MPT3SAS_ADAPTER *ioc)
>  {
>         struct pci_dev *pdev = ioc->pdev;
