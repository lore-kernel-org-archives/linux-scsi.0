From: Daniel Patton <djp101@ecs.soton.ac.uk>
Subject: Newbie: multiple initiator contention resolution?
Date: Thu, 01 Apr 2004 19:48:23 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <406C63F7.3060009@ecs.soton.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta3.sucs.soton.ac.uk ([152.78.128.142]:62946 "EHLO
	mta3.sucs.soton.ac.uk") by vger.kernel.org with ESMTP
	id S263040AbUDASte (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Apr 2004 13:49:34 -0500
Received: from ecs.soton.ac.uk (du-036-0174.claranet.co.uk [212.126.131.174] (may be forged))
	(authenticated bits=0)
	by mta3.sucs.soton.ac.uk (8.12.10/8.12.10) with ESMTP id i31Imcme023974
	for <linux-scsi@vger.kernel.org>; Thu, 1 Apr 2004 19:48:52 +0100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello all,

I'm an undergraduate at a UK university, and I'm very much a newbie to 
kernel development, so my apologies in advance if my questions sound 
daft or have been answered before, etc.

I'm doing a project on something which involves writing a LLD for a 
"fake" disk, similar to scsi_debug.  However, the LLD may loaded on 
multiple hosts, and they all see the same fake disk.  Does the sd driver 
have any kind of built-in contention resolution mechanism for such 
multiple initiator setups?  That is, if I mount a partition on my fake 
disk simultaneously on more than one host, how do I stop the filesystem 
from getting corrupted?

Many thanks in advance.

Dan Patton
djp101@ecs.soton.ac.uk

