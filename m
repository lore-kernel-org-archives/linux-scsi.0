From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Sym2 driver timeouts on powerstacks
Date: Fri, 7 Jan 2005 14:48:22 +0000
Message-ID: <20050107144822.GS27371@parcelfarce.linux.theplanet.co.uk>
References: <200501041354.50294.marvin24@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:5770 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261442AbVAGOsY
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Jan 2005 09:48:24 -0500
Content-Disposition: inline
In-Reply-To: <200501041354.50294.marvin24@gmx.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Marc Dietrich <marvin24@gmx.de>
Cc: linux-scsi@vger.kernel.org

On Tue, Jan 04, 2005 at 01:54:49PM +0100, Marc Dietrich wrote:
> I'm trying to get a 2.6.10 kernel to run on a Motorola Powerstack II (Utah). 
> This is a PReP (powerpc) machine.

I just had a thought:

sym0: SCSI BUS has been reset.
scsi0 : sym-2.1.18m
elevator: using anticipatory as default io scheduler
sym0:0:0:ccb @c7d9ac00 using tag 256.
sym0: queuepos=2.  
sym0:0:0: ABORT operation started.
sym0:0:0: ABORT operation timed-out.
sym0:0:0: DEVICE RESET operation started.
sym0:0:0: DEVICE RESET operation timed-out.
sym0:0:0: BUS RESET operation started.
sym0:0:0: BUS RESET operation timed-out.
sym0:0:0: HOST RESET operation started.
sym0:0:0:ccb @c7d9ac00 freeing tag 256.
sym0: SCSI BUS has been reset.

This is sym2's typical behaviour when it receives no interrupts.
I think if you were to NFS-root this box, you'd see equal problems with
the network driver.  Try asking on the powerpc lists, see if there's a
known interrupt routing problem.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
