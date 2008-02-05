From: Adrian Bunk <bunk@kernel.org>
Subject: aic7xxx build failure
Date: Tue, 5 Feb 2008 19:40:24 +0200
Message-ID: <20080205174024.GE505@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp6.pp.htv.fi ([213.243.153.40]:56147 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754186AbYBERkU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Feb 2008 12:40:20 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Commit 8891fec65ac5b5a74b50c705e31b66c92c3eddeb broke aic7xxx 
compilation:

<--  snip  -->

$ make O=../out/x86-full
...
  SHIPPED drivers/scsi/aic7xxx/aic79xx_seq.h
  SHIPPED drivers/scsi/aic7xxx/aic79xx_reg.h
  CC      drivers/scsi/aic7xxx/aic79xx_core.o
gcc: drivers/scsi/aic7xxx/aic79xx_core.c: No such file or directory
gcc: no input files
make[4]: *** [drivers/scsi/aic7xxx/aic79xx_core.o] Error 1

<--  snip  -->

Next "make" run brings the same failure in 
drivers/scsi/aic7xxx/aic7xxx_core.c.

With the third "make" it works.

It might compile for people with SMP systems using -j?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

