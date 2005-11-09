From: Aldo Gavioli <aldo.gavioli@netstorage.it>
Subject: Block size 8192
Date: Wed, 09 Nov 2005 11:31:57 +0100
Message-ID: <4371D01D.5090404@netstorage.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpout11.attiva.biz ([85.37.16.13]:6480 "EHLO
	smtpout11.attiva.biz") by vger.kernel.org with ESMTP
	id S1030477AbVKIKcc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Nov 2005 05:32:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello All.
I'm deciding to  port  our application on kernel 2.6 but we have problem 
in inserting  our SCSI driver. I seems that sd get control of optical 
disk connected and the kernel  did not attach our driver. We  can also 
decide to use sd or sg without our provate driver but sd doesn't support 
8192 block size.
Any idea to pilot one optical disk of 8192 block size ?
Thanks
Aldo

-- 
Aldo Gavioli
Product Manager
NetStorage Software s.r.l
Viale Europa,74 - 20090 Cusago (Milan) Italy - Web: www.netstorage.it 


