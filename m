From: Jeff Garzik <jgarzik@pobox.com>
Subject: requeuing a Scsi_Cmnd?
Date: Sun, 11 May 2003 16:25:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EBEB1D5.3040300@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:53723 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261262AbTEKUNT
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 11 May 2003 16:13:19 -0400
Received: from rdu26-227-011.nc.rr.com ([66.26.227.11] helo=pobox.com)
	by www.linux.org.uk with esmtp (Exim 4.14)
	id 19ExOT-0001x4-E9
	for linux-scsi@vger.kernel.org; Sun, 11 May 2003 21:26:01 +0100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This question applies to 2.4 as well as 2.5 (I believe the strategies 
are different for the two?)


Suppose I am passed several Scsi_Cmnd structures via ->queuecommand. 
TCQ depth is >1.  An event causes the entire queue to be aborted, but I 
know that the majority of the queue was actually ok.  So, my LLD would 
need to requeue and resend most of the recently-aborted Scsi_Cmnds.

How do I tell the SCSI layer to requeue and resend a Scsi_Cmnd [almost] 
immediately?

Thanks,

	Jeff



