From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: Why /dev/sdc1 doesn't show up...
Date: Wed, 20 Nov 2002 08:42:23 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021120072654.2C1AD2C085@lists.samba.org>
References: <3DDA7B08.7010101@pobox.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
In-reply-to: Your message of "Tue, 19 Nov 2002 12:55:20 CDT."
             <3DDA7B08.7010101@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Alexander Viro <viro@math.psu.edu>, Linux Scsi Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@transmeta.com>

In message <3DDA7B08.7010101@pobox.com> you write:
> Doug Ledford wrote:
> > are ready for them to be used.  Don't muck with the module loader to 
> > solve
> > the problem, fix the maybe 4 or 5 modules that might violate this rule.
> 
> violently agreed.  This has the potential for requiring an update of 
> almost every driver in the kernel, does it not?

God no!  I'm crazy maybe, but not stupid.  I know of two interfaces
which would be affected, and no drivers.

Rusty.
--
  Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
