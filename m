From: Clay Haapala <chaapala@cisco.com>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Wed, 29 Oct 2003 12:45:58 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <yqujd6cf51cp.fsf@chaapala-lnx2.cisco.com>
References: <20031027153932.A16679@infradead.org>
	<018b01c39e1f$e013bab0$a0074d0a@apac.cisco.com>
	<20031029134557.A17523@infradead.org> <3F9FF8C7.70909@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-1-in.cisco.com ([171.71.176.70]:54190 "EHLO
	sj-iport-1.cisco.com") by vger.kernel.org with ESMTP
	id S261270AbTJ2SqD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2003 13:46:03 -0500
Received: from chaapala-lnx2.cisco.com (chaapala-lnx2.cisco.com [64.101.211.117])
	by sj-core-1.cisco.com (8.12.9/8.12.6) with ESMTP id h9TIjujP004496
	for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2003 10:45:56 -0800 (PST)
In-Reply-To: <3F9FF8C7.70909@us.ibm.com> (Mike Christie's message of "Wed,
 29 Oct 2003 09:28:39 -0800")
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Wed, 29 Oct 2003, Mike Christie outgrape:
> Hi Surekha,
> 
>>>This is again needed for network boot. The n/w driver and iSCSI
>>>driver are loaded during early boot. Since the n/w interface is not
>>>setup at that time, we need to bring up the interface through this
>>>call in iSCSI driver.
>> That's bogus.  Look at the ip autoconfig code used by rootnfs and
>> reuse that instead of creating such bogus hacks.  A driver has no
>> business dealing with the network configuration.
>>
> 
> Your driver does not even need to mess with that code. Just modify
> your usersapce tools in the linux-iscsi package that run in the
> initrd to do this in userspace.

Mike,

This may turn out to be a discussion about where this code resides and
what code is best to (re)use, not if it is needed.  "Early boot" here
is from PXE -- setting up the iSCSI initiator to reach a target at
some IP where the rest of the boot (initrd and friends) is.

I have not yet looked at the ip autoconfig code that Chris mentions
above, though.  Can't comment on that.
-- 
Clay Haapala (chaapala@cisco.com) Cisco Systems SRBU +1 763-398-1056
   6450 Wedgwood Rd, Suite 130 Maple Grove MN 55311 PGP: C89240AD
      "They're selling independence, Actors in the White House,
       Acid indigestion, Mortage on my life."
         -- from "Ramble Tamble" by CCR 

 "Vote for me if you want to live" -- the Gubernator
