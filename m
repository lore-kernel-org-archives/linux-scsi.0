From: AJ Lewis <alewis@redhat.com>
Subject: Re: [ANNOUNCE] iSCSI Initiator Core Stack v1.6.1.20
Date: 24 Feb 2005 14:51:03 -0600
Message-ID: <x05mzttr8aw.fsf@null.msp.redhat.com>
References: <1109187935.15154.164.camel@haakon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from main.gmane.org ([80.91.229.2]:936 "EHLO ciao.gmane.org")
	by vger.kernel.org with ESMTP id S262479AbVBXVEX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Feb 2005 16:04:23 -0500
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1D4Q5d-0002II-Ko
	for linux-scsi@vger.kernel.org; Thu, 24 Feb 2005 22:00:05 +0100
Received: from nat-pool-msp.redhat.com ([67.131.125.100])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2005 22:00:05 +0100
Received: from alewis by nat-pool-msp.redhat.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2005 22:00:05 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

"Nicholas A. Bellinger" <nick@pyxtechnologies.com> writes:

> The following is the first public release of the PyX Technologies iSCSI
> Initiator Core Stack v1.6.1.20 for Linux 2.6.11-rc4.  This is a full
> featured iSCSI Initiator stack that is capable of mulitplexing coast to
> coast across multiple independant backbone providers using various
> network transports _TODAY_.  This is the first release of the core stack
> and assoicated userspace tools, the accompanying authentication daemon
> will be released shortly.

Very cool - glad you're releasing this. I've gotten this setup and
running, but I can't seem to talk to my iscsi target.  The initiator
detects it, but it can't recognize the type:

iCHANNEL[0] - No defined iSCSI Authentication Methods, skipping SecurityNegotiation phase.
iCHANNEL[0] - iSCSI login successful on CID: 0 to 192.168.44.19:3260,2
iCHANNEL[0] - Incremented iSCSI connection count to 1 to node: iqn.1992-08.com.netapp:sn.33615311
iCHANNEL[0] - Established iSCSI session to node: iqn.1992-08.com.netapp:sn.33615311
iSCSI Core Stack[1] - Incremented number of active iSCSI sessions to 1.
scsi: unknown device type 31
  Vendor: NETAPP    Model: LUN               Rev: 0.2 
  Type:   Unknown                            ANSI SCSI revision: 04

Any ideas on why this wouldn't be working?  Is there a configuration
step I'm missing?

Also, are you planning on updating the docs for the user tools at all?
There are several steps missing in the current README, and the man
page lists some parameters incorrectly and misses other entirely.

I'm looking forward to getting this working.
-- 
AJ Lewis                                   Voice:  612-638-0500
Red Hat Inc.                               E-Mail: alewis@redhat.com
720 Washington Ave. SE, Suite 200
Minneapolis, MN 55414
   
Current GPG fingerprint = D9F8 EDCE 4242 855F A03D  9B63 F50C 54A8 578C 8715
Grab the key at: http://people.redhat.com/alewis/gpg.html or one of the
many keyservers out there...

