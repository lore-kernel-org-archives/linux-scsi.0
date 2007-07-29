From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [GIT PATCH] SCSI bug fixes for 2.6.23-rc1
Date: Sun, 29 Jul 2007 18:51:35 -0400
Message-ID: <46AD19F7.7040905@garzik.org>
References: <1185720592.3434.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:38441 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965235AbXG2Wvi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Jul 2007 18:51:38 -0400
In-Reply-To: <1185720592.3434.7.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

James Bottomley wrote:
> This is basically a set of bug fixes with a few minor cleanups thrown
> in.  There are also a few bsg fixes we're taking through this tree
> because SCSI is the current sole consumer. The reason for the huge size
> is the lindent of the advansys driver along with a few cleanups.
> 
> The patch is available here:
> 
> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git


You missed
[SCSI] arcmsr: Fix hardware wait loops

	Jeff


