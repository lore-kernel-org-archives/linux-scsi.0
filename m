From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.13-rc6-mm1: drivers/scsi/aic7xxx/ compile error
Date: Fri, 19 Aug 2005 17:42:42 +0100
Message-ID: <20050819164241.GA4056@infradead.org>
References: <20050819043331.7bc1f9a9.akpm@osdl.org> <20050819164036.GE3682@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S965019AbVHSQmu@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20050819164036.GE3682@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@osdl.org>, James.Bottomley@SteelEye.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Aug 19, 2005 at 06:40:36PM +0200, Adrian Bunk wrote:
> <--  snip  -->
> 
> ...
>   LD      drivers/scsi/aic7xxx/built-in.o
> drivers/scsi/aic7xxx/aic79xx.o: In function `aic_parse_brace_option':
> : multiple definition of `aic_parse_brace_option'
> drivers/scsi/aic7xxx/aic7xxx.o:: first defined here
> make[3]: *** [drivers/scsi/aic7xxx/built-in.o] Error 1
> 
> <--  snip  -->
> 
> 
> #includ'ing .c files is considered harmful...

That code previously had a hack to rename those that I removed
accidentally.  I think we should just kill aiclib.c and keep two
copies of the two functions it still has - they'll go away soon anyway.
I'll cook up a patch and sent it to James ASAP.
