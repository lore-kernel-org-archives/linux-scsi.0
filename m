From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [usb-storage] Re: MPIO HS200 Gigabox weird behaviour again
Date: Fri, 11 Feb 2005 14:41:25 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0502111439060.937-100000@ida.rowland.org>
References: <20050211190741.GA8641@us.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Received: from ida.rowland.org ([192.131.102.52]:18180 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S262316AbVBKTl0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Feb 2005 14:41:26 -0500
In-Reply-To: <20050211190741.GA8641@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Radovan Garabik <garabik@kassiopeia.juls.savba.sk>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 11 Feb 2005, Patrick Mansfield wrote:

> Do you have the asc/ascq for the USB device?

ASC = 0x4b, ASCQ = 0.

If you want to see the details of the entire device initialization, they 
are available at

http://kassiopeia.juls.savba.sk/~garabik/junk/gigabox.txt

Alan Stern

