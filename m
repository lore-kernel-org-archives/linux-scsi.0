From: Adrian Bunk <bunk@stusta.de>
Subject: Re: [2.6 patch] drivers/scsi/qla2xxx/: cleanups
Date: Mon, 28 Feb 2005 22:53:55 +0100
Message-ID: <20050228215355.GQ4021@stusta.de>
References: <20050228210024.GM4021@stusta.de> <20050228212920.GA18162@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:9 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S261766AbVB1Vx4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Feb 2005 16:53:56 -0500
Content-Disposition: inline
In-Reply-To: <20050228212920.GA18162@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, andrew.vasquez@qlogic.com, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Feb 28, 2005 at 09:29:20PM +0000, Christoph Hellwig wrote:
> On Mon, Feb 28, 2005 at 10:00:24PM +0100, Adrian Bunk wrote:
> > This patch contains the following cleanups:
> > - make needlessly global code static
> > - kill the unused global *_version and *_version_str variables
> >   in the firmware files
> 
> The firmware files are generated, so it'd be better to leave them
> alone.

Agreed.

But can't the generation of these files omit these needless variables 
(there are already #define's containing the version information)?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

