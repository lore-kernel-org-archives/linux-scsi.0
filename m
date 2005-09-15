From: Greg KH <greg@kroah.com>
Subject: Re: [linux-usb-devel] oops on usb storage device disconnect with 2.6.14-rc1
Date: Thu, 15 Sep 2005 12:29:12 -0700
Message-ID: <20050915192912.GA7077@kroah.com>
References: <20050915190338.GA6807@kroah.com> <Pine.LNX.4.44L0.0509151514460.4493-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kroah.org ([69.55.234.183]:2797 "EHLO perch.kroah.org")
	by vger.kernel.org with ESMTP id S965268AbVIOT3d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Sep 2005 15:29:33 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0509151514460.4493-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, mdharm-usb@one-eyed-alien.net

On Thu, Sep 15, 2005 at 03:23:11PM -0400, Alan Stern wrote:
> On Thu, 15 Sep 2005, Greg KH wrote:
> 
> > Here's a nice oops I get when removing a usb-storage device with
> > 2.6.14-rc1.  I've also created a bug for this for those who like to
> > track bugzilla:
> > 	http://bugzilla.kernel.org/show_bug.cgi?id=5265
> > 
> > Any ideas?
> 
> Patches for this bug plus two others attached to the bug report.

Ah, thanks for the pointer.  SCSI developers, any objections to these
patches being merged?

greg k-h
