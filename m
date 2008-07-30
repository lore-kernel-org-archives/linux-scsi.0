From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: tools support for non-512 byte sector sizes
Date: Wed, 30 Jul 2008 08:51:47 -0500
Message-ID: <20080730135147.GA4513@auslistsprd01.us.dell.com>
References: <488F524F.6020905@redhat.com> <20080729182611.GB24924@parisc-linux.org> <1217356645.6103.48.camel@localhost.localdomain> <yq13alsr0g0.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq13alsr0g0.fsf@sermon.lab.mkp.net>
Sender: linux-ide-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Matthew Wilcox <matthew@wil.cx>, Ric Wheeler <rwheeler@redhat.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Jim Meyering <jim@meyering.net>, linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 29, 2008 at 02:48:31PM -0400, Martin K. Petersen wrote:
> >>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:
> 
> James> The problem, which ata_ram also suffers, is that the tools we
> James> most need to test are the ones for manipulating non volatile
> James> characteristics (like partition tables).  We'd really like the
> James> disk contents to survive reboot for this ...
> 
> Yeah, I should add that I wanted persistence too.  I went through a
> whole stack (well, 5-6 or so) fibre channel drives from various
> vendors and attempted to low-level format them to 4KB sectors.  Most
> of them laughed in my face.  One of them tried to comply and
> irreparably confused its firmware in the process.
> 
> Just yesterday I received a couple of prototype drives in the mail.
> I'll ask the vendor whether they support 4KB and if so I'll give them
> a whirl.

I have access to disks with native 4KB sectors now too.  Would
interested parties be willing to share test plans, so we could be sure
we have coverage wrt correctness: kernel internals, userspace tools like parted,
fdisk, kpartx, apps using O_DIRECT)?  Benchmarking winds up being an
NDA activity this early in the game so I don't want the focus of any
joint work to be benchmarks yet.

-- 
Matt Domsch
Linux Technology Strategist, Dell Office of the CTO
linux.dell.com & www.dell.com/linux
