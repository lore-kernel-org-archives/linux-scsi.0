From: "Andy Kennedy" <akennedy@wpid-am.com>
Subject: Re: CDROMSUBCHNL. . .
Date: Mon, 27 Sep 2004 11:08:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <001c01c4a4ac$493a8a80$0201010a@ankkennedy>
References: <007101c4a445$7f150840$0201010a@ankkennedy> <20040927061916.GE2288@suse.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dadsl-206-41.webshoppe.net ([65.161.206.41]:26899 "EHLO
	mail.wpid-am.com") by vger.kernel.org with ESMTP id S266705AbUI0QIe
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Sep 2004 12:08:34 -0400
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-scsi@vger.kernel.org

Thank you so much for your prompt responce.  Could you please tell me where
I can find this call in the code now, or more specifically how I can poll my
CDROM for its current state?

Thanks,
Andy
----- Original Message ----- 
From: "Jens Axboe" <axboe@suse.de>
To: "Andy Kennedy" <akennedy@wpid-am.com>
Cc: <linux-scsi@vger.kernel.org>
Sent: Monday, September 27, 2004 1:19 AM
Subject: Re: CDROMSUBCHNL. . .


> On Sun, Sep 26 2004, Andy Kennedy wrote:
> > Hi all,
> >
> > I use the sr_ioctl calls in a program that I wrote to record tracks off
CDs.
> > The most important one that I use is CDROMSUBCHNL.  I found that in
2.2.16
> > "case CDROMSUBCHNL" was removed without documentation.  I have grepped
all
> > around in that kernel and also in the one before it and found nothing
about
> > why it was to be removed.  Anyone have any idea why it got taken out and
can
> > we put it back in?
>
> Nonsense, noone removed the CDROMSUBCHNL ioctl.
>
> -- 
> Jens Axboe

