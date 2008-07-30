From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [usb-storage] BUG: SCSI: usb storage SDHC card doesn't work in
 2.6.27-rc1
Date: Wed, 30 Jul 2008 10:17:15 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0807301016010.2584-100000@iolanthe.rowland.org>
References: <20080730052139.GG6091@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:54825 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754827AbYG3ORQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jul 2008 10:17:16 -0400
In-Reply-To: <20080730052139.GG6091@one-eyed-alien.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Matthew Frost <artusemrys@yahoo.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, Matt Frost <artusemrys@sbcglobal.net>

On Tue, 29 Jul 2008, Matthew Dharm wrote:

> Actually, I'm seriously starting to think that US_FL_IGNORE_RESIDUE should
> just become a sysfs parameter which defaults to the 'ignore' state...

We have to be careful; there definitely are devices out there which 
need to use the Residue.

Alan Stern

