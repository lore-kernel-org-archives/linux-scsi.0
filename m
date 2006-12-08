From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bug 7026] CD/DVD burning with USB writer doesn't work
Date: Fri, 8 Dec 2006 10:46:54 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0612081046060.2983-100000@iolanthe.rowland.org>
References: <45795e64.5YR0KEYlCvFrV8Ni%Joerg.Schilling@fokus.fraunhofer.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:55718 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1425574AbWLHPq4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Dec 2006 10:46:56 -0500
In-Reply-To: <45795e64.5YR0KEYlCvFrV8Ni%Joerg.Schilling@fokus.fraunhofer.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>
Cc: schilling@fokus.fraunhofer.de, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com, dougg@torque.net, dgilbert@interlog.com

On Fri, 8 Dec 2006, Joerg Schilling wrote:

> Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > I will.  If everything goes well then BLKSECTGET will be made to work with 
> > the SCSI-Generic interface as well as with the usual block device files, 
> > so you'll be able to use it with any file descriptor for a CD or DVD 
> > drive.
> 
> Coud you please inform me if this has been done?

I will let you know and I will make sure you receive the patch.

Alan Stern

