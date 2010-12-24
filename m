From: Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH] dma_declare_coherent_memory: push ioremap() up to caller
Date: Fri, 24 Dec 2010 10:58:59 +0900
Message-ID: <20101224015858.GG28151@linux-sh.org>
References: <201012240020.37208.jkrzyszt@tis.icnet.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-sh-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201012240020.37208.jkrzyszt@tis.icnet.pl>
Sender: linux-sh-owner@vger.kernel.org
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: linux-arch@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Russell King - ARM Linux <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>, Dan Williams <dan.j.williams@intel.com>, linux-sh@vger.kernel.org, Sascha Hauer <kernel@pengutronix.de>, linux-usb@vger.kernel.org, David Brownell <dbrownell@users.sourceforge.net>, linux-media@vger.kernel.org, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <James.Bottomley@suse.de>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Dec 24, 2010 at 12:20:32AM +0100, Janusz Krzysztofik wrote:
> Tested on ARM OMAP1 based Amstrad Delta with a WIP OMAP1 camera patch, 
> patterned upon two mach-mx3 machine types which already try to use the 
> dma_declare_coherent_memory() method for reserving a region of system 
> RAM preallocated with another dma_alloc_coherent(). Compile tested for 
> all modified files except arch/sh/drivers/pci/fixups-dreamcast.c.
> 
> Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>

The arch/sh/drivers/pci/fixups-dreamcast.c build fine.

Acked-by: Paul Mundt <lethal@linux-sh.org>
