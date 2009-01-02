From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 7/9] exofs: mkexofs
Date: Fri, 02 Jan 2009 16:46:26 -0600
Message-ID: <1230936386.3304.22.camel@localhost.localdomain>
References: <4947BFAA.4030208@panasas.com>	<4947CA5C.50104@panasas.com>
	 <20081229121423.efde9d06.akpm@linux-foundation.org>
	 <495B8D90.1090004@panasas.com>
	 <20081231112515.2d790d1c.akpm@linux-foundation.org>
	 <495CC612.30800@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <495CC612.30800@panasas.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, avishay@gmail.com, jeff@garzik.org, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org, osd-dev@open-osd.org, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2009-01-01 at 15:33 +0200, Boaz Harrosh wrote:
> Andrew Morton wrote:
> >>> Boaz Harrosh <bharrosh@panasas.com> wrote:
> >> When, if, all is fixed, through which tree/maintainer can exofs be submitted?
> > 
> > I can merge them.  Or you can run a git tree of your own, add it to
> > linux-next and ask Linus to pull it at the appropriate time.
> > 
> 
> Hi James
> 
> Andrew suggested that maybe I should push exofs file system directly to
> Linus as it is pretty orthogonal to any other work. Sitting in linux-next
> will quickly expose any advancements in VFS and will force me to keep
> the tree uptodate.
> 
> If that is so, and is accepted by Linus, would you rather that also the
> open-osd initiator library will be submitted through the same tree?
> The conflicts with scsi are very very narrow. The only real dependency
> is the ULD being a SCSI ULD. I will routinely ask your ACK on any scsi 
> or ULD related patches. Which are very few. This way it will be easier
> to manage the dependencies between the OSD work, the OSD pNFS-Objects
> trees at pNFS project, and the pNFSD+EXOFS export. One less dependency.
> 
> [I already have such a public tree at git.open-osd.org for a while now]

Since it's sitting in SCSI, at least the libosd piece belongs over the
SCSI mailing list, so I think it makes sense to continue updating it via
the SCSI tree.

What's the status of the major number request from LANANA.  That's patch
number one, and I haven't heard that they've confirmed the selection of
260 yet; or is LANANA now dead and it's who gets the major into the tree
first?

James


