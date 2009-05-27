From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH 25/20] sysfs: Only support removing emtpy sysfs  directories.
Date: Wed, 27 May 2009 11:24:38 -0700
Message-ID: <m1hbz69zfd.fsf@fess.ebiederm.org>
References: <Pine.LNX.4.44L0.0905271410410.15690-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out01.mta.xmission.com ([166.70.13.231]:43415 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933633AbZE0SYq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 May 2009 14:24:46 -0400
In-Reply-To: <Pine.LNX.4.44L0.0905271410410.15690-100000@iolanthe.rowland.org> (Alan Stern's message of "Wed\, 27 May 2009 14\:15\:42 -0400 \(EDT\)")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kay Sievers <kay.sievers@vrfy.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@suse.de>, Kernel development list <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org, "Eric W. Biederman" <ebiederm@aristanetworks.com>

Alan Stern <stern@rowland.harvard.edu> writes:

>
> As fas as I know, they can't.  Instead, they can cause the SCSI layer 
> to unregister a sysfs directory containing a child directory.  :-)
>
> Basically, a user program can delay removal of the child (i.e., the
> target) directory indefinitely, because currently the target isn't
> unregistered when all its children are removed -- it's unregistered
> when all its children are _released_.

Ok.  Is this opens of /dev/sda1 and the like that are being held open by
userspace that are potentially causing problems?

I think I have the fix to that...

Eric
