From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 00/71] More fixes, cleanup and modernization for NCR5380
 drivers
Date: Fri, 20 Nov 2015 02:00:47 -0800
Message-ID: <20151120100047.GA27842@infradead.org>
References: <20151118083455.331768508@telegraphics.com.au>
 <201511181235.15663.linux@rainbow-software.org>
 <alpine.LNX.2.00.1511191321010.9967@nippy.intranet>
 <201511192350.58253.linux@rainbow-software.org>
 <alpine.LNX.2.00.1511201238430.31133@nippy.intranet>
 <alpine.LNX.2.00.1511201820130.14450@nippy.intranet>
 <20151120073354.GA26080@infradead.org>
 <alpine.LNX.2.00.1511201909540.15006@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1511201909540.15006@nippy.intranet>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Christoph Hellwig <hch@infradead.org>, Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>, Michael Schmitz <schmitzmic@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Nov 20, 2015 at 07:19:21PM +1100, Finn Thain wrote:
> Yes. I didn't do that conversion because I don't have ISA hardware and I 
> don't understand ISA probing.
> 
> The present patch set doesn't seek to resurrect the ISA drivers. But I am 
> trying to avoid regressions.
> 
> I have mixed feelings about the ISA drivers. ISA DMA support complicates 
> things (it was never completed) and DMA seems to be the main obstacle to 
> merging the two core driver forks.

I'd love to be able to get rid of the ISA drivers to be honest.  Given
that they appear to be gravely broken before your cleanups this might
be an opportunity to get rid of them.
