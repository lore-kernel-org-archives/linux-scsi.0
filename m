From: Aldo Gavioli <aldo.gavioli@netstorage.it>
Subject: Disk Partitioning
Date: Wed, 25 May 2005 15:55:06 +0200
Message-ID: <429483BA.3070405@netstorage.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpout07.attiva.biz ([85.37.16.5]:1054 "EHLO
	smtpout07.attiva.biz") by vger.kernel.org with ESMTP
	id S262347AbVEYNzM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 May 2005 09:55:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello All,
I'm trying to attach one SCSI driver to kernel 2.6 in order to pilot 
optical disk type WORM.

I have a problem in accessing to a different partition than 0.

On kernel 2.4 I could use the gendisk.part directy to set up my private 
partitioning.
On kernel 2.6  I'm using the add_disk functon, but I did not see any 
possibility to set the disk->part field of gendisk struct.

How can I set my private partition in gendisk struct ?

Thanks
Aldo

-- 
Aldo Gavioli
Product Manager
NetStorage Software s.r.l
Viale Europa,74 - 20090 Cusago (Milan) Italy - Web: www.netstorage.it 


