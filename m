From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Unplugging of SBP-2 devices still does not work --- solved
Date: Mon, 01 Aug 2005 01:43:34 +0200
Message-ID: <42ED6226.9000500@s5r6.in-berlin.de>
References: <42E29DF5.5090603@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:28396 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S262066AbVGaXuG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 31 Jul 2005 19:50:06 -0400
In-Reply-To: <42E29DF5.5090603@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

I wrote on 2005-07-23:
> Problem 1) Hot unplugging of SBP-2 hangs ieee1394's nodemgr when *sd_mod*
> was attached to the SBP-2 device. I have seen this problem since RBC
> handling was moved from sbp2 to sd_mod.
> 
> Problem 2) Hot unplugging of SBP-2 hangs ieee1394's nodemgr when *sr_mod*
> was attached to the SBP-2 device. This is a very old problem.

Both is fixed by today's patch for sbp2_remove and sbp2scsi_queuecommand:
http://marc.theaimsgroup.com/?m=112285107522539

A cosmetic glitch remains:
Aug  1 00:46:59 shuttle kernel: Synchronizing SCSI cache for disk sda:
Aug  1 00:46:59 shuttle kernel: FAILED
Aug  1 00:46:59 shuttle kernel:   status = 0, message = 00, host = 1, driver = 00
-- 
Stefan Richter
-=====-=-=-= =--- ----=
http://arcgraph.de/sr/
