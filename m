From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: Ioctl warning for a partition
Date: Fri, 27 Jan 2012 17:37:56 -0200
Message-ID: <20120127193756.GC25348@khazad-dum.debian.net>
References: <20120126223037.GE28368@quack.suse.cz>
 <CA+55aFwkRhsdAYwP-S5_qPkRX=dMSnxv5Ow1ULaSJjKe3aTy2w@mail.gmail.com>
 <4F21E828.8090502@msgid.tls.msk.ru>
 <20120127192817.GB25348@khazad-dum.debian.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120127192817.GB25348@khazad-dum.debian.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Jan Kara <jack@suse.cz>, Paolo Bonzini <pbonzini@redhat.com>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@parallels.com>, mmarek@suse.cz
List-Id: linux-scsi@vger.kernel.org

On Fri, 27 Jan 2012, Henrique de Moraes Holschuh wrote:
> On Fri, 27 Jan 2012, Michael Tokarev wrote:
> > mdadm ioctls reported in various places apparently got fixed by
> > ENOTTY/ENOIOCTLCMD change.
> 
> Does that fix still need to be backported to -stable?
> 
> Linux v3.0.18 + Debian stable userspace (mdadm v3.1.4) causes this on
> boot (when mdadm runs in the initramfs):
> 
> mdadm: sending ioctl 1261 to a partition!
> mdadm: sending ioctl 1261 to a partition!
> mdadm: sending ioctl 1261 to a partition!
> mdadm: sending ioctl 1261 to a partition!
> mdadm: sending ioctl 1261 to a partition!
> mdadm: sending ioctl 1261 to a partition!
> mdadm: sending ioctl 1261 to a partition!
> mdadm: sending ioctl 1261 to a partition!
> mdadm: sending ioctl 800c0910 to a partition!
> mdadm: sending ioctl 800c0910 to a partition!

This is on x86-64/amd64.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
