From: Ingo Korb <nospam@akana.de>
Subject: Re: sym53c8xx_2 hangs on 53c810 rev 02
Date: Sun, 20 Feb 2005 20:09:01 +0100
Message-ID: <uekfbm4ky.fsf@dragon.akana.de>
References: <41992BE8.22985.49329380@localhost>
	<20050218204840.GB29917@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from snowcat.de ([213.146.167.7]:33284 "EHLO snowcat.de")
	by vger.kernel.org with ESMTP id S261738AbVBTTJU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Feb 2005 14:09:20 -0500
In-Reply-To: <20050218204840.GB29917@parcelfarce.linux.theplanet.co.uk> (Matthew
 Wilcox's message of "Fri, 18 Feb 2005 20:48:40 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Matthew Wilcox <matthew@wil.cx> writes:

> To be honest, this looks like the sym2 driver never received any interrupts.

I guess so - I'm not sure why I reported problems with the 2.4 version
of the driver, when I just retested it with 2.4.29 everything was
working fine.

> Could you boot with sym53c8xx.debug=0xffff on the command line?  That should
> report any interrupts that come in.

2.6.10, just the part after the hexdumps:

=== Cut ===
new BADLUNTBL [ 256] @fffffc0005ea5200.
sym0: SCSI BUS has been reset.
scsi0 : sym-2.1.18m
sym0:0:0:ccb @fffffc0005ea5800 using tag 256.
sym0: queuepos=2.
sym0:0:0: ABORT operation started.
sym0:0:0: ABORT operation timed-out.
sym0:0:0: DEVICE RESET operation started.
sym0:0:0: DEVICE RESET operation timed-out.
sym0:0:0: BUS RESET operation started.
sym0:0:0: BUS RESET operation timed-out.
sym0:0:0: HOST RESET operation started.
sym0:0:0:ccb @fffffc0005ea5800 freeing tag 256.
sym0: SCSI BUS has been reset.
=== Cut ===

-ik

