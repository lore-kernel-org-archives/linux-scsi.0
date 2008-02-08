From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [GIT PATCH] final SCSI updates for 2.6.24 merge window
Date: Fri, 08 Feb 2008 12:53:28 +0900
Message-ID: <20080208125328J.fujita.tomonori@lab.ntt.co.jp>
References: <1202432206.3171.53.camel@localhost.localdomain>
	<1202434627.3171.63.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:43137 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798AbYBHDxk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Feb 2008 22:53:40 -0500
In-Reply-To: <1202434627.3171.63.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, 07 Feb 2008 19:37:07 -0600
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> 
> On Thu, 2008-02-07 at 18:56 -0600, James Bottomley wrote:
> > Quite a bit of this is fixing things broken previously (the advansys fix
> > is still pending resolution, but I'll send it as an -rc fix when we have
> > it).  There's the final elimination of all drivers that are esp based
> > but don't use the scsi_esp core (that's mostly m68k and alpha).  Plus
> > the usual bunch of driver updates and the addition of a new enclosure
> > services driver and the corresponding ULD.
> 
> OK, the advansys fix came in.  I've added it to the patch.
> 
> James
> 
> ----
> 
> >From f983323fea178352ed3b69c70561a13825a3ce59 Mon Sep 17 00:00:00 2001
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Date: Fri, 8 Feb 2008 09:50:08 +0900
> Subject: [SCSI] advansys: fix overrun_buf aligned bug

Seems that it was a bit late, Linus pulled scsi-misc before the patch
was added.
