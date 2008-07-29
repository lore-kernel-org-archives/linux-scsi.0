From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: tools support for non-512 byte sector sizes
Date: Tue, 29 Jul 2008 13:37:25 -0500
Message-ID: <1217356645.6103.48.camel@localhost.localdomain>
References: <488F524F.6020905@redhat.com>
	 <20080729182611.GB24924@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20080729182611.GB24924@parisc-linux.org>
Sender: linux-ide-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Ric Wheeler <rwheeler@redhat.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Jim Meyering <jim@meyering.net>, linux-kernel@vger.kernel.org, Martin Petersen <mkp@mkp.net>, Jeff Garzik <jeff@garzik.org>, Matt Domsch <Matt_Domsch@Dell.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2008-07-29 at 12:26 -0600, Matthew Wilcox wrote:
> On Tue, Jul 29, 2008 at 01:24:31PM -0400, Ric Wheeler wrote:
> > Jim pinged me about the use case for having our tool chain (parted 
> > specifically) support devices with non-512 bytes sectors.
> 
> Matt Domsch spoke with me about this at OLS.  I took that opportunity,
> and I'll take this one, to pimp my ata-ram driver which allows you to
> alter the sector sizse to whatever you want:
> 
> http://git.kernel.org/?p=linux/kernel/git/willy/misc.git;a=shortlog;h=ata-ram
> 
> I'll admit to having not tested it with anything other than 512, but it
> ought to support 4096 byte sectors just fine.  I haven't looked at what
> would be required to support 520-byte sectors.

scsi_debug does exactly the same thing, so it reports anything you tell
it (Martin Petersen actually added this so he could test with 4k
sectors).

The problem, which ata_ram also suffers, is that the tools we most need
to test are the ones for manipulating non volatile characteristics (like
partition tables).  We'd really like the disk contents to survive reboot
for this ...

James


