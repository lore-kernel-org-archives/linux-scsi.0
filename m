From: Giridhar Malavali <giridhar.malavali@qlogic.com>
Subject: qla2xxx: Conditionally disable automatic queue full tracking
Date: Wed, 23 Sep 2009 16:59:40 -0700
Message-ID: <5355D915-9CAE-41CD-846B-F816FE914E1B@qlogic.com>
Mime-Version: 1.0 (Apple Message framework v912)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:31853 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbZIWX7h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Sep 2009 19:59:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mdr@sgi.com, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, LinuxSCSI <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, vasu.dev@intel.com

Hi Michael/James,

	Patches were submitted to move queue ramp up/down code recently to  
scsi mid layer. With this change, I don't see a need for a module  
parameter to disable queuefull tracking  in qla2xxx driver. Andrew,  
mentioned that this got introduced to avoid wobbling behavior on the  
wire due to queue depth modifications. Just wanted to check whether  
the same need to be done in scsi mid layer too.


Thanks,
Giridhar.M.B

