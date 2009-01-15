From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: export bsg.h header to user-mode
Date: Thu, 15 Jan 2009 21:29:56 +0900
Message-ID: <20090115212942R.fujita.tomonori@lab.ntt.co.jp>
References: <496EFA69.3050007@panasas.com>
	<20090115202155G.fujita.tomonori@lab.ntt.co.jp>
	<496F26DF.9050303@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:50098 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761201AbZAOMbN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jan 2009 07:31:13 -0500
In-Reply-To: <496F26DF.9050303@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, akpm@linux-foundation.org, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, dougg@torque.net, stable@kernel.org

On Thu, 15 Jan 2009 14:06:55 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> > Your patch does the right thing?
> > 
> 
> Yes I just checked, the Kernel build system strips out the #ifdef __KERNEL__ sections
> for the exported headers. (Do "make headers_check" you can see at usr/include/linux/)

Thanks, I see.


> >> ---
> >> From: Boaz Harrosh <bharrosh@panasas.com>
> >> Date: Thu, 15 Jan 2009 10:43:17 +0200
> >> Subject: [PATCH] include/linux: Add bsg.h to the Kernel exported headers
> >>
> >> bsg.h in current form is perfectly suitable for user-mode
> >> consumption. It is needed together with scsi/sg.h for applications
> >> that want to interface with the bsg driver.
> >>
> >> Currently the few projects that use it would copy it over into
> >> the projects. But that is not acceptable for projects that need
> >> to provide a libxxx-devel package for distros.
> >>
> >> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> 
> TOMO Please ACK here so Jens can push it through his tree.

You can add my ACK.


> Also I think we want to:
> CC: stable@kernel.org

It's fine by me.


> for 2.6.27.x and 2.6.28.x Because these where shipped with bsg
> and there is no reason why not have it, lets say in Fedora10
> or ubuntu 8.10.
> 
> >> ---
> >>  include/linux/Kbuild |    1 +
> >>  1 files changed, 1 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/include/linux/Kbuild b/include/linux/Kbuild
> >> index 12e9a29..2124c06 100644
> >> --- a/include/linux/Kbuild
> >> +++ b/include/linux/Kbuild
> 
> 
> Thanks
> Boaz
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
