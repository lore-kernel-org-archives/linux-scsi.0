From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH][RESEND] Fix a potential NULL pointer deref in the
	aic7xxx, ahc_print_register() function
Date: Sat, 04 Aug 2007 14:43:47 -0500
Message-ID: <1186256627.3439.22.camel@localhost.localdomain>
References: <200708042030.52405.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S933230AbXHDToB@vger.kernel.org>
In-Reply-To: <200708042030.52405.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, James Bottomley <jejb@kernel.org>, linux-scsi@vger.kernel.org, "Justin T. Gibbs" <gibbs@scsiguy.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2007-08-04 at 20:30 +0200, Jesper Juhl wrote:
> (resend of patch previously submitted on 28-Jul-2007 23:06)
> 
> 
> Ehlo,
> 
> The Coverity checker noticed that we have a potential NULL pointer 
> deref in drivers/scsi/aic7xxx/aic7xxx_core.c::ahc_print_register().
> This patch handles it by adding the same test against NULL that is 
> used elsewhere in the same function.

It's on my list of things to look at ... but not very high.  I suspect
it actually isn't triggerable, but if you can tell me how, it will save
me from looking.

James
