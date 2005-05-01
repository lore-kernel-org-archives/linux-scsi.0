From: Mogens Valentin <monz@danbbs.dk>
Subject: Re: [Question] Does the kernel ignore errors writng to disk?
Date: Sun, 01 May 2005 11:01:38 +0200
Message-ID: <42749AF2.3010107@danbbs.dk>
References: <OF48BA3721.BD4798AD-ON88256FF2.00680E7E-88256FF2.0069814F@us.ibm.com> <1114812035.18330.396.camel@localhost.localdomain>
Reply-To: monz@danbbs.dk
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pfepc.post.tele.dk ([195.41.46.237]:27702 "EHLO
	pfepc.post.tele.dk") by vger.kernel.org with ESMTP id S261566AbVEAJAt
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 1 May 2005 05:00:49 -0400
In-Reply-To: <1114812035.18330.396.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bryan Henderson <hbryan@us.ibm.com>, Anton Altaparmakov <aia21@cam.ac.uk>, aia21@hermes.cam.ac.uk, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, mike.miller@hp.com

Alan Cox wrote:
> The next question is what the I/O device does with the data. SCSI disks
> will cache but the scsi layer uses tags and if neccessary turns the
> cache off on the drive. In other words you should get that behaviour
> correctly on SCSI media.
> 
> The default IDE behaviour doesn't turn write cache off and the IDE
> device may re-order writes and ack them before they hit storage. IDE
> lacks tags, and tends to have poor performance on cache flush commands.
> With the barrier support on the right thing should occur, or with hdparm
> used to turn the write cache off.

Is this IDE behaviour confined to IDE drives only?
SATA, when using libata, will solemnly be part of the SCSI chain, and 
hense not subject to your mentioned write cache problem, right?

-- 
Kind regards,
Mogens Valentin

