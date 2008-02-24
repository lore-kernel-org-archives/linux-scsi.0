From: Ke Wei <kewei.mv@gmail.com>
Subject: Re: [PATCH] mvsas: convert from rough draft to working driver
Date: Sun, 24 Feb 2008 19:48:06 +0800
Message-ID: <20080224114806.GA7908@ubuntu.domain>
References: <20080223131527.GB7942@ubuntu.domain> <47C049C2.2010502@garzik.org>
Reply-To: Ke Wei <kewei.mv@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.228]:54788 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbYBXLrM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Feb 2008 06:47:12 -0500
Received: by wr-out-0506.google.com with SMTP id c48so1667967wra.23
        for <linux-scsi@vger.kernel.org>; Sun, 24 Feb 2008 03:47:11 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <47C049C2.2010502@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Ke Wei <kewei.mv@gmail.com>, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, qswang@marvell.com, jfeng@marvell.com, qzhao@marvell.com, lil@marvell.com, saeed.bishara@gmail.com, kewei@marvell.com

On Sat, Feb 23, 2008 at 11:28:50AM -0500, Jeff Garzik wrote:
> Ke Wei wrote:
> >Convert rough draft Marvell 6440 driver to a working driver.
> >Added support for SAS and SATA devices, hotplug, wide port, and expanders.
> >This patch is based on:
> >branch 'mvsas' of 
> >git.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
> 
> Yay!  Perfect patch:  good tech content, applyable to #mvsas, and the 
> most important part, the driver works :)
> 
> One minor (though important) detail:  may we assume this patch has the 
> same Signed-off-by as previous patches?
>

Oah, I have no idea how to diff between the previous 5th commit and
current to use git-format-patch command, so I had to use git-diff to
create patch. As a result, I format to place my Signed-off-by when
sending email.
Jeff, Do you have a good suggestion?  Thank you for your help.

Now,
Signed-off-by: Ke Wei <kewei@marvell.com>
 
> Thanks and have a good weekend,
> 
> 	Jeff
> 
