From: Grant Grundler <grundler@parisc-linux.org>
Subject: Re: [linux-usb-devel] [PATCH] [2.6.23.13] udev hangs USB-storage
	(HP r707 camera)
Date: Wed, 23 Jan 2008 00:02:30 -0700
Message-ID: <20080123070229.GC20348@colo.lackof.org>
References: <20080119174556.GE11553@colo.lackof.org> <47929B9F.8080607@s5r6.in-berlin.de> <20080120022829.GG11553@colo.lackof.org> <1200797791.11214.3.camel@localhost.localdomain> <20080120031008.GI11553@colo.lackof.org> <1200802265.11214.8.camel@localhost.localdomain> <20080120052553.GA5452@colo.lackof.org> <4796D02D.8000108@ipom.com> <20080123065556.GB20348@colo.lackof.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colo.lackof.org ([198.49.126.79]:41222 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753443AbYAWHCx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Jan 2008 02:02:53 -0500
Content-Disposition: inline
In-Reply-To: <20080123065556.GB20348@colo.lackof.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Phil Dibowitz <phil@ipom.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

On Tue, Jan 22, 2008 at 11:55:56PM -0700, Grant Grundler wrote:
...
> >   http://www.phildev.net/linux/usb-unusualdevs-notes.html
> 
> In general, a very helpful document! Thanks!
...

I read the rest of the document and explains exactly my confusion.
Can you please include that document into Documentation/usb/ ?
And then add a reference to the location where the US_SC* and US_PR*
constants are defined?

thanks again!
grant
