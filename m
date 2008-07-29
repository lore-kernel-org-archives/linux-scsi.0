From: Jeff Garzik <jeff@garzik.org>
Subject: Re: tools support for non-512 byte sector sizes
Date: Tue, 29 Jul 2008 17:54:03 -0400
Message-ID: <488F917B.2050800@garzik.org>
References: <488F524F.6020905@redhat.com> <20080729182611.GB24924@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20080729182611.GB24924@parisc-linux.org>
Sender: linux-ide-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Ric Wheeler <rwheeler@redhat.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Jim Meyering <jim@meyering.net>, linux-kernel@vger.kernel.org, Martin Petersen <mkp@mkp.net>, Matt Domsch <Matt_Domsch@Dell.com>
List-Id: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Tue, Jul 29, 2008 at 01:24:31PM -0400, Ric Wheeler wrote:
>> Jim pinged me about the use case for having our tool chain (parted 
>> specifically) support devices with non-512 bytes sectors.
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
> 
> Jeff, any interest in merging ata-ram soon?  I've got some users inside
> Intel, and Zab persuaded me to add the multiple port support last night,
> so it's not just useful for me.  I think it's also a nice template to
> have around to show how to write a minimal libata driver.

I'm happy to include ata_ram whenever it is working and you think it's 
ready for inclusion.

	Jeff



