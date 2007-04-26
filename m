From: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: [2.6 patch] drivers/scsi/nsp32.c: remove kernel 2.4 code
Date: Thu, 26 Apr 2007 19:59:57 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0704261955450.14047@localhost.localdomain>
References: <20070426234742.GH3468@stusta.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nic.NetDirect.CA ([216.16.235.2]:42694 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295AbXD0AA4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Apr 2007 20:00:56 -0400
In-Reply-To: <20070426234742.GH3468@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007, Adrian Bunk wrote:

> This patch removes kernel 2.4 code.
>
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
>
> ---
>
> This patch has been sent on:
> - 26 Mar 2007
>
>  drivers/scsi/nsp32.c |  109 +++++--------------------------------------
>  1 file changed, 13 insertions(+), 96 deletions(-)
>
> --- linux-2.6.21-rc4-mm1/drivers/scsi/nsp32.c.old	2007-03-25 20:27:34.000000000 +0200
> +++ linux-2.6.21-rc4-mm1/drivers/scsi/nsp32.c	2007-03-25 20:31:59.000000000 +0200
> @@ -49,10 +49,6 @@
>  #include <scsi/scsi_host.h>
>  #include <scsi/scsi_ioctl.h>
>
> -#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0))
> -# include <linux/blk.h>
> -#endif
> -

i'm curious about the rules for removing code like this.  in the case
of drivers, isn't it possible that some driver source could be
relevant for both the 2.4 and 2.6 kernel source tree, and simply uses
that kind of preprocessor check to make sure it's being compiled
appropriately?

or are you doing something more sophisticated than simply checking the
kernel version being tested?

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
