From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: CONFIG_BLK_DEV_BSG=n
Date: Wed, 19 Sep 2007 14:53:18 +0200
Message-ID: <20070919125318.GE25592@kernel.dk>
References: <1189800008.3343.21.camel@localhost.localdomain> <598D5675D34BE349929AF5EDE9B03E27015558EA@az33exm24.fsl.freescale.net> <19650.1190040390@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:27588 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753448AbXISMwp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Sep 2007 08:52:45 -0400
Content-Disposition: inline
In-Reply-To: <19650.1190040390@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, akpm@osdl.org, Medve Emilian-EMMEDVE1 <Emilian.Medve@freescale.com>, fujita.tomonori@lab.ntt.co.jp, linuxppc-dev@ozlabs.org, Gala Kumar-B11780 <kumar.gala@freescale.com>, paulus@samba.org, linux-scsi@vger.kernel.org

On Mon, Sep 17 2007, David Howells wrote:
> 
> James Bottomley <James.Bottomley@SteelEye.com> wrote:
> 
> > > Which solution would you be more comfortable with?
> > 
> > The one which is currently in -mm is this one:
> > 
> > http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=49892223f7d3a2333ef9e6cbdd526676e1fc517a
> 
> In my opinion, this is the wrong fix.  There shouldn't be anything in
> the kernel using stuff from bsg.h if CONFIG_BLOCK=n, so there should
> be an error if anything tries to.  The correct fix is to exclude the
> non-userspace-visible contents of bsg.h with #ifdef CONFIG_BLOCK, not
> to declare things that we've tried to make sure specifically aren't
> declared.

I agree, I'll pass your fix on.

-- 
Jens Axboe

