From: Adrian Bunk <bunk@stusta.de>
Subject: Re: adding the SCSI hptiop driver to 2.6.16
Date: Sun, 26 Nov 2006 04:32:22 +0100
Message-ID: <20061126033222.GF15364@stusta.de>
References: <20061123020029.GJ3557@stusta.de> <009c01c70eb3$719abe50$1200a8c0@gmm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:48399 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S967254AbWKZDcT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Nov 2006 22:32:19 -0500
Content-Disposition: inline
In-Reply-To: <009c01c70eb3$719abe50$1200a8c0@gmm>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: HighPoint Linux Team <linux@highpoint-tech.com>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

On Thu, Nov 23, 2006 at 11:56:56AM +0800, HighPoint Linux Team wrote:
> Adrian Bunk wrote:
> > I'd like to add the SCSI hptiop driver to the 2.6.16 tree.
> > 
> > The backport of the driver in 2.6.18 seems to be straightforward.
> > 
> > My questions are:
> > 
> > Is there any reason I miss why this driver might not work in 2.6.16?
> > 
> > I lack the hardware, and I can therefore only test the compilation.
> > Would anyone who has the hardware be willing to test whether this 
> > actually works?
> 
> Actually, the driver was developped and tested on 2.6.16 before it
> was submitted.

Thanks for this information, I've added the hptiop driver to 2.6.16.

> HighPoint Linux Team

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

