From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: sym53c8xx_2 hangs on 53c810 rev 02
Date: Fri, 18 Feb 2005 20:48:40 +0000
Message-ID: <20050218204840.GB29917@parcelfarce.linux.theplanet.co.uk>
References: <41992BE8.22985.49329380@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:56459 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261482AbVBRUsl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Feb 2005 15:48:41 -0500
Content-Disposition: inline
In-Reply-To: <41992BE8.22985.49329380@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Korb <ml@akana.de>
Cc: linux-scsi@vger.kernel.org

On Mon, Nov 15, 2004 at 10:21:28PM +0100, Ingo Korb wrote:
> While trying to run 2.6.9 on my AlphaStation 200, I noticed that 
> sym53c8xx_2 doesn't seem to like the onboard 53c810 rev. 02 (see 
> bootlog below).

Just going through my old bug reports ...

> sym0: <810> rev 0x2 at pci 0000:00:06.0 irq 11
> sym0: No NVRAM, ID 7, Fast-10, SE, parity checking
> sym0: SCSI BUS has been reset.
> scsi0 : sym-2.1.18j
> sym0:0:0: ABORT operation started.
> sym0:0:0: ABORT operation timed-out.
> sym0:0:0: DEVICE RESET operation started.
> sym0:0:0: DEVICE RESET operation timed-out.
> sym0:0:0: BUS RESET operation started.
> sym0:0:0: BUS RESET operation timed-out.
> sym0:0:0: HOST RESET operation started.
> sym0: SCSI BUS has been reset.

To be honest, this looks like the sym2 driver never received any interrupts.
Could you boot with sym53c8xx.debug=0xffff on the command line?  That should
report any interrupts that come in.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
