From: "philippe.aubry3@free.fr" <philippe.aubry3@free.fr>
Subject: Failover problem with HP HSV 110 storage array system
Date: Tue, 20 Apr 2004 23:50:52 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40859B3C.6040100@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-102-tuesday.nerim.net ([62.4.16.102]:18451 "EHLO
	kraid.nerim.net") by vger.kernel.org with ESMTP id S264518AbUDTWvM
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Apr 2004 18:51:12 -0400
Received: from free.fr (philippeaubry.net1.nerim.net [62.212.101.203])
	by kraid.nerim.net (Postfix) with ESMTP id CF60841A73
	for <linux-scsi@vger.kernel.org>; Wed, 21 Apr 2004 00:51:09 +0200 (CEST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have a problem with the failover on a HP HSV110 storage array system.

The driver version is 60660 from ftp qlogic, the kernel is a 2.4.20 and 
i have 2 fabrics ( switches ) and the 2 HBA are connected on each switch.
The storage array system is an hsv110 with 2 ctrls.
I have two path available for each hba.
The driver was compiled with MPIO enable and the failover type is 5  	 
( #define FO_NOTIFY_TYPE_SPINUP                 5 ) spine up ( scsi_cmd 
  start ) because for changing port when a failure occur the failover 
driver must perform a scsi start on the second hba to force the unit to 
move on the next available port on which the second hba is connected.



During test i unplug the fiber cable on the adapter and in the same time 
i make a tar and i copy files to the disk, the failover process seems to 
be ok and the unit goes to the other ctrl port no IO error occur but 
when i verify the tar i have some differences ( size ) and some files 
are incomplete, the copy seems to be ok, but if i compare the md5sum 
sometimes i have different md5sum.
I have testing failover and failback the problem occur during the 
failover and failback.

Do you have any idea for this problem ?
I think a problem during the suspend lun or qla2x00_restart_queues but 
i'm not sure.
For this time i continue test and i hope to undrestand this.

I thank in advance for your help.

Best regards
Philippe Aubry
philippe.aubry3@free.fr

