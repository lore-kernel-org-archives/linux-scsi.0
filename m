From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [announce] scsi_id release 0.2
Date: Sun, 7 Dec 2003 12:38:32 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031207123832.A30616@beaverton.ibm.com>
References: <20031205151810.A8891@beaverton.ibm.com> <20031207153802.GA6700@suse.de> <20031207114242.A29572@beaverton.ibm.com> <20031207195915.GA6714@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.105]:4590 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S264512AbTLGUiu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Dec 2003 15:38:50 -0500
Content-Disposition: inline
In-Reply-To: <20031207195915.GA6714@suse.de>; from olh@suse.de on Sun, Dec 07, 2003 at 08:59:15PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Olaf Hering <olh@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net

On Sun, Dec 07, 2003 at 08:59:15PM +0100, Olaf Hering wrote:
>  On Sun, Dec 07, Patrick Mansfield wrote:
> 
> > Is it breaking your build? If so I'll just remove it.
> 
> Yes, just try to build a udev debug binary.

It worked fine for me, something must be different in our build
environments. I have:

[elm3b79 udev-bk]$ gcc -v
Reading specs from /usr/lib/gcc-lib/i386-linux/2.95.4/specs
gcc version 2.95.4 20011002 (Debian prerelease)

I should probably upgrade.

But in any case I applied your patch to my view, thanks.

-- Patrick Mansfield
