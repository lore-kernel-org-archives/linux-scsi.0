From: Adrian Bunk <bunk@stusta.de>
Subject: Re: [PATCH 2.6.16-rc6] Promise SuperTrak driver
Date: Fri, 17 Mar 2006 00:55:04 +0100
Message-ID: <20060316235504.GH3914@stusta.de>
References: <20060313224112.GA19513@havoc.gtf.org> <20060313154236.32293cf9.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:50960 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S964905AbWCPXzG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Mar 2006 18:55:06 -0500
Content-Disposition: inline
In-Reply-To: <20060313154236.32293cf9.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org, promise_linux@promise.com, linux-kernel@vger.kernel.org

On Mon, Mar 13, 2006 at 03:42:36PM -0800, Andrew Morton wrote:
> Jeff Garzik <jeff@garzik.org> wrote:
>...
> > +config SCSI_SHASTA
> > +	tristate "Promise SuperTrek EX8350/8300/16350/16300 support"
> > +	depends on PCI && SCSI
> 
> Might it also depend upon BLK_DEV_SD?
>...

None of the other RAID adapters in drivers/scsi/Kconfig does.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

