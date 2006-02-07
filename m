From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] Recognize missing LUNs for non-standard devices
Date: Tue, 7 Feb 2006 10:29:34 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0602071027340.5164-100000@iolanthe.rowland.org>
References: <43E8B9EA.7050707@us.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:25769 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP
	id S1751111AbWBGP3f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Feb 2006 10:29:35 -0500
In-Reply-To: <43E8B9EA.7050707@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 7 Feb 2006, Brian King wrote:

> > I was afraid that might happen.  Okay, forget the patch.
> > 
> > How come you didn't mention the ipr driver before when I first raised the 
> > possibility of making this change?
> 
> Sorry about that... I wanted to verify on my end that the scsi level getting
> returned was 0 before doing so. Your repost was a reminder...

Maybe there's a way around this.  Would it be okay to add a flag to the 
target structure, to indicate that PDT = 0x1f should be interpreted as "No 
LUN present"?

Alan Stern

