From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Fri, 16 Apr 2010 14:31:07 -0700
Message-ID: <1271453467.4751.24.camel@mulgrave.site>
References: <4BBF6B2F.9060902@gmail.com>
	 <Pine.LNX.4.44L0.1004091504500.1852-100000@iolanthe.rowland.org>
	 <20100409215439.GA4779@xanatos> <4BC2D049.1090606@gmail.com>
	 <20100416182026.GA10023@xanatos>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-hotplug-owner@vger.kernel.org>
In-Reply-To: <20100416182026.GA10023@xanatos>
Sender: linux-hotplug-owner@vger.kernel.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Jonas Schwertfeger <jschwertfeger@gmail.com>, Alan Stern <stern@rowland.harvard.edu>, Dinh.Nguyen@freescale.com, Mark Lord <mlord@pobox.com>, Sergei Shtylyov <sshtylyov@mvista.com>, Kay Sievers <kay.sievers@vrfy.org>, David Zeuthen <david@fubar.dk>, linux-hotplug@vger.kernel.org, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, Lennart Poettering <lennart@poettering.net>, Douglas Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2010-04-16 at 11:20 -0700, Sarah Sharp wrote:
> The drive stalls on the last command, which is a valid ATA command.  Can
> you confirm if your device supports the SCSI ATA pass through
> specification?
> 
> http://www.t10.org/cgi-bin/ac.pl?t=f&f=sat2r09.pdf

Actually, that's not a valid standard ... it's unratified.  I know SCSI
tends to follow leading edge (i.e. unratified) standards, but most SAT
implementations have been following trailing edge ones ... in fact, very
few people have been claiming even SAT (as opposed to SAT-2) compliance,
so they more use it as a guideline.

If you want to read the doc, you have to get it from google using this
search string:

+"SCSI / ATA Translation (SAT)" +"revision 09"

And you'll find that citeseer still has the pdf.

but like I said, most people treat it as advisory not mandatory.

James


