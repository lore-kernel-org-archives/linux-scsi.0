From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH v3 68/77] ncr5380: Fix whitespace issues using regexp
Date: Wed, 23 Dec 2015 13:31:02 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1512231306580.30030@nippy.intranet>
References: <20151222011737.980475848@telegraphics.com.au>   <20151222011756.506380156@telegraphics.com.au>  <1450795615.21677.10.camel@perches.com>  <alpine.LNX.2.00.1512231138330.28866@nippy.intranet> <1450833749.2381.27.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <1450833749.2381.27.camel@HansenPartnership.com>
Sender: linux-m68k-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Joe Perches <joe@perches.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org


On Tue, 22 Dec 2015, James Bottomley wrote:

> I don't think it is trivial.  I can't actually find a single instance in 
> this patch where collapsing the space at the start of the comment looks 
> justified; most of the time it eliminates intended formatting.

The present formatting is broken. It differs between the two core driver 
forks. One uses spaces, the other tabs. For example, line 3.

$ grep -c "^ [*] *\t" drivers/scsi/{atari_,}NCR5380.c 
drivers/scsi/atari_NCR5380.c:14
drivers/scsi/NCR5380.c:23

This patch resolves the issue by deliberately adopting an easy and 
foolproof formatting convention.

But clearly there are different views as to what convention should be used 
here. It would be great if you would indicate an acceptable convention so 
we don't have to bikeshed the use of whitespace in comments.

To set an example, would you be kind enough to reformat, say, the comment 
block at the top of the two files? Or some other comment where kernel-doc 
is not appropriate, and the comment isn't merely duplicating actual code?

Thanks.

> Even if there's an odd one I've missed where space at the beginning of a 
> comment is a problem, I think not doing that part of the regexp and just 
> correcting the odd missed case by hand later will be much better.
> 
> James

-- 
