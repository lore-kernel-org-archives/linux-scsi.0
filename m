From: Clay Haapala <chaapala@cisco.com>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Wed, 29 Oct 2003 13:17:43 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <yquj7k2n4zvs.fsf@chaapala-lnx2.cisco.com>
References: <20031027153932.A16679@infradead.org>
	<018b01c39e1f$e013bab0$a0074d0a@apac.cisco.com>
	<20031029134557.A17523@infradead.org> <3F9FF8C7.70909@us.ibm.com>
	<yqujd6cf51cp.fsf@chaapala-lnx2.cisco.com>
	<3FA00E9E.7000704@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.74.5]:51223 "EHLO
	ams-iport-1.cisco.com") by vger.kernel.org with ESMTP
	id S261384AbTJ2TRs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2003 14:17:48 -0500
In-Reply-To: <3FA00E9E.7000704@us.ibm.com> (Mike Christie's message of "Wed,
 29 Oct 2003 11:01:50 -0800")
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <mikenc@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Wed, 29 Oct 2003, Mike Christie outgrape:
> 
>> This may turn out to be a discussion about where this code resides
>> and what code is best to (re)use, not if it is needed.  "Early
>> boot" here is from PXE -- setting up the iSCSI initiator to reach a
>> target at some IP where the rest of the boot (initrd and friends)
>> is.
>>
> 
> Oops. I forgot you guys use iNBP.com. I was thinking of pxelinux.
> 
> Mike
Oh, now I have to find out about pxelinux ... google ... OK. :-)

Yeah, like that only different -- using iSCSI to a target to fetch
blocks rather than TFTP of files from a filestore.
-- 
Clay Haapala (chaapala@cisco.com) Cisco Systems SRBU +1 763-398-1056
   6450 Wedgwood Rd, Suite 130 Maple Grove MN 55311 PGP: C89240AD
      "They're selling independence, Actors in the White House,
       Acid indigestion, Mortage on my life."
         -- from "Ramble Tamble" by CCR 

 "Vote for me if you want to live" -- the Gubernator
