From: Paul Wagland <paul@kungfoocoder.org>
Subject: Re: megaraid /proc under kernel 2.6.2
Date: Mon, 16 Feb 2004 09:33:57 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1076920436.2022.13.camel@morsel.kungfoocoder.org>
References: <1076884890.2943.265.camel@morsel.kungfoocoder.org>
	 <40302342.10806@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out3.xs4all.nl ([194.109.24.13]:18702 "EHLO
	smtp-out3.xs4all.nl") by vger.kernel.org with ESMTP id S265433AbUBPIeX
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Feb 2004 03:34:23 -0500
In-Reply-To: <40302342.10806@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Linux SCSI mailing list <linux-scsi@vger.kernel.org>

On Mon, 2004-02-16 at 02:56, Jeff Garzik wrote:
> Paul Wagland wrote:
> > 
> > However, the /proc/megaraid directory is no longer populated, and I am
> > not quite sure why.
> 
> 
> Maybe I can address the issue another way :)
> 
> We are moving away from procfs...  so may I suggest taking this 
> opportunity to consider what procfs outputs, and a better way to provide 
> that to userspace.  Perhaps this information is already duplicated in 
> sysfs...

I think you miss the point... I was looking at _decreasing_ the amount
of work I had to do! :-)

Anyway, this sysfs stuff is something for me to look at, but at the
moment there are no attributes being exported via sysfs, I am currently
reading up on the lwn.net articles about it... I will try to submit a
patch to add some of this stuff later this week.

However, for at least edification purposes, I would still like to know
why the proc directory is not working. It appears to me that a static
global variable is not being read somehow?!? I sent a second e-mail
through about that though.

Thanks for the input,
Paul

