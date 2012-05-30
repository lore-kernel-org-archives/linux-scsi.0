From: maximilian attems <max-U9r9yeDMy7A@public.gmane.org>
Subject: Re: Remove scsi_wait_scan module
Date: Wed, 30 May 2012 10:03:05 +0000
Message-ID: <20120530100305.GE10036@vostochny.stro.at>
References: <1338110026.2957.5.camel@dabdike.int.hansenpartnership.com>
 <20120528100015.GB10036@vostochny.stro.at>
 <1338206866.6330.22.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <initramfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1338206866.6330.22.camel@dabdike>
Sender: initramfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeff Mahoney <jeffm-l3A5Bk7waGM@public.gmane.org>, Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>, initramfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Mon, May 28, 2012 at 04:07:46PM +0400, James Bottomley wrote:
> On Mon, 2012-05-28 at 10:00 +0000, maximilian attems wrote:
> > 
> > There is quite a number of bug reports moaning about having to boot with
> > `scsi_mod.scan=sync'. I didn't pass them on, because I didn't knew that
> > the module itself got broken, for example:
> > http://bugs.debian.org/616689
> 
> OK, so what these bugs show is the breakage ... basically scsi_wait_scan
> isn't really waiting for the scans to complete.  I can fix it in stable
> so you can close your bug reports, but if I do, can you also transition
> away from using it so I can remove it in 3.5?
> 

Thank you very much for the patch, guess Ben will pick it for 3.2 via
stable and we'll add it for 2.6.32 too.

I'll have enough time for afterwards fix to have the udev wait root,
even if right now I'm a bit unsure what it means beyond adding a specific
rule?

-- 
maks
