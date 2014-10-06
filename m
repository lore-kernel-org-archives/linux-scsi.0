From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH -next] scsi: ufs: fix configuring power mode after UIC
 link down
Date: Mon, 6 Oct 2014 16:14:20 +0900
Message-ID: <CAC5umyjoxNJ=iWDX8s7Kjt8E3xQ7rvjT6uioD8ZdREGqZ0njvw@mail.gmail.com>
References: <1412493638-24522-1-git-send-email-akinobu.mita@gmail.com>
	<000101cfe0ed$1e3dc7b0$5ab95710$@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:65080 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbaJFHOV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Oct 2014 03:14:21 -0400
Received: by mail-lb0-f176.google.com with SMTP id p9so3754923lbv.35
        for <linux-scsi@vger.kernel.org>; Mon, 06 Oct 2014 00:14:20 -0700 (PDT)
In-Reply-To: <000101cfe0ed$1e3dc7b0$5ab95710$@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Subhash Jadavani <subhashj@codeaurora.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Akinobu Mita <mita@fixstars.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Santosh Y <santoshsy@gmail.com>, Dolev Raviv <draviv@codeaurora.org>, Yaniv Gardi <ygardi@codeaurora.org>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <JBottomley@parallels.com>

Hi Subhash,

2014-10-06 7:38 GMT+09:00 Subhash Jadavani <subhashj@codeaurora.org>:
> Hi Akinobu,
>
> Thanks for the patch. After you reported the issue, I was looking through
> our driver to make sure that why this issue was not catched and in fact it's
> already have a fix internally and it was yet to be send upstream.
> I am fine with your patch but our approach to fix the mentioned issue looks
> more complete.
> Here is what how we fixed it:
>         - After UFS link startup in ufshcd_probe(), link would anyway be in
> PWM-G1, 1-lane, SLOW-AUTO mode so we would call a function namated
> ufshcd_init_pwr_info() which would set the hba->pwr_info to reflect the
> correct power mode after link startup. Here is the code reference:
> https://www.codeaurora.org/cgit/quic/femto/kernel/msm-3.10/tree/drivers/scsi
> /ufs/ufshcd.c?h=caf/msm-3.10#n4818. It would be good if you can adapt this
> fix in your current patch.

This looks more appropriate way to fix this problem.  So I withdraw this
patch.  As this problem is not a regression, could you fix this in that
way in your appropriate timing?

Thanks for taking care of this.
