From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] oops on usb storage device disconnect with
 2.6.14-rc1
Date: Thu, 15 Sep 2005 15:23:11 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0509151514460.4493-100000@iolanthe.rowland.org>
References: <20050915190338.GA6807@kroah.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:63203 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S965159AbVIOTXN
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Sep 2005 15:23:13 -0400
In-Reply-To: <20050915190338.GA6807@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: linux-usb-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, mdharm-usb@one-eyed-alien.net

On Thu, 15 Sep 2005, Greg KH wrote:

> Here's a nice oops I get when removing a usb-storage device with
> 2.6.14-rc1.  I've also created a bug for this for those who like to
> track bugzilla:
> 	http://bugzilla.kernel.org/show_bug.cgi?id=5265
> 
> Any ideas?

Patches for this bug plus two others attached to the bug report.

Alan Stern

