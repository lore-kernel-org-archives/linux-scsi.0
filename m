From: Doug Ledford <dledford@redhat.com>
Subject: Re: Why /dev/sdc1 doesn't show up...
Date: Sun, 17 Nov 2002 15:12:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021117201230.GD3280@redhat.com>
References: <20021117195258.GC3280@redhat.com> <Pine.GSO.4.21.0211171457290.23400-100000@steklov.math.psu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.21.0211171457290.23400-100000@steklov.math.psu.edu>
List-Id: linux-scsi@vger.kernel.org
To: Alexander Viro <viro@math.psu.edu>
Cc: Linux Scsi Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, Linus Torvalds <torvalds@transmeta.com>

On Sun, Nov 17, 2002 at 03:01:06PM -0500, Alexander Viro wrote:
> 
> 
> On Sun, 17 Nov 2002, Doug Ledford wrote:
> 
> > in scsi_module.c works, but is too ugly to live (and totally defeats the
> > purpose of the new module loading code anyway).  Oh, and all the high
> 
> There is a purpose?  Seriously, "no use of ones object during init" is
> WRONG.  Rusty, remember I've told you that block devices need to be
> able to open() during init?  That's what it is.
> 
> We _might_ eventually kludge around that, but IMO the ->live checks on
> the init side are just plain wrong.

I tend to agree, and I almost wrote that in my email, but then decided I 
hadn't thought on the issue long enough to declare that and then be proven 
wrong and look like a fool.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
