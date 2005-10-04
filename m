From: Andre Hedrick <andre@linux-ide.org>
Subject: Re: I request inclusion of SAS Transport Layer and AIC-94xx into
 the kernel
Date: Mon, 3 Oct 2005 23:51:51 -0700 (PDT)
Message-ID: <Pine.LNX.4.10.10510032345090.410-100000@master.linux-ide.org>
References: <4341599D.70904@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932433AbVJDGwh@vger.kernel.org>
In-Reply-To: <4341599D.70904@adaptec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Arjan van de Ven <arjan@infradead.org>, "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, andrew.patterson@hp.com, dougg@torque.net, Linus Torvalds <torvalds@osdl.org>, Luben Tuikov <ltuikov@yahoo.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


On Mon, 3 Oct 2005, Luben Tuikov wrote:

> On 10/01/05 19:55, Alan Cox wrote:
> > On Gwe, 2005-09-30 at 19:53 +0200, Arjan van de Ven wrote:
> > 
> >>that makes me wonder... why and how does T10 control linux abi's ??
> > 
> > 
> > Indirectly the standards do define APIs at the very least. A good
> > example is taskfile. ACPI methods (which we don't yet use) allow get/set
> > mode, get features on the motherboard ATA controller if you don't know
> > how to drive it. The objects they work in are taskfiles. No taskfiles,
> > no ACPI.
> 
> Yes, that's true.

Luben,

Here was your entry point to state SCSI uses "taskfiles" in the packet
transport.

> Even more is true.  Standards and specs define the
> _layering infrastructure_ which if implemented, 
> allows for layer intersection.
> 
> For example, if one needs to insert a SATL later just because
> the underlaying transport was found able to transport it,
> since the layering is well defined and _so_ implemented, it wouldn't
> be hard to interface antother well defined layer in.
> 
> If, OTOH, things are conglomerated into a blob, just because
> the kernel engineers (not (storage) engineers per se) found _no_ current
> use of the layering infrastructure and separating the layers
> was found do add  "more maintenance", then this will turn around
> sooner or later to bite back.

Not everyone has to be a "storage engineer", but a "storage engineer" must
be able to explain to any OS developer/engineer the scope of the transport
and work within the OS or explain why a change is required.

A lot of both has happened so ... to quote Elmo:

"ARE WE THERE YETTTTTTTTTTTTTTTTTTTT!"

This process is moving like rush hours in the SF-Bay area.

Cheers,

Andre
