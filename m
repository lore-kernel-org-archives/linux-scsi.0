From: PinkFreud <pf-linux-scsi-20040717@mirkwood.net>
Subject: Re: sym53c8xx_2 funkiness...
Date: Wed, 28 Jul 2004 08:45:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040728124509.GK1105@eriador.mirkwood.net>
References: <20040718030514.GJ1105@eriador.mirkwood.net> <20040724165625.GA1105@eriador.mirkwood.net> <m3zn5nxi6j.fsf@merlin.emma.line.org> <20040726160214.GB1105@eriador.mirkwood.net> <20040726161825.GA14799@merlin.emma.line.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pcp09895235pcs.ewndsr01.nj.comcast.net ([68.36.161.84]:4881
	"HELO rivendell.mirkwood.net") by vger.kernel.org with SMTP
	id S266902AbUG1MpQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jul 2004 08:45:16 -0400
Content-Disposition: inline
In-Reply-To: <20040726161825.GA14799@merlin.emma.line.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Mon, Jul 26, 2004 at 06:18:26PM +0200, Matthias Andree babbled thus:
> On Mon, 26 Jul 2004, PinkFreud wrote:
> 
> > Can one safely disable disconnect if there are multiple devices on the
> > bus?  In particular, the system has a hard disk and a cdrom (both
> > external - and yes, I tried replacing the cable from the box to the
> > drives, and at the moment, I only have the hd plugged in).
> 
> It'll cause some quirks, such as the HD not being able to be accessed
> while the CD-ROM retries reading a defective sector or while it is
> operating its tray to eject or load a disc.

Uhgh.

> 
> > It's possible I just need to provide some options to the driver - I
> > wouldn't be surprised if some defaults have changed to favor newer
> > hardware.  I merely need to find out *what* needs changing...
> 
> The documentation in the kernel sources (Documentation/scsi/...) is
> quite detailed.

Alas, 2.4.26's Documentation/ only seems to contain:
scsi-changer.txt  scsi-generic.txt  scsi.txt          

Nothing directly referencing sym53c8xx.

I've looked at the sym53c8xx docs from 2.6.x, though.  You're right in
saying they're detailed.  Unfortunately, there are quite a few options
one can pass to the driver, and I'm not sure which might help me, and
what arguments I should use.

It's like trying to find a needle in a haystack... in the dark.

I analyzed the error I got out of 2.6.6, using the 2.6.x docs.  All I
really got out of that was 'it's broken, someone with scsi knowledge
might have a clue'.

What do I do?  Just give up on having Linux work on this box?


> 
> -- 
> Matthias Andree

-- 
                                                                      
Mike Edwards                    |   If this email address disappears,   
Unsolicited advertisments to    |   assume it was spammed to death.  To
this address are not welcome.   |   reach me in that case, s/-.*@/@/
(This means you, Cogent!)       |                                   
