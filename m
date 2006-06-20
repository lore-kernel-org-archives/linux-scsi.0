From: David Chernoff <chernoff@astro.cornell.edu>
Subject: megaraid fails to probe SATA 300-8x
Date: Tue, 20 Jun 2006 13:09:20 -0400
Message-ID: <44982BC0.DD31E7AF@astro.cornell.edu>
Reply-To: chernoff@astro.cornell.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from astrosun2.astro.cornell.edu ([132.236.7.5]:41104 "EHLO
	astrosun2.astro.cornell.edu") by vger.kernel.org with ESMTP
	id S1751423AbWFTRJ1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jun 2006 13:09:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Neela.Kolli@engenio.com

Starting with kernel 2.6.14-1.1637 and all subsequent kernels
up through 2.6.16-1.2115 the megaraid module on my x86_64 system
does not probe the LSI MegaRAID SATA 300-8x on boot.

The problem was introduced immediately after kernel 2.6.14-1.1532.

I originally suspected the problem implicated the megaraid
module; I have become aware that even the same module version (megaraid
cmm: 2.20.2.6 and
megaraid 2.20.4.6) that probes and finds the LSI card in 2.6.14-1.1532
does not work later (specifically, 2.6.15-1830).

Thanks for any help in diagnosing what is going on.


