From: Thomas Tonino <ttonino@corp.home.nl>
Subject: QLA2200 driver
Date: Thu, 25 Apr 2002 13:34:56 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3CC7E9E0.5050107@corp.home.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from svr-mail2.corp.home.nl (svr-mail2.corp.home.nl [212.120.65.165])
	by mx1-corp.corp.nl.home.com (8.9.3/8.9.3) with ESMTP id NAA27221
	for <linux-scsi@vger.kernel.org>; Thu, 25 Apr 2002 13:37:20 +0200 (MET DST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

We're setting up a server with a 14 Seagate Cheetah fibre JBOD attached 
to a single QLA2200 controller.

The Qlogic fibre driver in 2.4.18 crashes very quickly in this setup, 
with the message "qlogicfc0 : no handle slots, this should not happen". 
This crash happens after writing less than 100GB of data to the JBODs.

I've seen that message before with an older drive and kernel (around 
2.4.5?) version. At the time, I observed the same problem while  syncing 
a software raid5.

I found Feral's GPL'd driver (available at ftp://ftp.feral.com/pub/isp/) 
to work correctly so far (~ 1 TB).

Is there a reason why Feral's driver is not in the kernel? Having a 
driver that is so non-functional is really bad, IMO.

Who is using the in-kernel driver without problems? Could a connection 
be made between the problem and, say, the number of drives, or the 
achieved throughput?


Thomas
