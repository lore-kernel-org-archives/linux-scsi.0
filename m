From: Adrian Bunk <bunk@stusta.de>
Subject: Re: [2.6 patch] SCSI: cleanups
Date: Thu, 31 Mar 2005 23:07:45 +0200
Message-ID: <20050331210745.GH3185@stusta.de>
References: <20050327202139.GQ4285@stusta.de> <1112023305.5531.2.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:6159 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S261936AbVCaVHv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Mar 2005 16:07:51 -0500
Content-Disposition: inline
In-Reply-To: <1112023305.5531.2.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Mon, Mar 28, 2005 at 09:21:45AM -0600, James Bottomley wrote:
> On Sun, 2005-03-27 at 22:21 +0200, Adrian Bunk wrote:
> > This patch contains the following cleanups:
> [..]
> 
> No to all of this:
> 
> > - remove the following unused functions:
> >   - scsi.h: print_driverbyte
> >   - scsi.h: print_hostbyte
> > - #if 0 the following unused functions:
> >   - constants.c: scsi_print_hostbyte
> >   - constants.c: scsi_print_driverbyte
> 
> These are useful to those of us who debug drivers.
>...

Does this really include the legacy print_driverbyte and print_hostbyte 
wrappers?

> James

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

