From: PinkFreud <pf-linux-scsi-20040717@mirkwood.net>
Subject: Re: sym53c8xx_2 funkiness...
Date: Sat, 24 Jul 2004 12:56:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040724165625.GA1105@eriador.mirkwood.net>
References: <20040718030514.GJ1105@eriador.mirkwood.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pcp09895235pcs.ewndsr01.nj.comcast.net ([68.36.161.84]:24324
	"HELO rivendell.mirkwood.net") by vger.kernel.org with SMTP
	id S261682AbUGXQ40 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 24 Jul 2004 12:56:26 -0400
Content-Disposition: inline
In-Reply-To: <20040718030514.GJ1105@eriador.mirkwood.net>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Any ideas on why this is happening?  This system has become quite
unstable...


On Sat, Jul 17, 2004 at 11:05:14PM -0400, PinkFreud babbled thus:
> I have a box with an old NCR 53c810 scsi card.  It was running fine
> with Slackware and a vanilla 2.4.19 kernel for the past year or so.
> I recently decided to install Debian on it, and started out with the
> Debian 2.4.26 package.  It wasn't long before I started noticing
> messages like
> sym0: SCSI BUS reset detected.
> sym0: SCSI BUS has been reset.
> in dmesg.  This also seems to hose the box more often than not...
> 
> I've also tried Debian's 2.6.6 kernel package.  This one now gives me
> sym0:0: ERROR (a0:0) (8-0-0) (8/13/0) @ (mem 13000800:13000800).
> sym0: regdump: da 00 00 13 47 08 00 1e 00 08 80 00 80 00 07 02 30 70 fa
> 04 02 ff ff ff.
> sym0: PCI STATUS = 0x2000
> sym0: SCSI BUS reset detected.
> sym0: SCSI BUS has been reset.
> - also usually accompanied by the box failing to respond afterwards
> (this particular time, I wound up being lucky, as the box continued to
> boot).
> 
> I've tried to send email to the author of the sym83c8xx driver (Gerard
> Roudier), but email to him bounced.
> 
> Any ideas on why I'm seeing this?  I suspect a driver issue, as it only
> appeared after installing Debian and new kernels.
> 
> lspci output for this card:
> 0000:00:06.0 Non-VGA unclassified device: LSI Logic / Symbios Logic
> 53c810 (rev 01)
>         Flags: bus master, medium devsel, latency 64, IRQ 11
>         I/O ports at fc00
>         Memory at fedffc00 (32-bit, non-prefetchable) [size=256]

-- 
                                                                      
Mike Edwards                    |   If this email address disappears,   
Unsolicited advertisments to    |   assume it was spammed to death.  To
this address are not welcome.   |   reach me in that case, s/-.*@/@/
(This means you, Cogent!)       |                                   
