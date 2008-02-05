From: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: aic7xxx build failure
Date: Tue, 5 Feb 2008 19:47:35 +0100
Message-ID: <20080205184735.GA26270@uranus.ravnborg.org>
References: <20080205174024.GE505@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pasmtpa.tele.dk ([80.160.77.114]:42065 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756599AbYBESrb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Feb 2008 13:47:31 -0500
Content-Disposition: inline
In-Reply-To: <20080205174024.GE505@cs181133002.pp.htv.fi>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, Feb 05, 2008 at 07:40:24PM +0200, Adrian Bunk wrote:
> Commit 8891fec65ac5b5a74b50c705e31b66c92c3eddeb broke aic7xxx 
> compilation:
> 
> <--  snip  -->
> 
> $ make O=../out/x86-full
> ...
>   SHIPPED drivers/scsi/aic7xxx/aic79xx_seq.h
>   SHIPPED drivers/scsi/aic7xxx/aic79xx_reg.h
>   CC      drivers/scsi/aic7xxx/aic79xx_core.o
> gcc: drivers/scsi/aic7xxx/aic79xx_core.c: No such file or directory
> gcc: no input files
> make[4]: *** [drivers/scsi/aic7xxx/aic79xx_core.o] Error 1
> 
> <--  snip  -->
> 
> Next "make" run brings the same failure in 
> drivers/scsi/aic7xxx/aic7xxx_core.c.
> 
> With the third "make" it works.
> 
> It might compile for people with SMP systems using -j?

I can reproduce it and will fix it.

	Sam
