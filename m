From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: tools support for non-512 byte sector sizes
Date: Fri, 1 Aug 2008 10:11:49 -0600
Message-ID: <20080801161149.GA26461@parisc-linux.org>
References: <488F524F.6020905@redhat.com> <20080729182611.GB24924@parisc-linux.org> <1217356645.6103.48.camel@localhost.localdomain> <yq13alsr0g0.fsf@sermon.lab.mkp.net> <20080730135147.GA4513@auslistsprd01.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080730135147.GA4513@auslistsprd01.us.dell.com>
Sender: linux-ide-owner@vger.kernel.org
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Ric Wheeler <rwheeler@redhat.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Jim Meyering <jim@meyering.net>, linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 30, 2008 at 08:51:47AM -0500, Matt Domsch wrote:
> I have access to disks with native 4KB sectors now too.  Would
> interested parties be willing to share test plans, so we could be sure
> we have coverage wrt correctness: kernel internals, userspace tools like parted,
> fdisk, kpartx, apps using O_DIRECT)?  Benchmarking winds up being an
> NDA activity this early in the game so I don't want the focus of any
> joint work to be benchmarks yet.

Are they SCSI?  I just got round to trying 4k sector sizes in ata_ram
(after adding file backed capability) and found that libata currently
silently ignores the identify bits that report sector size.  I'll work
on fixing that this afternoon if nobody beats me to it.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
