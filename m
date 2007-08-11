From: Adrian Bunk <bunk@kernel.org>
Subject: Re: [patch 05/30] drivers/scsi/pcmcia/nsp_cs.c: remove kernel 2.4
	code
Date: Sat, 11 Aug 2007 04:08:34 +0200
Message-ID: <20070811020834.GC22213@stusta.de>
References: <200708102150.l7ALoZTO011329@imap1.linux-foundation.org> <1186794119.6334.18.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:40326 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758221AbXHKCIs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Aug 2007 22:08:48 -0400
Content-Disposition: inline
In-Reply-To: <1186794119.6334.18.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: akpm@linux-foundation.org, linux-scsi@vger.kernel.org

On Fri, Aug 10, 2007 at 09:01:59PM -0400, James Bottomley wrote:
> On Fri, 2007-08-10 at 14:50 -0700, akpm@linux-foundation.org wrote:
> > From: Adrian Bunk <bunk@stusta.de>
> 
> You're not just removing the 2.4 code ... you're also removing the rcs
> tags ... that's OK if the maintainer is fine with this, but it would
> help to say this in the change log.

It was in the patch description when I sent the patch [1, 2], but it 
seems the patch description got lost somewhere.

> James

cu
Adrian

[1] http://lkml.org/lkml/2007/3/26/2
[2] http://lkml.org/lkml/2007/4/26/654

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

