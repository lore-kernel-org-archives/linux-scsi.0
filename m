From: Greg KH <greg@kroah.com>
Subject: Re: [BK PATCH] SCSI update for 2.6.3
Date: Tue, 24 Feb 2004 09:16:29 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040224171629.GA31369@kroah.com>
References: <Pine.LNX.4.58.0402240919490.1129@spektro.metla.fi> <20040224170412.GA31268@kroah.com> <1077642529.1804.170.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kroah.org ([65.200.24.183]:52115 "EHLO perch.kroah.org")
	by vger.kernel.org with ESMTP id S262320AbUBXRQb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Feb 2004 12:16:31 -0500
Content-Disposition: inline
In-Reply-To: <1077642529.1804.170.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Kai Makisara <Kai.Makisara@metla.fi>, Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, kai.makisara@kolumbus.fi

On Tue, Feb 24, 2004 at 11:08:48AM -0600, James Bottomley wrote:
> On Tue, 2004-02-24 at 11:04, Greg KH wrote:
> > Can you post it here so we can review it?
> > 
> > And yes, using class_simple should relieve you of Al flamage :)
> 
> The one in the tree is attached.  I did verify it myself, and tried it
> out on some old QIC tapes I had lying around.

Can you print out the sysfs tree this patch creates?

What's that "tape" symlink for?  Does it go from the scsi device in
/sys/devices/... to the class device?  Or the other way around?

Other than that question, the patch looks sane to me.

thanks,

greg k-h
