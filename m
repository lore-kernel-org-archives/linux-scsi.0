From: Alan Stern <stern@rowland.harvard.edu>
Subject: Sysfs attribute file for max_sectors
Date: Tue, 6 Jan 2004 13:07:08 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0401061301230.1043-100000@ida.rowland.org>
References: <20040106091538.A10957@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:14084 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S264563AbUAFSHI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jan 2004 13:07:08 -0500
In-Reply-To: <20040106091538.A10957@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@one-eyed-alien.net>

Some USB Mass Storage devices need max_sectors set as low as 64 KB per
transfer.  Many devices don't have this restriction, though, and it would
be nice to give users an easy way to change the value.  Especially if we
play it safe by starting with the default value set low; that way more
capable devices wouldn't have to be penalized.

The simplest way to export max_sectors to user processes is as a sysfs 
attribute.  We have code that will do this for USB devices, but perhaps it 
would be better as a general feature available for all SCSI devices.

What's your feeling?  Should max_sectors be exported for all SCSI devices 
or only for USB mass storage devices?

Alan Stern

