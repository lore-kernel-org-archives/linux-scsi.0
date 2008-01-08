From: maximilian attems <max@stro.at>
Subject: Re: Buggy Firewire bridge 'Prolific PL3507'
Date: Tue, 8 Jan 2008 21:00:46 +0100
Message-ID: <20080108200046.GV8816@baikonur.stro.at>
References: <47837E06.5080406@novell.com> <20080108140151.GD16309@parisc-linux.org> <4783B93B.70307@s5r6.in-berlin.de> <1199815847.3534.49.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:51577 "EHLO
	baikonur.stro.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbYAHUCD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jan 2008 15:02:03 -0500
Content-Disposition: inline
In-Reply-To: <1199815847.3534.49.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Matthew Wilcox <matthew@wil.cx>, Hannes Reinecke <hare@novell.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, David Zeuthen <david@fubar.dk>

On Tue, Jan 08, 2008 at 12:10:47PM -0600, James Bottomley wrote:
> 
> Not to hijack the thread, but this is getting to be a broken record.  I
> was dealing only a few days ago with a camera presenting as a mass
> storage device that was then crashing and going offline.  I looked at
> the dmesg trace which showed that the SCSI layer completes its probing
> successfully, and said it was some other extraneous command issued from
> user level causing the crash.  Sure enough, stopping hald fixed the
> camera so it functioned as a mass storage device properly.  The bug
> report is here:
> 
> https://bugs.launchpad.net/ubuntu/+source/hal/+bug/180472
> 
> What is the point of having SCSI be so careful in its probing and setup
> so as not to annoy these devices, and then have hald or another standard
> component blithely go and wreck the device by issuing unwarranted SCSI
> commands?
> 
> Can we please stop hald from issuing SCSI commands ... we should have
> the infrastructure in place now that renders this unnecessary ... unless
> there's still some information it needs that we're not providing?
> 
> James

full ack,
writing over a stupid hsdpa usb modem that stops working with hald crap.
hald keeps resetting the thingy.

-- 
maks
