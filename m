From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: AIC7xxx on 2.6.18
Date: Sat, 03 Feb 2007 21:03:40 -0600
Message-ID: <1170558221.3860.3.camel@mulgrave.il.steeleye.com>
References: <20070128194620.GA6358@animx.eu.org>
	 <20070128162408.9fffb6de.akpm@osdl.org>
	 <20070203004201.GB25027@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:44331 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751896AbXBDDEG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Feb 2007 22:04:06 -0500
In-Reply-To: <20070203004201.GB25027@animx.eu.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wakko Warner <wakko@animx.eu.org>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org

On Fri, 2007-02-02 at 19:42 -0500, Wakko Warner wrote:
> [   40.154122] ACPI: PCI Interrupt 0000:05:01.1[B] -> GSI 17 (level,
> low) -> IRQ 22
> [   40.158190] scsi4: PCI error Interrupt at seqaddr = 0x1bb
> [   40.158261] scsi4: Signaled a Target Abort

Well, this is the source of the problem.  It means the driver detected
an error in the PCI system.  I'm afraid I don't know what a PCI target
error is, but I think it means something is wrong with the PCI bus in
your system.  There's also a screaming interrupt, because the first 500
interrupts will be ignored before it looks at the bus error register.

James


