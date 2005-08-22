From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: [PATCH] minimal SAS transport class
Date: Sun, 21 Aug 2005 23:55:02 -0500
Message-ID: <20050822045502.GA7147@lists.us.dell.com>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A40@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeus1.kernel.org ([204.152.191.4]:16268 "EHLO zeus1.kernel.org")
	by vger.kernel.org with ESMTP id S1751306AbVHVWmn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Aug 2005 18:42:43 -0400
Received: from ausc60ps301.us.dell.com (ausc60ps301.us.dell.com [143.166.148.206])
	by zeus1.kernel.org (8.13.1/8.13.1) with ESMTP id j7M4u87R002158
	for <linux-scsi@vger.kernel.org>; Sun, 21 Aug 2005 21:56:09 -0700
Content-Disposition: inline
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A40@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: luben_tuikov@adaptec.com, hch@lst.de, jejb@steeleye.com, ltuikov@yahoo.com, Eric.Moore@lsil.com, andrew.patterson@hp.com, linux-scsi@vger.kernel.org

On Sat, Aug 20, 2005 at 12:15:41AM -0400, James.Smart@Emulex.Com wrote:
> - There are some real challenges in supporting a udev-named boot
>   device. For the most part, it's a distro issue, which is becoming
>   better. PS: for $10, name a 2.6 distro that uses udev out
>   of the box for disk names and its installation. For $10 more, 
>   can it install/boot from one?

I won't get your $10, but RHEL4 has a mechanism to specify "install
onto BIOS disk N", where N is typically 80h (it's an int13 number,
what BIOS typically boots from).  EDD in anaconda handles the mapping
of BIOS disk number to /dev/whatever.  And a few folks at Dell are
working on a udev helper to let udev know this mapping too, and
incorporating the same capability into SLES in the future.

After install, file system labels have been working great for years.
root=LABEL=/  syntax for example, and you can get as complex as you
like with that label.

Thanks,
Matt

-- 
Matt Domsch
Software Architect
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com
