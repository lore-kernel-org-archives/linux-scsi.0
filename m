From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: tools support for non-512 byte sector sizes
Date: Tue, 29 Jul 2008 12:42:43 -0600
Message-ID: <20080729184243.GC24924@parisc-linux.org>
References: <488F524F.6020905@redhat.com> <20080729182611.GB24924@parisc-linux.org> <1217356645.6103.48.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758453AbYG2Sm7@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1217356645.6103.48.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Jim Meyering <jim@meyering.net>, linux-kernel@vger.kernel.org, Martin Petersen <mkp@mkp.net>, Jeff Garzik <jeff@garzik.org>, Matt Domsch <Matt_Domsch@Dell.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 29, 2008 at 01:37:25PM -0500, James Bottomley wrote:
> scsi_debug does exactly the same thing, so it reports anything you tell
> it (Martin Petersen actually added this so he could test with 4k
> sectors).
> 
> The problem, which ata_ram also suffers, is that the tools we most need
> to test are the ones for manipulating non volatile characteristics (like
> partition tables).  We'd really like the disk contents to survive reboot
> for this ...

Ummm... _reboot_, or _module unload/reload_?  I could certainly include
an option to populate the ramdisc from a file.  Is the ioctl to re-read
the partition table not enough?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
