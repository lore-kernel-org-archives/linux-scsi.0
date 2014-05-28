From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi/NCR5380: dprintk macro
Date: Wed, 28 May 2014 08:53:36 -0700
Message-ID: <20140528155336.GB14981@infradead.org>
References: <alpine.LNX.2.00.1405290020570.3539@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-m68k-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1405290020570.3539@nippy.intranet>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Christoph Hellwig <hch@infradead.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Sam Creasey <sammy@sammy.net>, Russell King <linux@arm.linux.org.uk>, Michael Schmitz <schmitz@debian.org>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-m68k@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, May 29, 2014 at 12:43:43AM +1000, Finn Thain wrote:
> 
> This is the delta between the two submissions:
> [PATCH 00/12] scsi/NCR5380: fix debugging macros and #include structure
> and
> [PATCH v2 00/12] scsi/NCR5380: fix debugging macros and #include structure
> 
> The macro definition changes were discussed on the mailing list during 
> review. The idea is to get the compiler to check the parameters of 
> disabled printk() calls so that the debugging code doesn't rot again.
> 
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

Thanks a lot Finn!

> I know the whitespace is wrong throughout these drivers but when I put 
> this patch series together it seemed best to defer the whitespace cleanup. 
>(I still intend to do that cleanup.)

Yes, I ignored the whitespace warnings in the debug macro cleanups.  I
fixed them up for the "newly" added code in the sun3 driver merge.
