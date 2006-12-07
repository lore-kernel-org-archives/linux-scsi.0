From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bug 7026] CD/DVD burning with USB writer doesn't work
Date: Thu, 7 Dec 2006 13:27:52 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0612071325050.3537-100000@iolanthe.rowland.org>
References: <4577ee2b.YcNjPkzfKDfhAjUf%Joerg.Schilling@fokus.fraunhofer.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:58298 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1163169AbWLGS1x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Dec 2006 13:27:53 -0500
In-Reply-To: <4577ee2b.YcNjPkzfKDfhAjUf%Joerg.Schilling@fokus.fraunhofer.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>
Cc: michaelc@cs.wisc.edu, schilling@fokus.fraunhofer.de, linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com, dougg@torque.net, dgilbert@interlog.com

On Thu, 7 Dec 2006, Joerg Schilling wrote:

> Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > On Wed, 6 Dec 2006, Mike Christie wrote:
> >
> > > Alternatively, if we do start not checking values like max sectors and
> > > send requests down to the drivers, the block layer mapping functions can
> > > be modified to not check certain values and LLDs/scsi-ml can return
> > > these BLKERR values all the way up to sg/bsg/scsi_ioctl.c for values
> > > that they need to check.
> >
> > I bet in many cases the LLD depends on the higher layers to filter out 
> > transfers that are too large.  Duplicating all those tests in all the LLDs 
> > seems like a waste.
> 
> Once you are done with the implementation details, could you tell me what you 
> decided to add for the final implementation?

I will.  If everything goes well then BLKSECTGET will be made to work with 
the SCSI-Generic interface as well as with the usual block device files, 
so you'll be able to use it with any file descriptor for a CD or DVD 
drive.

Alan Stern

