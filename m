From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 00/71] More fixes, cleanup and modernization for NCR5380
 drivers
Date: Thu, 19 Nov 2015 23:33:54 -0800
Message-ID: <20151120073354.GA26080@infradead.org>
References: <20151118083455.331768508@telegraphics.com.au>
 <201511181235.15663.linux@rainbow-software.org>
 <alpine.LNX.2.00.1511191321010.9967@nippy.intranet>
 <201511192350.58253.linux@rainbow-software.org>
 <alpine.LNX.2.00.1511201238430.31133@nippy.intranet>
 <alpine.LNX.2.00.1511201820130.14450@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-m68k-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1511201820130.14450@nippy.intranet>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>, Michael Schmitz <schmitzmic@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Nov 20, 2015 at 06:21:06PM +1100, Finn Thain wrote:
> > Not sure what module was being probed here. I presume it was g_NCR5380 
> > or g_NCR5380_mmio. Neither of these calls 'scsi_scan_host'. I'm not sure 
> > what the implications are (?)
> 
> Nevermind. The call is in scsi_module.c.

Which, btw really need to go away.  If you want to resurrect the
ISA drivers they need to be converted to proper probing.
