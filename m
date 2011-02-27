From: john smith <whalajam@yahoo.com>
Subject: scsi_host_template.queuecommand() instances
Date: Sun, 27 Feb 2011 11:22:06 -0800 (PST)
Message-ID: <304254.22314.qm@web161906.mail.bf1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web161906.mail.bf1.yahoo.com ([98.139.210.197]:28353 "HELO
	web161906.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751074Ab1B0T2r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Feb 2011 14:28:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I understand that inside LDD's scsi_host_template.queuecommand(), the card->spinlock can be used to protect shared data between concurrent instances of queuecommand and bottom-half/tasklets IO completion code.
For SMP system with PCIE/MSIX enabled interrupts, there can be multiple instances of completion tasklets.
The questions I have are:
 
- can there be multiple instances of queuecommand as well?
- if so, I would assume they are IO commands issued for different targets (controlled by LDD), correct?
Also, if true, these multiple instances must be running on different kernel threads spwaned by the SCSI mid layer, or block layer?

Links to detailed and uptodate Block layer description would be appreciated (the ones I found are either old and superficial),

thanks,
John 


      
