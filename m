From: Andries Brouwer <Andries.Brouwer@cwi.nl>
Subject: Re: [usb-storage] Time to allow MODE SENSE for USB disk-type storage devices?
Date: Mon, 8 Mar 2004 21:13:29 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040308201328.GA13708@apps.cwi.nl>
References: <Pine.LNX.4.44L0.0403081046190.1187-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.cwi.nl ([192.16.191.8]:16854 "EHLO hera.cwi.nl")
	by vger.kernel.org with ESMTP id S261184AbUCHUOa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Mar 2004 15:14:30 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0403081046190.1187-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Patrick Mansfield <patmans@us.ibm.com>, USB Storage List <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, Mar 08, 2004 at 11:05:38AM -0500, Alan Stern wrote:

> Maybe it's time to think about improving the situation with MODE SENSE for 
> USB devices.  I don't know that page 0x08 is particularly crucial for USB 
> devices, but page 0x3f (for the write-protect setting) certainly would be 
> good to have.

Just to be sure: 0x3f is not the code for some particular page,
but for all available pages.

The write-protect setting is found (if it is found) in the header,
so it does not matter what page(s) we ask for, as long as we get
at least one header.

Andries
