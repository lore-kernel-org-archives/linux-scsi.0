From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: CFP: Linux 2007 File System & IO Workshop
Date: Tue, 17 Oct 2006 16:25:06 -0700 (PDT)
Message-ID: <20061017232506.36297.qmail@web31805.mail.mud.yahoo.com>
References: <1161124834.6245.51.camel@mulgrave.il.steeleye.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1161124834.6245.51.camel@mulgrave.il.steeleye.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Ric Wheeler <ric@emc.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, reiserfs-list@namesys.com, ext2-devel@lists.sourceforge.net, linux-ide@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-scsi@vger.kernel.org, lsf07pc@usenix.org
List-Id: linux-scsi@vger.kernel.org

--- James Bottomley <James.Bottomley@SteelEye.com> wrote:
> On Mon, 2006-10-16 at 20:40 -0400, Ric Wheeler wrote:
> > On  February 12-13, we have put together a combined Linux file system & 
> > IO 2-day workshop in San Jose, CA. Note that the USENIX File System and 
> > Storage Technologies conference follows us in the same venue, so we hope 
> > to get some interaction between the two groups as well as leverage the 
> > USENIX people to help us get this done.
> > 
> > For more information, please see:
> > 
> > http://www.usenix.org/events/lsf07/
> 
> Just to clarify, this event is a follow on to the Vancouver Storage
> summit.

The only mentioning of "Vancouver Storage summit" in the web content
therein was, quoting from http://www.usenix.org/events/lsf07/cfp/ :
 ...
 * Progress reports on implementation of features discussed at the
   Vancouver Storage Summit
 ...
So by "follow on" you mean "progress report" only?  Or will this
event also accept and/or discuss new material?

> Although USENIX is helping us to run it, you don't have to be
> a USENIX member to submit a position paper.  The idea of the position
> papers is to give the limited number of places (for storage we've got
> about 20-25 and about the same again for fs) to people who have
> interesting topics they need to discuss---so if you submit, be prepared
> to make a presentation of it.

Can I make a presentation of this paper:

Serial Attached SCSI, An Architecture For Linux
---------------------------------
This paper would start with an overview of SCSI (SCSI-3, that is), its
object oriented nature and why such is the direction of SCSI.

Then an introduction to SAS from this SCSI point of view will be given,
i.e. where it fits in the object oriented model, why and how. There may be
very little SAS technical introduction--a couple of sentences, something
anyone would understand and something sufficient for the latter sections of
the paper.

Then an introduction to SAS as an architecture in a SCSI stack would
follow. A layered, object oriented model will be presented, similar to the
one found in my code.

This will be accompanied with a SCSI "architectural roadmap", the how and
why the architecture.

Then an overview of pure-SCSI drivers would be given (at this point the
paper talks about implementations at each layer of the storage software
stack). Those are implementations which hide the transport layer completely
in their firmware, and present a pure SCSI "picture", a la SAM, to the
OS. How and why they do it and why it is better.

Then the paper would talk about what unifies those implementations, how it
can be done, and why it should be done this way. An introduction to SDI,
SCSI Driver Interface, would be presented.

There would be a section on a SCSI/ATA Translation, SAT, and a SAT
Layer (SATL). Where it fits, how and why. What its interface is and why.

The paper would include pictures and figures as necessary to show layers,
object oriented concepts and the like.
----------------------------------------

The thread is here:
http://marc.theaimsgroup.com/?t=114197580200002&r=1&w=2

   Luben

