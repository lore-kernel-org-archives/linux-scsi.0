From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 00/71] More fixes, cleanup and modernization for NCR5380
 drivers
Date: Fri, 20 Nov 2015 18:21:06 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1511201820130.14450@nippy.intranet>
References: <20151118083455.331768508@telegraphics.com.au> <201511181235.15663.linux@rainbow-software.org> <alpine.LNX.2.00.1511191321010.9967@nippy.intranet> <201511192350.58253.linux@rainbow-software.org>
 <alpine.LNX.2.00.1511201238430.31133@nippy.intranet>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1511201238430.31133@nippy.intranet>
Sender: linux-m68k-owner@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Sam Creasey <sammy@sammy.net>, Michael Schmitz <schmitzmic@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Fri, 20 Nov 2015, I wrote:

> On Thu, 19 Nov 2015, Ondrej Zary wrote:
> 
> > [  240.108501] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > [  240.108597] modprobe        D 0000001a     0  1957   1950 0x00000000
> > [  240.108790]  ce0fad00 00000086 53881781 0000001a c1525f88 4edbe39c 0000001a 04ac33e5
> > [  240.109246]  00000000 ccd54000 ffffffff ffffffff d204b280 c139c504 00000000 c104416d
> > [  240.109699]  00000000 ce0fad00 c1054a45 c151fd8c c151fd8c d204b280 00000000 ccd6d100
> > [  240.110156] Call Trace:
> > [  240.110295]  [<c139c504>] ? schedule+0x5b/0x67
> > [  240.110430]  [<c104416d>] ? async_synchronize_cookie_domain+0x73/0x9f
> > [  240.110569]  [<c1054a45>] ? abort_exclusive_wait+0x6e/0x6e
> > [  240.110699]  [<c10ac9bc>] ? do_init_module+0xa4/0x1a3
> > [  240.110824]  [<c107ddb5>] ? load_module+0x14de/0x18ca
> > [  240.110948]  [<c107e2a0>] ? SyS_finit_module+0x47/0x56
> > [  240.111068]  [<c139e2c0>] ? sysenter_do_call+0x12/0x12
> 
> Not sure what module was being probed here. I presume it was g_NCR5380 
> or g_NCR5380_mmio. Neither of these calls 'scsi_scan_host'. I'm not sure 
> what the implications are (?)

Nevermind. The call is in scsi_module.c.

-- 
