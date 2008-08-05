From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: tools support for non-512 byte sector sizes
Date: Tue, 5 Aug 2008 11:57:10 -0500
Message-ID: <20080805165710.GA5648@auslistsprd01.us.dell.com>
References: <488F524F.6020905@redhat.com> <20080729182611.GB24924@parisc-linux.org> <1217356645.6103.48.camel@localhost.localdomain> <yq13alsr0g0.fsf@sermon.lab.mkp.net> <20080730135147.GA4513@auslistsprd01.us.dell.com> <20080801161149.GA26461@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080801161149.GA26461@parisc-linux.org>
Sender: linux-ide-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Ric Wheeler <rwheeler@redhat.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Jim Meyering <jim@meyering.net>, linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Aug 01, 2008 at 10:11:49AM -0600, Matthew Wilcox wrote:
> On Wed, Jul 30, 2008 at 08:51:47AM -0500, Matt Domsch wrote:
> > I have access to disks with native 4KB sectors now too.  Would
> > interested parties be willing to share test plans, so we could be
> > sure we have coverage wrt correctness: kernel internals, userspace
> > tools like parted, fdisk, kpartx, apps using O_DIRECT)?
> > Benchmarking winds up being an NDA activity this early in the game
> > so I don't want the focus of any joint work to be benchmarks yet.
> 
> Are they SCSI?

yes (SAS).

-- 
Matt Domsch
Linux Technology Strategist, Dell Office of the CTO
linux.dell.com & www.dell.com/linux
