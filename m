From: Linus Torvalds <torvalds@transmeta.com>
Subject: Re: [PATCH] SCSI and FibreChannel Hotswap for linux 2.5.44-bk2
Date: Wed, 30 Oct 2002 11:29:18 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0210301127170.7614-100000@home.transmeta.com>
References: <1036007128.5141.119.camel@irongate.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1036007128.5141.119.camel@irongate.swansea.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Steven Dake <sdake@mvista.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org


On 30 Oct 2002, Alan Cox wrote:
>
> On Wed, 2002-10-30 at 18:54, Steven Dake wrote:
> > This patch has been reviewed by Alan Cox, Greg KH, Christoph Hellwig, 
> > Patrick Mansfield, Rob Landly, Jeff Garzik, Scott Murray, James 
> 
> Glanced at briefly once, not reviewed.

I'm going to leave the merging of this to the scsi people, in particular 
James and Doug. My personal feeling right now is that it's not going in 
the feature freeze, but as a driver thing I'm also convinced that 
especially if vendors need it, they'll add it anyway - and drivers tend to 
be less "frozen" than core code anyway (by necessity: we've always had to 
accept new drivers even in stable series).

		Linus

