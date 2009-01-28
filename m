From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: strange USB storage failure with 2.6.29-rc2
Date: Wed, 28 Jan 2009 15:14:38 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0901281511370.2758-100000@iolanthe.rowland.org>
References: <20090128115958.77d59368@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:45132 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751489AbZA1UOk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jan 2009 15:14:40 -0500
In-Reply-To: <20090128115958.77d59368@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dirk Hohndel <hohndel@infradead.org>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org

On Wed, 28 Jan 2009, Dirk Hohndel wrote:

> I had missed that part that the stick claimed to be a removable device
> (it is, in a sense, but then it shouldn't balk at being ejected).

No, no.  This is a common misunderstanding, caused by poor choice of 
terminology.  The stick is not "removable"; it is "hot-unpluggable".

"Removable" refers to the media.  A CD drive, floppy drive, or card
reader is removable storage.  A USB stick isn't, unless you can 
somehow pry the flash memory chip out of it.  :-)

Alan Stern

