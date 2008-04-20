From: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] sparc: export kmap_atomic_to_page
Date: Sun, 20 Apr 2008 23:14:43 +0300
Message-ID: <20080420201443.GB14788@cs181133002.pp.htv.fi>
References: <20080414141956.GN6695@cs181133002.pp.htv.fi> <20080415.003910.50277238.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp5.pp.htv.fi ([213.243.153.39]:55878 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756674AbYDTUPJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Apr 2008 16:15:09 -0400
Content-Disposition: inline
In-Reply-To: <20080415.003910.50277238.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: aacraid@adaptec.com, James.Bottomley@HansenPartnership.com, wli@holomorphy.com, sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 12:39:10AM -0700, David Miller wrote:
> From: Adrian Bunk <bunk@kernel.org>
>...
> > <--  snip  -->
> > 
> >   MODPOST 1741 modules
> > ERROR: "kmap_atomic_to_page" [drivers/scsi/aacraid/aacraid.ko] undefined!
> > ...
> > make[2]: *** [__modpost] Error 1
> > 
> > <--  snip  -->
> > 
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> Applied, thanks Adrian.

Please drop - aacraid no longer uses it in 2.6.26.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

