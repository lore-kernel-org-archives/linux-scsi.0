From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH]: mpt2sas crashes on shutdown
Date: Tue, 27 Dec 2011 13:05:50 -0500 (EST)
Message-ID: <20111227.130550.165386147383560860.davem@davemloft.net>
References: <20111226.145920.1088076837634135764.davem@davemloft.net>
	<4565AEA676113A449269C2F3A549520FAC5B1C55@cosmail03.lsi.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:48454 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662Ab1L0SFy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Dec 2011 13:05:54 -0500
In-Reply-To: <4565AEA676113A449269C2F3A549520FAC5B1C55@cosmail03.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric.Moore@lsi.com
Cc: stable@vger.kernel.org, linux-scsi@vger.kernel.org, Nagalakshmi.Nandigama@lsi.com

From: "Moore, Eric" <Eric.Moore@lsi.com>
Date: Tue, 27 Dec 2011 10:09:28 -0700

> David - The backup and restoring of the MSIX vector capabilities registers across diagnostic reset was only needed for our pre-production cards (A0 parts). It was a workaround for some hardware errata.  This is not needed anymore as there was a fix addressed before those controllers when to production, so I finally removed this workaround in the driver during phase 10 in the LSI in-house drivers, which was about 10 months ago.  Attached is my commit for the in-house drivers.  You should be able to remove the save_msix_table and restore_msix_table routines as I did.

I don't care how it is fixed, I only care that a fix makes it's way into -stable.

You LSI guys seem to ignore the -stable series and submit _ZERO_ bug
fixes for your driver there, leaving it to people like me suffering
from the bugs to submit the fixes for you.

Therefore it is kind of out of place for you to suggest a specific way you want
the bug fixed, because obviously you guys don't care about backporting bug
fixes to -stable in the first place.

With that in mind, why not leave the decision to people who actually
care, have actually tested the fix, and bothered to submit it to -stable?
