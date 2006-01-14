From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: Qlogic 2460 Query
Date: Sat, 14 Jan 2006 06:32:36 -0800
Message-ID: <20060114143236.GD13373@andrew-vasquezs-powerbook-g4-15.local>
References: <Pine.LNX.4.58.0601101930080.27390@moon.cmie.ernet.in> <20060114013640.GE7411@andrew-vasquezs-powerbook-g4-15.local> <Pine.LNX.4.58.0601141836580.23973@moon.cmie.ernet.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:8563 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S1751739AbWANOci (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 Jan 2006 09:32:38 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0601141836580.23973@moon.cmie.ernet.in>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nohez <nohez@cmie.com>
Cc: linux-scsi@vger.kernel.org

On Sat, 14 Jan 2006, Nohez wrote:

> I applied the patch. Following is the output from /var/log/messages
> after recompiling and reloading the driver.
> 
> -------------------------------------------------------------------
> Relevant output from /var/log/messages
> -------------------------------------------------------------------
> kernel: QLogic Fibre Channel HBA Driver
> kernel: qla2400 0000:02:02.0: Found an ISP2422, irq 11, iobase 0xd1094000
> kernel: qla2400 0000:02:02.0: Configuring PCI space...
> kernel: qla2400 0000:02:02.0: Configure NVRAM parameters...
> kernel: qla2400 0000:02:02.0: Verifying loaded RISC code...
> kernel: scsi(3): **** Load RISC code ****
> kernel: qla2x00_mailbox_command(3): **** FAILED. mbx0=4001, mbx1=0, mbx2=568, cmd=9 ****
> kernel: qla2x00_load_ram(3): failed. rval=102 mb[0]=4001.
> kernel: scsi(3): [ERROR] Failed to load segment 0 of firmware
> kernel: qla2400 0000:02:02.0: [ERROR] Failed to load segment 0 of firmware

Hmm, that's interesting.  Your trying to load RISC ram with the wrong
mailbox command -- 0x09 when it should be 0x0b.

Could you send me your .config file.  I'm also still not clear on
which driver variant suse is using in this kernel.

Thanks,
Andrew Vasquez
