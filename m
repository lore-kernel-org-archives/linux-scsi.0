From: Rock Gordon <rockgordon@yahoo.com>
Subject: WWN on FC LUN targets
Date: Tue, 27 Jul 2004 13:55:11 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040727205512.24414.qmail@web41403.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web41403.mail.yahoo.com ([66.218.93.69]:15246 "HELO
	web41403.mail.yahoo.com") by vger.kernel.org with SMTP
	id S266646AbUG0UzM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jul 2004 16:55:12 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I am looking at ways to find out particular WWN (world
wide names) for SCSI target LUNs connected to HBAs or
FC switches through either of the four modes available
(P2P, Fabric, AL and Fabric-AL)

Also, is there a programming interface to do this
across all available hardware? If that's not possible,
then other solutions are most welcome.

I want to be able to convert particular WWNs into
local major/minor number combination for my datacenter
SAN so that I can mount particular LUNs from any
server without worrying about changes in the device
naming conventions.

PS: can devfs solve this problem across a deployment
of 128-port FC switche connected to about 50 storage
LUNs (all FC-capable P2P linked RAID5 storage units)?
(please note that hotplug and unplug activity goes on
happening over the remaining nodes)

PS1: Please CC me since I'm not on the list (I wonder
why :) )

Thanks and regards,
Rocky


	
		
__________________________________
Do you Yahoo!?
New and Improved Yahoo! Mail - 100MB free storage!
http://promotions.yahoo.com/new_mail 
