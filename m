From: Adrian Bunk <bunk@stusta.de>
Subject: Re: [2.6 patch] SCSI: possible cleanups
Date: Tue, 1 Mar 2005 00:01:55 +0100
Message-ID: <20050228230155.GV4021@stusta.de>
References: <20050228213159.GO4021@stusta.de> <20050228222509.GB19376@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from mailout.stusta.mhn.de ([141.84.69.5]:18954 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S261805AbVB1XB5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Feb 2005 18:01:57 -0500
Content-Disposition: inline
In-Reply-To: <20050228222509.GB19376@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Mark_Salyzyn@adaptec.com

On Mon, Feb 28, 2005 at 10:25:09PM +0000, Christoph Hellwig wrote:
>...
> >   - constants.c: scsi_print_hostbyte
> >   - constants.c: scsi_print_driverbyte
> 
> these we'll probably keep for now.
>...

keep = #if 0 ?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

