From: Fabien Salvi <fabien@cri74.org>
Subject: Migrating RAID array to a different manufacturer controller
Date: Mon, 17 Feb 2003 18:10:41 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E511791.2060904@cri74.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pc00.cri.cur-archamps.fr (pc00.cri.cur-archamps.fr [10.10.10.11])
	by node01.cur-archamps.fr (Postfix) with ESMTP id 9CDF78AC
	for <linux-scsi@vger.kernel.org>; Mon, 17 Feb 2003 18:10:41 +0100 (CET)
Received: from cri74.org (localhost [127.0.0.1])
	by pc00.cri.cur-archamps.fr (8.9.3/8.9.3) with ESMTP id SAA25504
	for <linux-scsi@vger.kernel.org>; Mon, 17 Feb 2003 18:10:41 +0100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

Here is a question that is maybe a bit off topic.
Sorry for that...

Is it possible to migrate a RAID array from a manufacter controller to 
another ?
Is it depend on the level of RAID ?
I've already be able to read data from RAID 1 because it's simple 
mirroring (with Mylex DAC 960 controller).
But, it may not be the case for all controllers I suppose...

In fact, I have a server or a storage enclosure that use a CMD, 
ICP-Vortex or Mylex controller and I would like to get data from it.

Maybe it's possible with linux software RAID tools ?

What can differentiate from a controller to another ?
Maybe the parity block size ?


Thanks in advance for your help !

B.R.

-- 
Fabien SALVI      Centre de Ressources Informatiques
                   Archamps, France -- http://www.cri74.org
                   PingOO GNU/linux distribution : http://www.pingoo.org

