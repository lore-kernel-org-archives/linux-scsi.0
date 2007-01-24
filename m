From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bug 7026] CD/DVD burning with USB writer doesn't work
Date: Wed, 24 Jan 2007 15:36:54 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0701241525160.5126-100000@iolanthe.rowland.org>
References: <1168273543.2824.13.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:37334 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751062AbXAXUgz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Jan 2007 15:36:55 -0500
In-Reply-To: <1168273543.2824.13.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 8 Jan 2007, James Bottomley wrote:

> On Mon, 2007-01-08 at 11:19 -0500, Alan Stern wrote:
> > Back in December you wrote a patch to expose the queue ioctls, and sent it
> > (off-list) to Jens Axboe and to me.  Jens spproved it, but then it
> > disappeared and was never applied.  Unfortunately I have lost my copy of
> > it.
> > 
> > If you still have the patch, could you please apply it?  If you don't, I 
> > could try to re-create it.  Or maybe Jens still has it in his email 
> > records.  Either way, please let me know.
> 
> I have it somewhere ... I was absent from the internet for 2 weeks over
> christmas, so I'm still catching up with the backlog.

Has there been time enough to catch up yet?  I'd still like the see this 
patch applied...  If you can't find it, there's a copy available here:

http://marc.theaimsgroup.com/?l=linux-scsi&m=116828430928154&w=2

While I'm bending your ear, please also consider applying these patches:

http://marc.theaimsgroup.com/?l=linux-scsi&m=116827305914482&w=2
http://marc.theaimsgroup.com/?l=linux-scsi&m=116827339011208&w=2

Thanks,

Alan Stern

