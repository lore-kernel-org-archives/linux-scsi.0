From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: Why /dev/sdc1 doesn't show up...
Date: Wed, 20 Nov 2002 07:58:13 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021120072653.E1EC72C060@lists.samba.org>
References: <20021119000924.GD6989@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
In-reply-to: Your message of "Mon, 18 Nov 2002 19:09:24 CDT."
             <20021119000924.GD6989@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Alexander Viro <viro@math.psu.edu>, Linux Scsi Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@transmeta.com>

In message <20021119000924.GD6989@redhat.com> you write:
> On Tue, Nov 19, 2002 at 10:49:21AM +1100, Rusty Russell wrote:
> > In message <Pine.GSO.4.21.0211180403440.23400-100000@steklov.math.psu.edu> 
you 
> > write:
> > > Not really.  For case in question (block devices) there is only one path
> > > and I'd rather keep it that way, thank you very much.
> > 
> > See other posting.  This is a fundamental design decision, and it's
> > not changing.  Sorry.
> 
> Then you'll have to back out the patch to module.c because it's already 
> changed.

Yeah, I just noticed.  To be honest, I was wrong.  And the code
shouldn't be put back until (if ever) I have a solution which solves
the races and *doesn't* break working code.

And meanwhile, there are more important things (like reducing the 400k
overhead of CONFIG_KALLSYMS adds to the kernel).

Sorry for the overzealousness,
Rusty.
--
  Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
