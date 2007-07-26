From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] t128: Indent and add printk levels
Date: Thu, 26 Jul 2007 11:51:08 -0600
Message-ID: <20070726175108.GH19275@parisc-linux.org>
References: <20070726185044.76b17661@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:54688 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761772AbXGZRvJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jul 2007 13:51:09 -0400
Content-Disposition: inline
In-Reply-To: <20070726185044.76b17661@the-village.bc.nu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org

On Thu, Jul 26, 2007 at 06:50:44PM +0100, Alan Cox wrote:
> -    [4] __initdata = {{0, IRQ_AUTO}, {0, IRQ_AUTO},
> -        {0 ,IRQ_AUTO}, {0, IRQ_AUTO}};
> +[4] __initdata = { {
> +0, IRQ_AUTO}, {
> +0, IRQ_AUTO}, {
> +0, IRQ_AUTO}, {
> +0, IRQ_AUTO}};
>  #endif

A bit bizarre.  I'd expect something more like:
[4] __initdata = {
	{ 0, IRQ_AUTO },
	{ 0, IRQ_AUTO },
	{ 0, IRQ_AUTO },
	{ 0, IRQ_AUTO }
};

>  } bases[] __initdata = {
> -    { 0xcc000, 0}, { 0xc8000, 0}, { 0xdc000, 0}, { 0xd8000, 0}
> +	{
> +	0xcc000, 0}, {
> +	0xc8000, 0}, {
> +	0xdc000, 0}, {
> +	0xd8000, 0}
>  };

Similarly.

>  } signatures[] __initdata = {
> -{"TSROM: SCSI BIOS, Version 1.12", 0x36},
> -};
> +	{
> +"TSROM: SCSI BIOS, Version 1.12", 0x36},};
>  

And again.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
