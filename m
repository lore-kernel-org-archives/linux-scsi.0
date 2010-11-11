From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH take 2] [USB] Use normalized sense when emulating
	autosense
Date: Thu, 11 Nov 2010 11:11:10 -0800
Message-ID: <20101111191110.GA12308@kroah.com>
References: <20101111174322.GB20296@one-eyed-alien.net> <673670.8195.qm@web31801.mail.mud.yahoo.com> <20101111184946.GC20296@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:56021 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753956Ab0KKT0b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Nov 2010 14:26:31 -0500
Content-Disposition: inline
In-Reply-To: <20101111184946.GC20296@one-eyed-alien.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <ltuikov@yahoo.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 10:49:46AM -0800, Matthew Dharm wrote:
> On Thu, Nov 11, 2010 at 10:27:11AM -0800, Luben Tuikov wrote:
> > The patch uses SCSI functions to abstract the sense information irrespective of the type of format of sense data.
> 
> Looks reasonable.  The underlying SCSI functions seem to all have the tests
> to distinguish between sense format types.  Let's just hope there are no
> devices out there which can confuse those tests, or we'll be buried in
> regressions.
> 
> ACKed-by: Matthew Dharm <mdharm-usb@one-eyed-alien.net>

Luben, can you resend me the original patch with Matthew's ack on it?  I
no longer have it in my mboxes.

thanks,

greg k-h
