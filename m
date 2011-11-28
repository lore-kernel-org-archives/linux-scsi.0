From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH] scsi: convert drivers/scsi/* to use
 module_platform_driver()
Date: Mon, 28 Nov 2011 23:49:35 +1100 (EST)
Message-ID: <alpine.LNX.2.00.1111282345090.26744@nippy.intranet>
References: <1322315527.15832.1.camel@phoenix>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1322315527.15832.1.camel@phoenix>
Sender: linux-kernel-owner@vger.kernel.org
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, "David S. Miller" <davem@davemloft.net>, Ralf Baechle <ralf@linux-mips.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Sat, 26 Nov 2011, Axel Lin wrote:

> This patch converts the drivers in drivers/scsi/* to use the
> module_platform_driver() macro which makes the code smaller and a bit
> simpler.
...
>  
> -static int __init jazz_esp_init(void)
...
> +module_platform_driver(esp_jazz_driver);

Doesn't this transform "jazz_esp_init" into "jazz_esp_driver_init"?

If that's the convention, it seems odd that the module_platform_driver 
macro doesn't do it...

Finn
