From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [GIT PATCH] SCSI bug fixes for 2.6.23-rc1
Date: Sun, 29 Jul 2007 19:52:39 -0500
Message-ID: <1185756759.3434.19.camel@localhost.localdomain>
References: <1185720592.3434.7.camel@localhost.localdomain>
	 <46AD19F7.7040905@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:55701 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760164AbXG3Awm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Jul 2007 20:52:42 -0400
In-Reply-To: <46AD19F7.7040905@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Sun, 2007-07-29 at 18:51 -0400, Jeff Garzik wrote:
> James Bottomley wrote:
> > This is basically a set of bug fixes with a few minor cleanups thrown
> > in.  There are also a few bsg fixes we're taking through this tree
> > because SCSI is the current sole consumer. The reason for the huge size
> > is the lindent of the advansys driver along with a few cleanups.
> > 
> > The patch is available here:
> > 
> > master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git
> 
> 
> You missed
> [SCSI] arcmsr: Fix hardware wait loops

Waiting for maintainer ack ... msleep_interruptible -> ssleep is a
change with zero practical impact for this driver, so I think we can
afford to wait.

Nick is usually pretty good ... but I'll add it to scsi-pending just in
case.

James


