From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: RE: SCSI regression: sym53c8xxx_2 (2.6test11 vs. 2.6final)
Date: Fri, 19 Dec 2003 09:07:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <03Dec19.090744est.332228@cyborg.cybernetics.com>
References: <200312190923.57405.tom@qwws.net>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host02.cybernetics.com ([206.246.200.18]:517 "EHLO
	cybernetics.com") by vger.kernel.org with ESMTP id S263158AbTLSOHt
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Dec 2003 09:07:49 -0500
In-Reply-To: <200312190923.57405.tom@qwws.net>
List-Id: linux-scsi@vger.kernel.org
To: tom@qwws.net, linux-scsi@vger.kernel.org

> Booting 2.6.0 final results in the following messages:
>
> [...]
> sym0: <895> rev 0x1 at pci 0000:02:0a.0 irq 22
> sym0: Tekram NVRAM, ID 7, Fast-40, LVD, parity checking
> sym0: SCSI BUS has been reset.
> scsi0: sym-2.1.18b
> sym0:0:0: ABORT operation started.
> sym0:0:0: ABORT oberation timed-out.
> sym0:0:0: DEVICE RESET operation started.
> sym0:0:0: DEVICE RESET operation timed-out.
> sym0:0:0: BUS RESET operation started.
> sym0:0:0: BUS RESET operation timed-out.
> sym0:0:0: HOST RESET operation started.
> sym0: SCSI BUS has been reset.

I've seen this under 2.4.x when the machine is not processing interrupts
correctly.  I know nothing of 2.6, but it's a good bet that there is
something that is preventing the SCSI interrupt from being processed.
Under 2.4 you can verify this by checking the interrupt count from
/proc/interrupts.  Under 2.4, I would say to try booting with "noapic".
I think 2.6 has different boot options (I remember seeing something
about ACPI and interrupts).  Maybe someone else can help out here.

Anthony J. Battersby
Cybernetics

