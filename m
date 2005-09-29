From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: I request inclusion of SAS Transport Layer and AIC-94xx into
 the kernel
Date: Thu, 29 Sep 2005 12:33:17 -0400
Message-ID: <433C174D.4050302@adaptec.com>
References: <Pine.LNX.4.10.10509281227570.19896-100000@master.linux-ide.org>	 <433B0374.4090100@adaptec.com> <20050928223542.GA12559@alpha.home.local>	 <433BFB1F.2020808@adaptec.com> <1128007032.11443.77.camel@tara.firmix.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932170AbVI2Qdb@vger.kernel.org>
In-Reply-To: <1128007032.11443.77.camel@tara.firmix.at>
Sender: linux-kernel-owner@vger.kernel.org
To: Bernd Petrovitsch <bernd@firmix.at>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andre Hedrick <andre@linux-ide.org>, Patrick Mansfield <patmans@us.ibm.com>, Luben Tuikov <ltuikov@yahoo.com>, Jeff Garzik <jgarzik@pobox.com>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
List-Id: linux-scsi@vger.kernel.org

On 09/29/05 11:17, Bernd Petrovitsch wrote:
> 
> Then submit your driver as a (separate) block device in parallel to the
> existing SCSI subsystem. People will use it for/with other parts if it

SAS is ultimately SCSI.  I'll just have to write my own SCSI core.
_We_ together can do this in parallel to the old SCSI Core.

This is the whole idea.

> makes sense (and you - as the maintainer - accept their patches). And in

You see, at my age and my situation, I no longer see this as
"my balls - your balls".  What matters to me is good design,
quality code, customer satisfaction, bottom line.

E.g. I'm quite a liberal person and I wouldn't block
or stop new technologes from going into Linux on the basis
and merit of my not understanidn that particular new technology.

The bottom line is not "my balls - your balls" but the wide
spread use of Linux and "storage OS of choice".  Not "hobbyist
OS of choice" and not "let me play Robin Hood".

> a few years the "old" SCSI core fades out as legacy drives fade out (or
> they will happily coexist forever).

Yep, I've been saying this since 2002.  On the linux-scsi ML.

> The point is: If *you* want it that way, *you* must go that way (and do
> not expect others to do it just that *you* get *your* driver merged).
> You are the maintainer of the new stuff and (almost) everything will
> work as you want.

And this is the problem: *you* and "the community" see things in
*this* way:  "your balls - my balls", "yours/mine".

While I see things like this: new technology, absolve, use, move on.

As to your comment above, it's not about how *I* see things.
It's about how things _actually_ *are*:
http://www.t10.org/ftp/t10/drafts/sam4/sam4r03.pdf

> It might not be the cleanest or most elegant solution in the world, but
> if it works, who cares and why?

Turn the table around: can _I_ pose this question to JB and Christoph?

(since they are the ones who think this of SAM/SPC)

> Where is now the real problem?
> I can't see one.

Me neither.

	Luben
