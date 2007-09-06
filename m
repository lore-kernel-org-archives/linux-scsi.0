From: Louis-Michel Gelinas <lgelinas@coradiant.com>
Subject: adding lsi MegaRaid SAS 8208ELP support to fusion
Date: Thu, 06 Sep 2007 14:39:55 -0400
Message-ID: <1189103995.6180.56.camel@lgelinas>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sryulwis0comx01.coradiant.com ([199.84.5.210]:45408 "EHLO
	sryulwis0cofw01.coradiant.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752096AbXIFTkf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Sep 2007 15:40:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

After messing around with various kernels and drivers, I finnaly got
this adaptor to work by changing the define 
MPI_MANUFACTPAGE_DEVID_SAS1068E to (0x0059) from (0x0058) in 

drivers/message/fusion/lsi/mpi_cnfg.h:553

I understand this is not the preferred method to say the least. However,
it is the only way I could this adaptor running, also my tests show it
to be stable...

Should I submit a proper patch? Shouldn't this card use the megaraid_sas
driver ?!

Please indicate against which git url I should base my patch. 

I am using 2.6.21.3 but I believe this change can be applied to any
kernel/git. 

thanks
lmg  





