From: Jens Axboe <axboe@suse.de>
Subject: Re: CDROMSUBCHNL. . .
Date: Mon, 27 Sep 2004 08:19:17 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040927061916.GE2288@suse.de>
References: <007101c4a445$7f150840$0201010a@ankkennedy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:63676 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S266175AbUI0GVi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Sep 2004 02:21:38 -0400
Content-Disposition: inline
In-Reply-To: <007101c4a445$7f150840$0201010a@ankkennedy>
List-Id: linux-scsi@vger.kernel.org
To: Andy Kennedy <akennedy@wpid-am.com>
Cc: linux-scsi@vger.kernel.org

On Sun, Sep 26 2004, Andy Kennedy wrote:
> Hi all,
> 
> I use the sr_ioctl calls in a program that I wrote to record tracks off CDs.
> The most important one that I use is CDROMSUBCHNL.  I found that in 2.2.16
> "case CDROMSUBCHNL" was removed without documentation.  I have grepped all
> around in that kernel and also in the one before it and found nothing about
> why it was to be removed.  Anyone have any idea why it got taken out and can
> we put it back in?

Nonsense, noone removed the CDROMSUBCHNL ioctl.

-- 
Jens Axboe

