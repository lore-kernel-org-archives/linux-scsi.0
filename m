From: Shanker Balan <shanu@exocore.com>
Subject: Re: aic7xxx: SCSI Bus Reset
Date: Thu, 26 Dec 2002 12:59:09 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021226072909.GC727@exocore.com>
References: <2251835408.1040754900@aslan.scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from godzilla.exocore.com (PPP-219-65-142-208.bng.vsnl.net.in [219.65.142.208])
	(authenticated)
	by premium.exocore.com (8.11.6/8.11.6) with ESMTP id gBQ7Tep29664
	for <linux-scsi@vger.kernel.org>; Thu, 26 Dec 2002 12:59:44 +0530
Content-Disposition: inline
In-Reply-To: <2251835408.1040754900@aslan.scsiguy.com>
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI <linux-scsi@vger.kernel.org>

Hello:

Justin T. Gibbs wrote,
> It is hard to say, from the information you have provided, if your
> problem is similar or different from Shanker's.  Can you provide drive
> model numbers and firmware?  A dmesg from your system (you can send it
> privately) should have this information.  It would also be useful to
> see the actual driver messages that are displayed when the failure
> occurs.

Is "Tagged Command Queuing" (TCQ) the same as Queued IO? Shall I try
disabling TCQ passing aic7xxx=tag_info:{xx} as a boot time arg so that I
can narrow down the problem to the firmware?

-- Shanu

-- 
It's a good thing we don't get all the government we pay for.
