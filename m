From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] Recognize missing LUNs for non-standard devices
Date: Tue, 7 Feb 2006 16:22:47 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0602071620150.5294-100000@iolanthe.rowland.org>
References: <43E906B6.3000903@netapp.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:57243 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S965116AbWBGVWv
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Feb 2006 16:22:51 -0500
In-Reply-To: <43E906B6.3000903@netapp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Wysochanski <davidw@netapp.com>
Cc: Brian King <brking@us.ibm.com>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 7 Feb 2006, David Wysochanski wrote:

> > Maybe there's a way around this.  Would it be okay to add a flag to the
> > target structure, to indicate that PDT = 0x1f should be interpreted as "No
> > LUN present"?
> > 
> > Alan Stern
> > 
> 
> I have this same problem for netapp targets (different scsi_level)
> and have been meaning to submit a patch so I'm interested in any
> patch you might have.

Okay, when I write it I'll let you know.  But first I would like to add a
bflags field to the scsi_target and fix up the flags in scsi_device.

Alan Stern

