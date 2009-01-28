From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: strange USB storage failure with 2.6.29-rc2
Date: Wed, 28 Jan 2009 16:23:37 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0901281622210.2231-100000@iolanthe.rowland.org>
References: <20090128120129.68d04cd6@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:49012 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755478AbZA1VXi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jan 2009 16:23:38 -0500
In-Reply-To: <20090128120129.68d04cd6@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dirk Hohndel <hohndel@infradead.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org

On Wed, 28 Jan 2009, Dirk Hohndel wrote:

> Any recommendations how to best approach debugging this? Attaching
> strace to some processes before inserting the usb stick?

No really good recommendations.  The guilty party is often hal, so you 
can try turning off the haldaemon service before plugging in your 
stick.

Alan Stern

