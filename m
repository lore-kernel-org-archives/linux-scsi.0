From: Kiwoong Kim <kwmad.kim@samsung.com>
Subject: RE: [PATCH v1 0/8] Support for Exynos specific UFS driver
Date: Fri, 07 Oct 2016 10:19:16 +0900
Message-ID: <00a401d22038$d22456e0$766d04a0$@samsung.com>
References: <006301d21fa9$70aebe80$520c3b80$@samsung.com>
 <CGME20161006191329epcas2p3d0af873317e671edbec1a3d09fced9b7@epcas2p3.samsung.com>
 <85ac557c49df48cc605813b04f3778f5@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:45739 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754374AbcJGBTT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Oct 2016 21:19:19 -0400
In-reply-to: <85ac557c49df48cc605813b04f3778f5@codeaurora.org>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Subhash Jadavani' <subhashj@codeaurora.org>
Cc: vinholikatti@gmail.com, "'Martin K. Petersen'" <martin.petersen@oracle.com>, 'James Bottomley' <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, '???' <hg.chu@samsung.com>, linux-scsi-owner@vger.kernel.org

Hi, Subhash

You're right.
I submitted one of  patches first to link to the previous summary mail
thread,
but it failed. I'll try it again.

Thank you
Regards

> Hi Kim,
> 
> 
> On 2016-10-06 01:12, Kiwoong Kim wrote:
> > This series of patches introduce support for Exynos specific UFS
> > driver.
> > An original version of this has been applied on mass production of
> > commercial mobile devices.
> >
> >  Documentation/devicetree/bindings/ufs/ufs-exynos.txt |   93 +
> >  drivers/scsi/ufs/Kconfig                                      |   10 +
> >  drivers/scsi/ufs/Makefile                                     |    1 +
> >  drivers/scsi/ufs/mphy.h                                        |   38
> > +
> >  drivers/scsi/ufs/ufs-exynos.c                                | 2084
> > ++++++++++++++++++++
> >  drivers/scsi/ufs/ufs-exynos.h                                |  621
> > ++++++
> >  drivers/scsi/ufs/ufshcd.c                                     |  146
> > +-
> >  drivers/scsi/ufs/ufshcd.h                                     |   62 +
> >  drivers/scsi/ufs/ufshci.h                                     |   14
> > +-
> >  drivers/scsi/ufs/unipro.h                                     |   24 +
> >  10 files changed, 3073 insertions(+), 20 deletions(-)  create mode
> > 100644 Documentation/devicetree/bindings/ufs/ufs-exynos.txt
> >  create mode 100644 drivers/scsi/ufs/mphy.h  create mode 100644
> > drivers/scsi/ufs/ufs-exynos.c  create mode 100644
> > drivers/scsi/ufs/ufs-exynos.h
> 
> This supposed to be 8-patch series but i only patch #1 (subject: [PATCH
> v1 1/8] ufs: add some vendor specific operations) on mailing list. Can you
> please send out the full patch series?
> 
> --
> The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a
> Linux Foundation Collaborative Project
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html


