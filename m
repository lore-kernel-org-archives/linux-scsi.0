From: Dan Christian <dac@proofpoint.com>
Subject: Megamon doesnt work under Linux-2.6.5
Date: Tue, 18 May 2004 18:15:51 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40AAB547.9020609@proofpoint.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.proofpoint.com ([207.111.236.2]:12522 "EHLO
	mx1.proofpoint.com") by vger.kernel.org with ESMTP id S263763AbUESBQB
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 May 2004 21:16:01 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-poweredge@dell.com, linux-scsi@vger.kernel.org

I have a Dell PowerEdge-1750 with a PERC 4/Di (AMI Megaraid).  One of my 
drives started to fail (RAID-1), but MegaServ/Megamon didn't report any 
errors.  I pulled the drive and re-inserted it.  The system 
automatically started a re-sync, but Megamon reported nothing (it's 
usually obnoxiously verbose).

This used to work under 2.6.3-1.110.  Does anyone know why it no longer 
works under 2.6.5-1.327?

Thanks,
-Dan

