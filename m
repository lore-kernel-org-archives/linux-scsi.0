From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] mvsas: convert from rough draft to working driver
Date: Sat, 23 Feb 2008 11:28:50 -0500
Message-ID: <47C049C2.2010502@garzik.org>
References: <20080223131527.GB7942@ubuntu.domain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:41032 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760145AbYBWQ2y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Feb 2008 11:28:54 -0500
In-Reply-To: <20080223131527.GB7942@ubuntu.domain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ke Wei <kewei.mv@gmail.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, qswang@marvell.com, jfeng@marvell.com, qzhao@marvell.com, lil@marvell.com, saeed.bishara@gmail.com, kewei@marvell.com

Ke Wei wrote:
> Convert rough draft Marvell 6440 driver to a working driver.
> Added support for SAS and SATA devices, hotplug, wide port, and expanders.
> This patch is based on:
> branch 'mvsas' of git.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

Yay!  Perfect patch:  good tech content, applyable to #mvsas, and the 
most important part, the driver works :)

One minor (though important) detail:  may we assume this patch has the 
same Signed-off-by as previous patches?

Thanks and have a good weekend,

	Jeff



