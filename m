From: Rabeeh Khoury <rabeeh@galileo.co.il>
Subject: Hot plugging a disk in runtime
Date: Mon, 20 May 2002 13:19:53 +0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3CE8CDC9.7070200@galileo.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from galileo.co.il (linux2.galileo.co.il [10.2.40.2])
	by galileo.co.il (8.8.5/8.8.5) with ESMTP id NAA26397
	for <linux-scsi@vger.kernel.org>; Mon, 20 May 2002 13:26:34 +0200 (GMT-2)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Hi list,

I have few questions withregards to hot-plugging disk into a running 
system -

1.. How is it possible to signal SCSI mid-layer (or other layers) of a 
presence of a newly hot-plugged disk ?

2.. Can an adapter's device driver trigger SCSI subsystem to scan 
channels for new LUNs / Targets ?

3.. Is this can be handled in a kernel level ? is there a user space 
application that can be triggered to start scanning adapters (obviously 
through SCSI subsystem) and registering new LUNs / Targets etc... ?

4.. How does SCSI API allow insertion of a new disk ?

5.. Is there a generic way of hot-plugging disks ?

Thank you alot,
Rabeeh


