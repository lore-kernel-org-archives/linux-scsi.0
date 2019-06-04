From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 5/7] scsi: mac_scsi: Fix pseudo DMA implementation, take
 2
Date: Tue, 4 Jun 2019 10:05:44 +1000 (AEST)
Message-ID: <alpine.LNX.2.21.1906040954330.40@nippy.intranet>
References: <cover.1559438652.git.fthain@telegraphics.com.au> <c56deeb735545c7942607a93f017bb536f581ae5.1559438652.git.fthain@telegraphics.com.au> <CAMuHMdWxRtJU2aRQQjXzR2mvpfpDezCVu42Eo1eXDsQaPb+j6Q@mail.gmail.com> <alpine.LNX.2.21.1906030903510.20@nippy.intranet>
 <CAMuHMdUFxQnmJmkr2qm4waTfFA5yfCHAFngyD37cFH6gbbD-Pg@mail.gmail.com> <alpine.LNX.2.21.1906031702220.37@nippy.intranet> <247ed79a-75c7-41fd-0932-0b7701ee5d4e@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <247ed79a-75c7-41fd-0932-0b7701ee5d4e@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Schmitz <schmitzmic@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>, linux-m68k <linux-m68k@lists.linux-m68k.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 4 Jun 2019, Michael Schmitz wrote:

> Hi Finn,
> 
> On 3/06/19 7:40 PM, Finn Thain wrote:
> > 
> > > There are several other drivers that contain pieces of assembler code.
> > > 
> > Does any driver contain assembler code for multiple architectures? I was
> > trying to avoid that -- though admittedly I don't yet have actual code for
> > the PDMA implementation for mac_scsi for Nubus PowerMacs.
> > 
> I've seen that once, for one of the ESP drivers that were supported on both
> m68k and ppc (APUS, PPC upgrade to Amiga computers). But that driver was
> removed long ago (after 2.6?).
> 
> In that case, the assembly file did reside in drivers/scsi/. That still
> appears to be current practice (see drivers/scsi/arm/acornscsi-io.S).
> 

The presence of that file would be an argument for adding 
drivers/scsi/m68k/. This seems to be begging the question.

Since there's no clear policy, I'll combine the two files and avoid the 
question for now.

-- 

> Cheers,
> 
> ??? Michael
> 
> 
> 
