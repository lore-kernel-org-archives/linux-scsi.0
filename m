From: Pete Zaitcev <zaitcev@redhat.com>
Subject: Re: strange USB storage failure with 2.6.29-rc2
Date: Wed, 28 Jan 2009 14:13:29 -0700
Message-ID: <20090128141329.f427232b.zaitcev@redhat.com>
References: <20090127200607.369a1693@infradead.org>
	<Pine.LNX.4.44L0.0901281141300.3134-100000@iolanthe.rowland.org>
	<20090128091406.316a80fc@infradead.org>
	<1233165551.3236.99.camel@localhost.localdomain>
	<20090128120129.68d04cd6@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:59738 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759203AbZA1VP2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jan 2009 16:15:28 -0500
In-Reply-To: <20090128120129.68d04cd6@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dirk Hohndel <hohndel@infradead.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Alan Stern <stern@rowland.harvard.edu>, Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org

On Wed, 28 Jan 2009 12:01:29 -0800, Dirk Hohndel <hohndel@infradead.org> wrote:

> Any recommendations how to best approach debugging this? Attaching
> strace to some processes before inserting the usb stick?

I would try add some dump_stack() to ->queuecommand, to see if this
is SG_IO or other source. Finding who sends the commands is the key.
Another trick is to printk the completion handlers (w/ lookup_symbol).

-- Pete
