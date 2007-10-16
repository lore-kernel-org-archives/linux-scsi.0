From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 1/2] fc4/pluto - Enable compilation for all ARCHs
Date: Tue, 16 Oct 2007 09:43:28 +0200
Message-ID: <47146BA0.6080708@panasas.com>
References: <4713A175.9020408@panasas.com>	<4713A2DB.2000302@panasas.com>	<20071015180949.GC25488@parisc-linux.org>	<4713AEF0.5070706@panasas.com> <20071015131554.9a5cfb5b.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sa5.bezeqint.net ([192.115.104.19]:37358 "EHLO sa5.bezeqint.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759126AbXJPHni (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Oct 2007 03:43:38 -0400
In-Reply-To: <20071015131554.9a5cfb5b.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Matthew Wilcox <matthew@wil.cx>, James Bottomley <James.Bottomley@SteelEye.com>, "David S. Miller" <davem@davemloft.net>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <tomof@acm.org>

On Mon, Oct 15 2007 at 22:15 +0200, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> --- linux-2.6.23-git7.orig/drivers/fc4/fc.c
> +++ linux-2.6.23-git7/drivers/fc4/fc.c
> @@ -30,6 +30,7 @@
>  #include <linux/ptrace.h>
>  #include <linux/ioport.h>
>  #include <linux/in.h>
> +#include <linux/pci.h>
>  #include <linux/slab.h>
>  #include <linux/string.h>
>  #include <linux/init.h>

This bit is not needed it's already done with Matthew's
patch.

The rest looks Good, thanks

Boaz

