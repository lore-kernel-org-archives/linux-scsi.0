From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [usb-storage] Re: [PATCH] fix Sony USB mass storage - pass larger
 receive buffer
Date: Thu, 13 Nov 2003 09:54:12 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0311130950090.843-100000@ida.rowland.org>
References: <20031112175627.B10818@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:2308 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S264303AbTKMOyO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2003 09:54:14 -0500
In-Reply-To: <20031112175627.B10818@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Patrick Mansfield <patmans@us.ibm.com>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, ronald@kuetemeier.com, dmitrik@users.sourceforge.net, idan@idanso.dyndns.org

On Wed, 12 Nov 2003, Matthew Dharm wrote:

> I'm starting to think that this may be the best solution -- blacklist all
> MODE_SENSE[_10] commands from all Direct-Access devices.

I was just going to suggest that myself -- or rather, blacklist all 
MODE-SENSE(x) commands from all USB disk-type devices.

Is there any strong reason not to do this?  Bear in mind that Windows 
apparently does not use these commands.  I don't see how not knowing the 
true read-write status or caching type will hurt anything.  (And the 
read-write status can be adjusted, if necessary, when a WRITE command 
fails with Medium Error: Write Protected sense.)

Alan Stern

