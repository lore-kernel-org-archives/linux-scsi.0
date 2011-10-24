From: Jesper Juhl <jj@chaosbits.net>
Subject: Re: [PATCH] SCSI, pmcraid: Fix kmalloc() argument order in
 pmcraid_chr_ioctl()
Date: Tue, 25 Oct 2011 01:06:12 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1110250103300.19795@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1110250036370.19795@swampdragon.chaosbits.net> <1319496149.2094.3.camel@Joe-Laptop> <CAFLxGvyh-u0Bg5_R4upMa=bM4H__i=dbvtLihFY+M+OEKdJL9w@mail.gmail.com> <20111024225459.GB25654@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111024225459.GB25654@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Jones <davej@redhat.com>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>, Joe Perches <joe@perches.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 24 Oct 2011, Dave Jones wrote:

> On Tue, Oct 25, 2011 at 12:50:08AM +0200, richard -rw- weinberger wrote:
>  
>  > BTW: What about a checkpatch.pl rule to detect such a misuse of kmalloc()?
>  > We could grep for "k[mzc]alloc(GFP_".
> 
> Make sure to ignore bio_kmalloc (which has reverse argument order to kmalloc, ugh)
> 
Yeah, and there's also kmalloc_node() (and perhaps kmem_cache_alloc() && 
kmem_cache_alloc_node() although there the compiler will at least warn) 
that might as well be checked for.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.
