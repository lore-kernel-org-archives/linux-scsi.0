From: Matthias Andree <ma@dt.e-technik.uni-dortmund.de>
Subject: Re: SCSI regression: sym53c8xxx_2 (2.6test11 vs. 2.6final)
Date: Mon, 22 Dec 2003 02:27:03 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <m3y8t5r6ag.fsf@merlin.emma.line.org>
References: <200312190923.57405.tom@qwws.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from krusty.dt.E-Technik.Uni-Dortmund.DE ([129.217.163.1]:23483 "EHLO
	mail.dt.e-technik.uni-dortmund.de") by vger.kernel.org with ESMTP
	id S264289AbTLVB1H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 21 Dec 2003 20:27:07 -0500
Received: from m2a2.dyndns.org (krusty.dt.e-technik.uni-dortmund.de [129.217.163.1])
	by mail.dt.e-technik.uni-dortmund.de (Postfix) with ESMTP id 96F3D174ED
	for <linux-scsi@vger.kernel.org>; Mon, 22 Dec 2003 02:27:05 +0100 (CET)
In-Reply-To: <200312190923.57405.tom@qwws.net> (Tom Winkler's message of
 "Fri, 19 Dec 2003 09:23:57 +0100")
List-Id: linux-scsi@vger.kernel.org
To: tom@qwws.net
Cc: linux-scsi@vger.kernel.org

Tom Winkler writes:

> First of all: I'm not subscribed to the list so please cc me on replies.

[x] done

> I wanted to report a problem concerning 2.6.0 final with my Tekram DC390U2W
> SCSI controller using the sym53c8xx_2 driver. The same machine was running
> without problems with 2.6test11 and the exactly same .config file.
>
> Booting 2.6.0 final results in the following messages:
>
> [...]
> sym0: <895> rev 0x1 at pci 0000:02:0a.0 irq 22
> sym0: Tekram NVRAM, ID 7, Fast-40, LVD, parity checking
> sym0: SCSI BUS has been reset.
> scsi0: sym-2.1.18b
> sym0:0:0: ABORT operation started.
> sym0:0:0: ABORT oberation timed-out.

FWIW, my Symbios 53C875 based Tekram DC-390F is fine with that driver
with Linux 2.6.0 test11 and final, and AFAICS, the driver hasn't changed
between these versions.

Does running "make clean" or saving the .config and "make distclean"
before the build of 2.6.0 final help?

-- 
Matthias Andree

Encrypt your mail: my GnuPG key ID is 0x052E7D95
