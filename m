From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] ips driver for 2.4.23-pre4
Date: Thu, 8 Jan 2004 17:15:31 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040108171531.B12595@infradead.org>
References: <3FFC5B2C.6000302@wanadoo.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:54031 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S265649AbUAHRPd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jan 2004 12:15:33 -0500
Content-Disposition: inline
In-Reply-To: <3FFC5B2C.6000302@wanadoo.es>; from xose@wanadoo.es on Wed, Jan 07, 2004 at 08:17:00PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Xose Vazquez Perez <xose@wanadoo.es>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Tosatti <marcelo.tosatti@cyclades.com>

On Wed, Jan 07, 2004 at 08:17:00PM +0100, Xose Vazquez Perez wrote:
> -#if !defined(__i386__) && !defined(__ia64__)
> -#error "This driver has only been tested on the x86/ia64 platforms"
> +#if !defined(__i386__) && !defined(__ia64__) && !defined(__x86_64__)
> +#error "This driver has only been tested on the x86/ia64/x86_64 platforms"
>  #endif

This warning schould be removed completly.  Lots of PCI drivers have
been tested only on a few plattforms.

Else the patch is okay, but where's the maintainer?

