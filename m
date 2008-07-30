From: Theodore Tso <tytso@mit.edu>
Subject: Re: tools support for non-512 byte sector sizes
Date: Wed, 30 Jul 2008 14:45:51 -0400
Message-ID: <20080730184551.GB5347@mit.edu>
References: <488F524F.6020905@redhat.com> <20080729182611.GB24924@parisc-linux.org> <1217356645.6103.48.camel@localhost.localdomain> <yq13alsr0g0.fsf@sermon.lab.mkp.net> <20080730135147.GA4513@auslistsprd01.us.dell.com> <87zlnzb8ce.fsf@rho.meyering.net> <20080730172922.GA20191@auslistsprd01.us.dell.com> <20080730181351.GA5347@mit.edu> <4890B2BC.10808@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4890B2BC.10808@redhat.com>
Sender: linux-ide-owner@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>, Jim Meyering <jim@meyering.net>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 30, 2008 at 02:28:12PM -0400, Ric Wheeler wrote:
> If I remember correctly, the MS Vista new alignment for data partitions  
> is on a 0 offset, 1MB aligned boundary. The support for 4096 byte  
> sectors is only for data partitions (not boot).
>
> Array vendors, who consume a fair amount of drives, are most likely more  
> friendly to native 4k drives. The big fear from disk vendors is getting  
> a wave of returns from Best Buy, etc when people go and plug in a new,  
> native 4k drive into an old box....

Or a new box running XP, either via the Dell "upgrade to XP" program,
or from a corporate I/T load[1].  :-)

[1] http://www.theinquirer.net/gb/inquirer/news/2008/06/23/intel-dumps-vista

More to the point for Linux, are *our* partition table programs (i.e.,
fdisk, cfdisk, et. al) fixed with better defaults in upstream, and
what are the upcoming enterprise distributions going to ship with?
Since that's what a large number of Linux customers will end up using
for the next 3-5 years....

						- Ted
