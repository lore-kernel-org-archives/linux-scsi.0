From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: iRiver H100 series and usb-storage issues
Date: Mon, 7 Jun 2004 10:47:31 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0406071040310.1800-100000@ida.rowland.org>
References: <1086533333.10787.45.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:11780 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S264720AbUFGOrb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2004 10:47:31 -0400
In-Reply-To: <1086533333.10787.45.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, Philippe Troin <phil@fifi.org>
Cc: USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

I just noticed this thread on linux-kernel:

http://marc.theaimsgroup.com/?l=linux-kernel&m=108372064000188&w=2

Apparently under some circumstances the iRiver H100 returns 0 bytes 
transferred with GOOD status and residue=512 for a READ(10) command 
asking for 1 sector.  As far as I know this is legal, and it indicates the 
command should simply be retried.

But apparently the sd driver doesn't realize what has happened and assumes 
the transfer was successful.  If I'm right then the sd driver should be 
fixed, but I'm not sure what is the best thing to do.

James, can you offer some advice?

Alan Stern

