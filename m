From: Pete Zaitcev <zaitcev@redhat.com>
Subject: Re: strange USB storage failure with 2.6.29-rc2
Date: Wed, 28 Jan 2009 14:29:15 -0700
Message-ID: <20090128142915.3b6f1949.zaitcev@redhat.com>
References: <20090128120129.68d04cd6@infradead.org>
	<Pine.LNX.4.44L0.0901281622210.2231-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:32848 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752436AbZA1VbH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jan 2009 16:31:07 -0500
In-Reply-To: <Pine.LNX.4.44L0.0901281622210.2231-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Dirk Hohndel <hohndel@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org

On Wed, 28 Jan 2009 16:23:37 -0500 (EST), Alan Stern <stern@rowland.harvard.edu> wrote:

> > Any recommendations how to best approach debugging this? Attaching
> > strace to some processes before inserting the usb stick?
> 
> No really good recommendations.  The guilty party is often hal, so you 
> can try turning off the haldaemon service before plugging in your 
> stick.

printk current->comm in queuecommand maybe?

-- Pete
