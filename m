From: Ric Wheeler <rwheeler@redhat.com>
Subject: [LSF/MM TOPIC] linux servers as a storage server - what's missing?
Date: Wed, 21 Dec 2011 10:59:43 -0500
Message-ID: <4EF2026F.2090506@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54351 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752874Ab1LUQBz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Dec 2011 11:01:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


One common thing that I see a lot of these days is an increasing number of 
platforms that are built on our stack as storage servers. Ranging from the 
common linux based storage/NAS devices up to various distributed systems.  
Almost all of them use our common stack - software RAID, LVM, XFS/ext4 and samba.

At last year's SNIA developers conference, it was clear that Microsoft is 
putting a lot of effort into enhancing windows 8 server as a storage server with 
both support for a pNFS server and of course SMB. I think that linux (+samba) is 
ahead of the windows based storage appliances today, but they are putting 
together a very aggressive list of features.

I think that it would be useful and interesting to take a slot at this year's 
LSF to see how we are doing in this space. How large do we need to scale for an 
appliance?  What kind of work is needed (support for the copy offload system 
call? better support for out of band notifications like those used in "thinly 
provisioned" SCSI devices? management API's? Ease of use CLI work? SMB2.2 support?).

The goal would be to see what technical gaps we have that need more active 
development in, not just a wish list :)

Ric

