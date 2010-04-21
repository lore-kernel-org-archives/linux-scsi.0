From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Wed, 21 Apr 2010 10:41:01 -0700
Message-ID: <20100421174101.GA6288@xanatos>
References: <Pine.LNX.4.44L0.1004211205560.1728-100000@iolanthe.rowland.org>
 <yq1fx2owzh0.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-hotplug-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1fx2owzh0.fsf@sermon.lab.mkp.net>
Sender: linux-hotplug-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Luben Tuikov <ltuikov@yahoo.com>, Jonas Schwertfeger <jschwertfeger@gmail.com>, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, "<linux-scsi@vger.kernel.org>" <linux-scsi@vger.kernel.org>, Lennart Poettering <lennart@poettering.net>, Douglas Gilbert <dgilbert@interlog.com>, "<Dinh.Nguyen@freescale.com>" <Dinh.Nguyen@freescale.com>, Mark Lord <mlord@pobox.com>, Sergei Shtylyov <sshtylyov@mvista.com>, James Bottomley <James.Bottomley@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, David Zeuthen <david@fubar.dk>, "<linux-hotplug@vger.kernel.org>" <linux-hotplug@vger.kernel.org>, "<linux-usb@vger.kernel.org>" <linux-usb@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 21, 2010 at 12:18:51PM -0400, Martin K. Petersen wrote:
> >>>>> "Alan" == Alan Stern <stern@rowland.harvard.edu> writes:
> 
> I'm guessing Doug is out today because he didn't forward the note
> below.  Just passing the info along...
> 
> 
> >> It is needed by the transport protocol(s).
> 
> Alan> I don't understand; can you explain more fully?  Which transport
> Alan> protocol(s) need to use the Sector Count?  The USB transport
> Alan> protocol doesn't; it encodes the transfer length in a wrapper.
> Alan> The bridge chip should interpret the wrapper instead of looking
> Alan> inside the SAT command.
> 
> Doug posted to the T10 list and here's what Jim Hatfield from Seagate
> responded:
> 
>      For ATA (SATA or PATA), the Count field should NEVER be zero,
>      because neither interface supports zero-length data transfer for
>      any protocol (dma, pio, etc).
> 
>      In ATA, 'N/A' is defined the way it is because there are some
>      ancient implementations for which there are vendor specific
>      differences.

So, if Jim is correct, then this may not be a bug in the Buffalo device?
Or is the phase error in the status of the CSW still an incorrect
response after a stall on what the device thinks is an invalid command?

Sarah Sharp
