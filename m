From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: Poisoning of Linux initiators on SCST reboot.
Date: Mon, 28 Jul 2008 18:34:14 -0700
Message-ID: <20080729013414.GA38093@n8027av35btxc1.qlogic.org>
References: <andrew.vasquez@qlogic.com> <200807282040.m6SKeY9Q013406@wind.enjellic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:46551 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbYG2BeR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Jul 2008 21:34:17 -0400
Content-Disposition: inline
In-Reply-To: <200807282040.m6SKeY9Q013406@wind.enjellic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: greg@enjellic.com
Cc: scst-devel@lists.sourceforge.net, linux-driver@qlogic.com, linux-scsi@vger.kernel.org, stf_xl@wp.pl, vst@vlnb.net

On Mon, 28 Jul 2008, greg@enjellic.com wrote:

....
> SCSI host 4 is being used to access the target which is undergoing the
> reboot test.  PWWN of the target is 210000e08b8665b5.
> 
> ---------------------------------------------------------------------------
> Jul 28 14:39:00 init-test syslogd 1.4.1: restart.
> Jul 28 14:40:01 init-test crond[4312]: (root) CMD (/usr/lib/sa/sa1 1 1)
> Jul 28 14:40:49 init-test kernel: QLogic Fibre Channel HBA Driver: 8.02.01-k4-debug
> Jul 28 14:40:49 init-test kernel: ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 16 (level, low) -> IRQ 16
> Jul 28 14:40:49 init-test kernel: qla2xxx 0000:04:00.0: Found an ISP2432, irq 16, iobase 0xf8858000
...

These logs are good, I don't have a (formal) fix yet, but I believe
we've reproduced this locally based on your detailed description and
logs...  I hope to have some more details tomorrow...

Thanks,
Andrew Vasquez
