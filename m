From: Josip Rodin <joy@entuzijast.net>
Subject: Re: kernel 2.6.26.3 qla2xxx oopsing on Fire 280R
Date: Tue, 9 Sep 2008 01:42:47 +0200
Message-ID: <20080908234246.GA20274@orion.carnet.hr>
References: <20080908211331.GC22598@plap4-2.qlogic.org> <20080908.142351.00296600.davem@davemloft.net> <20080908214932.GF22598@plap4-2.qlogic.org> <20080908.160820.20152853.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <sparclinux-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080908.160820.20152853.davem@davemloft.net>
Sender: sparclinux-owner@vger.kernel.org
To: sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Sep 08, 2008 at 04:08:20PM -0700, David Miller wrote:
> Note that in Josip's crash log, we don't even see the
> 
> 	qla_printk(KERN_INFO, ha, "\n"
> 	    " QLogic Fibre Channel HBA Driver: %s\n"
> 	    "  QLogic %s - %s\n"
> 	    "  ISP%04X: %s @ %s hdma%c, host#=%ld, fw=%s\n",
>  ...
> 
> message yet.
> 
> Which means that the crash occurs between qla2x00_request_irqs()
> and printing that message.

I should probably mention that the same message actually did appear some
time later, but it seemed inconsequential because there was no /dev/sda to
boot from, and the machine eventually fell through to busybox shell where
it sat useless.

FWIW here's the remainder of the output:

qla2xxx 0001:00:04.0: QLogic Fibre Channel HBA Driver: 8.02.01-k4
  QLogic QLA22xx - 
  ISP2200: PCI (66 MHz) @ 0001:00:04.0 hdma-, host#=1, fw=2.02.08 TP
ohci_hcd 0000:00:05.3: OHCI Host Controller
ohci_hcd 0000:00:05.3: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:05.3: irq 13, io mem 0x7fe01000000
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected

Then the initrd tries to mount sda1 and fails. Again, apologies if I screwed
something up while cleaning up the endless escape sequences.

-- 
     2. That which causes joy or happiness.
