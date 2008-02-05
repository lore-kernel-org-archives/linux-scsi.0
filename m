From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: aic7xxx build failure
Date: Tue, 05 Feb 2008 12:18:04 -0600
Message-ID: <1202235484.3133.49.camel@localhost.localdomain>
References: <20080205174024.GE505@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759173AbYBESS3@vger.kernel.org>
In-Reply-To: <20080205174024.GE505@cs181133002.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Tue, 2008-02-05 at 19:40 +0200, Adrian Bunk wrote:
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

Could you run this with V=1 to get us a verbose output of what the exact
files gcc is failing on are?

Thanks,

James
