From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] add transport class symlink to device object
Date: Sat, 13 Aug 2005 14:39:56 -0700
Message-ID: <20050813213955.GB19235@kroah.com>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C201AD35@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kroah.org ([69.55.234.183]:35769 "EHLO perch.kroah.org")
	by vger.kernel.org with ESMTP id S932329AbVHMVkY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Aug 2005 17:40:24 -0400
Content-Disposition: inline
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C201AD35@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com, Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org

On Sat, Aug 13, 2005 at 11:34:17AM -0400, James.Smart@Emulex.Com wrote:
> In prior conversations with folks doing utilities such as lsscsi, it became
> rather apparent that it is difficult to establish the relationships between
> the class device and its base device. The class->device symlink is good for
> one direction, but the reverse direction didn't exist. In order to go from
> the device to its class device, you needed to either search all class
> devices to search for a device backlink that pointed to you, or had to build
> in name relationships what the subset class devices that you need to look at.
> 
> This patch adds a symlink from the base device to the class device. The name
> of the symlink is "class:<classname>".  I had originally considered just
> <classname> for the symlink name, but it seemed to get lost in the attributes.

Heh, I already have a patch like this pending for 2.6.14 at:
	http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-01-driver/driver-link-device-and-class.patch

Andrew keeps disabling it in the -mm releases due to it misbehaiving on
some of his scsi devices.  Perhaps he can post that oops message again
so that someone here can fix it up before I add it to the main tree?

thanks,

greg k-h
