From: kbass@kenbass.com
Subject: 2.6 tape device i/o error
Date: Thu, 10 Jun 2004 18:25:05 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1048.65.172.177.78.1086906305.squirrel@65.172.177.78>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vroc.org ([216.127.139.4]:60166 "EHLO nomad.vroc.org")
	by vger.kernel.org with ESMTP id S263147AbUFJWZF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jun 2004 18:25:05 -0400
Received: from nomad.vroc.org (localhost.localdomain [127.0.0.1])
	by nomad.vroc.org (8.11.6/8.11.6) with ESMTP id i5AMP5700662
	for <linux-scsi@vger.kernel.org>; Thu, 10 Jun 2004 18:25:05 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I'm new to the 2.6 kernel. I've got an application which ran fine on 2.4
and isn't working on a newer system. The problem is there are MANY changes
in the hardware. The old system was simple scsi under 2.4 adaptec. The new
system uses qlogic FCS 2342 HBA adapters and SCSI->FCS convertors for the
tape drives.

I'm trying to narrow the problem.

Under 2.4 I have code the does:
fd = open("/dev/st0", RDONLY)
This always returns success.

Under this new 2.6.4 (SMP) (plus alot of other changes) this same device
open hangs for 1-2 minutes and returns I/O error IF THERE IS NO TAPE in
the drive. If a tape is present, no problem.

I cannot image this is by design. I'm pretty sure you should be able to
open a device with no tape inserted in order to issue ioctl commands.
(Even though I primarily use /dev/sg).

First can you confirm this isn't a change between 2.4 and 2.6. Second, any
ideas on where to look?


