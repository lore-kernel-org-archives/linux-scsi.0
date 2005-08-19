From: Frederic TEMPORELLI <frederic.temporelli@ext.bull.net>
Subject: increase SD_STATS ?
Date: Fri, 19 Aug 2005 10:02:43 +0200
Message-ID: <43059223.4020205@ext.bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:34528 "EHLO
	ecfrec.frec.bull.fr") by vger.kernel.org with ESMTP id S964918AbVHSICt
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Aug 2005 04:02:49 -0400
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id DB7AE19DEFB
	for <linux-scsi@vger.kernel.org>; Fri, 19 Aug 2005 10:02:47 +0200 (CEST)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 09113-06 for <linux-scsi@vger.kernel.org>;
 Fri, 19 Aug 2005 10:02:46 +0200 (CEST)
Received: from ecn002.frec.bull.fr (ecn002.frec.bull.fr [129.183.4.6])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 3DD0019D909
	for <linux-scsi@vger.kernel.org>; Fri, 19 Aug 2005 10:02:46 +0200 (CEST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by openx3.frec.bull.fr (Postfix) with ESMTP id 33C092B0E8
	for <linux-scsi@vger.kernel.org>; Fri, 19 Aug 2005 10:02:43 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,


Due to SD_STATS=256  (/drivers/scsi/sd.c)
there's a limit on the max /dev/sd devices.

Now, we have a large FC fabric, with more than 3500 LUNs...
=> Of course, we have an Oops when an HBA is connected to the fabric
(still sd.c, BUG in function sd_iostats_bump when sd>SD_STATS)

What (bad) side-effects can be expected if we increase SD_STATS (4096 should be 
nice, may be 8192) ?

Best regards.

-- 
Frederic TEMPORELLI
