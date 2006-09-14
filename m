From: Andrew Morton <akpm@osdl.org>
Subject: Re: [GIT PATCH] (hopefully) final SCSI fixes for 2.6.19
Date: Thu, 14 Sep 2006 14:47:03 -0700
Message-ID: <20060914144703.ade9b00b.akpm@osdl.org>
References: <1158268378.3514.61.camel@mulgrave.il.steeleye.com>
	<20060914142044.4272fc56.akpm@osdl.org>
	<1158269859.3514.74.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:34012 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751223AbWINVrI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Sep 2006 17:47:08 -0400
In-Reply-To: <1158269859.3514.74.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Alex Davis <alex14641@yahoo.com>
Cc: Linus Torvalds <torvalds@osdl.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 14 Sep 2006 16:37:39 -0500
James Bottomley <James.Bottomley@SteelEye.com> wrote:

> On Thu, 2006-09-14 at 14:20 -0700, Andrew Morton wrote:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.18-rc6/2.6.18-rc6-mm2/broken-out/fix-panic-when-reinserting-adaptec-pcmcia-scsi-card.patch
> > might be handy too.  Your ack is my command.
> 
> Well ... no, not really, on the grounds that the patch is wrong.

So is oopsing ;)

> The correct fix is to eliminate the aha152x_host array by converting the
> driver to the correct driver model ... I just haven't had time to look
> at doing that yet.

<lachrymose>If we'd been told that on July 8 and/or August 14, this might
be fixed by now</>

Perhaps Alex might like to take a look into doing this (please)?
