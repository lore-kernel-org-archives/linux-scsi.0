From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] mvsas: convert from rough draft to working driver
Date: Mon, 25 Feb 2008 18:11:16 -0500
Message-ID: <47C34B14.4040509@garzik.org>
References: <20080223131527.GB7942@ubuntu.domain> <47C049C2.2010502@garzik.org> <20080224114806.GA7908@ubuntu.domain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:55567 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294AbYBYXLT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Feb 2008 18:11:19 -0500
In-Reply-To: <20080224114806.GA7908@ubuntu.domain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ke Wei <kewei.mv@gmail.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, qswang@marvell.com, jfeng@marvell.com, qzhao@marvell.com, lil@marvell.com, saeed.bishara@gmail.com, kewei@marvell.com

Ke Wei wrote:
> On Sat, Feb 23, 2008 at 11:28:50AM -0500, Jeff Garzik wrote:
>> Ke Wei wrote:
>>> Convert rough draft Marvell 6440 driver to a working driver.
>>> Added support for SAS and SATA devices, hotplug, wide port, and expanders.
>>> This patch is based on:
>>> branch 'mvsas' of 
>>> git.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
>> Yay!  Perfect patch:  good tech content, applyable to #mvsas, and the 
>> most important part, the driver works :)
>>
>> One minor (though important) detail:  may we assume this patch has the 
>> same Signed-off-by as previous patches?
>>
> 
> Oah, I have no idea how to diff between the previous 5th commit and
> current to use git-format-patch command, so I had to use git-diff to
> create patch. As a result, I format to place my Signed-off-by when
> sending email.
> Jeff, Do you have a good suggestion?  Thank you for your help.

That's just a simple mistake, so I wouldn't worry about it.  We all 
forget such things, every now and then.

If I forget to sign-off on a patch, I usually just reply to my own email 
(publicly), providing the Signed-off-by line requested...  which is 
precisely what you did below :)


> Signed-off-by: Ke Wei <kewei@marvell.com>

Thanks!

	Jeff



