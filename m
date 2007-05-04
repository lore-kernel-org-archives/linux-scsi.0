From: Frank van Maarseveen <frankvm@frankvm.com>
Subject: Re: libata /dev/scd0 problem: mount after burn fails without eject
Date: Fri, 4 May 2007 10:37:35 +0200
Message-ID: <20070504083735.GA20072@janus>
References: <20070501135951.GA17072@janus> <46374C11.1010702@rtr.ca> <6bffcb0e0705010731v44cfad1awf4342121245f7ab3@mail.gmail.com> <463AEBE0.7010506@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932478AbXEDIhi@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <463AEBE0.7010506@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, Mark Lord <lkml@rtr.ca>, Frank van Maarseveen <frankvm@frankvm.com>, linux-scsi <linux-scsi@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-kernel@vger.kernel.org, Alan Cox <alan@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, May 04, 2007 at 10:16:32AM +0200, Tejun Heo wrote:
> Michal Piotrowski wrote:
> > On 01/05/07, Mark Lord <lkml@rtr.ca> wrote:
> >> Forwarding to linux-scsi and linux-ide mailing lists.
> >>
> >> Frank van Maarseveen wrote:
> >> > Tested on 2.6.20.6 and 2.6.21.1
> >> >
> >> > I decided to swich from the old IDE drivers to libata and now there
> >> > seems to be a little but annoying problem: cannot mount an ISO image
> >> > after burning it.
> >> >
> >> > May  1 14:32:55 kernel: attempt to access beyond end of device
> >> > May  1 14:32:55 kernel: sr0: rw=0, want=68, limit=4
> >> > May  1 14:32:55 kernel: isofs_fill_super: bread failed, dev=sr0,
> >> iso_blknum=16, block=16
> >> >
> >> > an "eject" command seems to fix the state of the PATA DVD writer
> >> > or driver. The problem occurs for burning a CD and for DVD too with
> >> > identical error messages.
> 
> Right after burning, if you run 'fuser -v /dev/sr0', what does it say?

Tried the fuser as root to be sure but it didn't show anything.

-- 
Frank
