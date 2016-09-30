From: Kiwoong Kim <kwmad.kim@samsung.com>
Subject: RE: [PATCH -next] scsi: ufs: fix error return code in ufshcd_init()
Date: Fri, 30 Sep 2016 10:19:51 +0900
Message-ID: <003e01d21ab8$be0b6c50$3a2244f0$@samsung.com>
References: <1475074182-13038-1-git-send-email-weiyj.lk@gmail.com>
 <CGME20160928224948epcas2p3b072781efb2cee0ba67f2a6bc30fbb59@epcas2p3.samsung.com>
 <ce37f469faab393f53a9896e3b603843@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:57472 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935413AbcI3BTy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2016 21:19:54 -0400
In-reply-to: <ce37f469faab393f53a9896e3b603843@codeaurora.org>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: subhashj@codeaurora.org, 'Wei Yongjun' <weiyj.lk@gmail.com>
Cc: 'Vinayak Holikatti' <vinholikatti@gmail.com>, "'James E.J. Bottomley'" <jejb@linux.vnet.ibm.com>, "'Martin K. Petersen'" <martin.petersen@oracle.com>, 'Wei Yongjun' <weiyongjun1@huawei.com>, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org

Reviewed-by: Kiwoong Kim <kwmad.kim@samsung.com>

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of subhashj@codeaurora.org
> Sent: Thursday, September 29, 2016 7:50 AM
> To: Wei Yongjun
> Cc: Vinayak Holikatti; James E.J. Bottomley; Martin K. Petersen; Wei
> Yongjun; linux-scsi@vger.kernel.org; linux-scsi-owner@vger.kernel.org
> Subject: Re: [PATCH -next] scsi: ufs: fix error return code in
> ufshcd_init()
> 
> Looks good to me.
> Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
> 
> On 2016-09-28 07:49, Wei Yongjun wrote:
> > From: Wei Yongjun <weiyongjun1@huawei.com>
> >
> > Fix to return a negative error code from the error handling case
> > instead of 0, as done elsewhere in this function.
> >
> > Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> > ---
> >  drivers/scsi/ufs/ufshcd.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index 37f3c51..6aebb7e 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -6500,6 +6500,7 @@ int ufshcd_init(struct ufs_hba *hba, void
> > __iomem *mmio_base, unsigned int irq)
> >  		if (IS_ERR(hba->devfreq)) {
> >  			dev_err(hba->dev, "Unable to register with
> devfreq %ld\n",
> >  					PTR_ERR(hba->devfreq));
> > +			err = PTR_ERR(hba->devfreq);
> >  			goto out_remove_scsi_host;
> >  		}
> >  		/* Suspend devfreq until the UFS device is detected */
> >
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> > in
> > the body of a message to majordomo@vger.kernel.org More majordomo info
> > at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html


