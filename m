From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Patch: change the serial_number for error-handler commands
Date: Wed, 21 May 2003 15:57:56 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0305211556260.617-100000@ida.rowland.org>
References: <20030521180308.GD1116@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:1284 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S262237AbTEUToy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 May 2003 15:44:54 -0400
In-Reply-To: <20030521180308.GD1116@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Luben Tuikov <tluben@rogers.com>, linux-scsi@vger.kernel.org

On Wed, 21 May 2003, Mike Anderson wrote:

> I agree on the change in SCSI core instead of a change just for scsi
> error handling. If you are depending on command serial number to be
> unique as the comments in scsi_dispatch_cmd already indicate we have
> problems (in USB storage case since can_queue is 1 it would not run into a
> issue until scsi error handling).
> 
> The patch below is a quick patch that moves the serial_number from a
> scsi mid level static to a per scsi host value. In looking at the usage
> of command serial_number it appears that moving to a per scsi host name
> space should be ok.
> 
> I have compile and boot tested it on my system with the ips and aic7xxx
> drivers.
> 
> The patch needs some more testing and some variable name updates, but
> should be ok to test USB and allow for discussion of this type of
> change.

Mike:

I tried it out, and it did exactly what I wanted.  You, Luben, and the 
others can fight over the details.

Alan Stern

