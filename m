From: Adrian Bunk <bunk@stusta.de>
Subject: 2.6.22-rc6-mm1: multiple definition of `check_reset'
Date: Thu, 28 Jun 2007 21:29:50 +0200
Message-ID: <20070628192950.GT1094@stusta.de>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:43558 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762888AbXF1T3a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jun 2007 15:29:30 -0400
Content-Disposition: inline
In-Reply-To: <20070628034321.38c9f12b.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Mark Salyzyn <aacraid@adaptec.com>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, kkeil@suse.de, kai.germaschewski@gmx.de, isdn4linux@listserv.isdn4linux.de

On Thu, Jun 28, 2007 at 03:43:21AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.22-rc4-mm2:
>...
>  git-scsi-misc.patch
>...
>  git trees
>...


<--  snip  -->

...
  LD      drivers/built-in.o
drivers/isdn/built-in.o: In function `check_reset': (.text+0xab974):
multiple definition of `check_reset'
drivers/scsi/built-in.o:(.data+0xdba8): first defined here
ld: Warning: size of symbol `check_reset' changed from 4 in drivers/scsi/built-in.o to 214 in drivers/isdn/built-in.o
ld: Warning: type of symbol `check_reset' changed from 1 to 2 in drivers/isdn/built-in.o
make[2]: *** [drivers/built-in.o] Error 1

<--  snip  -->


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


