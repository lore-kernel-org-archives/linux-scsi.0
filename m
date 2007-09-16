From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 16/22] advansys: Eliminate prototypes
Date: Sun, 16 Sep 2007 17:03:50 -0600
Message-ID: <20070916230349.GE28350@parisc-linux.org>
References: <11893498072821-git-send-email-matthew@wil.cx> <1189867145.3339.3.camel@localhost.localdomain> <20070916153134.GA28350@parisc-linux.org> <20070915224331U.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:52577 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbXIPXDv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Sep 2007 19:03:51 -0400
Content-Disposition: inline
In-Reply-To: <20070915224331U.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Mon, Sep 17, 2007 at 07:41:06AM +0900, FUJITA Tomonori wrote:
> On Sun, 16 Sep 2007 09:31:34 -0600
> Matthew Wilcox <matthew@wil.cx> wrote:
> 
> > On Sat, Sep 15, 2007 at 09:39:05AM -0500, James Bottomley wrote:
> > > I get a compile failure at this point in your patch sequence:
> > 
> > Thanks.  I'd been compiling with CONFIG_ISA=n, so hadn't spotted these
> > two problems.  I've set it back to Y now.
> 
> If I compile your latest patchset with CONFIG_ISA=n, I got:
> 
> drivers/built-in.o: In function `advansys_init':
> advansys.c:(.init.text+0x3efb): undefined reference to `isa_register_driver'
> advansys.c:(.init.text+0x3f22): undefined reference to `isa_unregister_driver'

Fixed by http://marc.info/?l=linux-kernel&m=118780055118323&w=2 which I
thought was in -mm, but I can't find it.  I've just reset it to Linus &
Andrew.  Thanks for mentioning it.

Now I'm back home, I'll add your sg patch to my tree.  I'd forgotten
about it ...

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
