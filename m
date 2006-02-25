From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: [PATCH] sata_promise: Port enumeration order - SATA 150 TX4,
 SATA 300 TX4
Date: Sat, 25 Feb 2006 17:59:02 +1100
Message-ID: <44000036.7070403@eyal.emu.id.au>
References: <43FFAE3D.7010002@physics.harvard.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932419AbWBYG7R@vger.kernel.org>
In-Reply-To: <43FFAE3D.7010002@physics.harvard.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Kupcevic <milan@physics.harvard.edu>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, trivial@rustcorp.com.au, torvalds@osdl.org
List-Id: linux-scsi@vger.kernel.org

Milan Kupcevic wrote:
> From: Milan Kupcevic <milan@physics.harvard.edu>
> 
> Fix Promise SATAII 150 TX4 (PDC40518) and Promise SATA 300 TX4
> (PDC40718-GP) wrong port enumeration order that makes it (nearly)
> impossible to deal with boot problems using two or more drives.
> 
> Signed-off-by: Milan Kupcevic <milan@physics.harvard.edu>
> ---
> 
> The current kernel driver assumes:
> 
> port 1 - scsi3
> port 2 - scsi1
> port 3 - scsi0
> port 4 - scsi2

I totally agree with the fact that the Linux driver gets the ports wrong
when compared to the BIOS, Windows and surely contradicts the port
numbers printed on the board. I doubt we all got samples on the one
bad batch...

It *is* a real problem and if the solution is correct then I support it.

Maybe we need a quick feedback from current users: do you guys find
that the ports are detected as they are labelled (white silk screen)
on the board or do they show up out of order (as listed above by
Milan)?

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au) <http://samba.org/eyal/>
	attach .zip as .dat
