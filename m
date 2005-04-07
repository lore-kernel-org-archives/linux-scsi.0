From: sai narasimhamurthy <sai_narasi@yahoo.com>
Subject: Increasing MAX_SECTORS  in blkdev.h
Date: Thu, 7 Apr 2005 11:38:03 -0700 (PDT)
Message-ID: <20050407183803.27897.qmail@web54110.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web54110.mail.yahoo.com ([206.190.37.245]:55147 "HELO
	web54110.mail.yahoo.com") by vger.kernel.org with SMTP
	id S262545AbVDGSiE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Apr 2005 14:38:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi, 
I wanted to increase the number of sectors that could
be requested/Written  per SCSI READ(10)/WRITE command
, and varying MAX_SECTORS in blkdev.h helped me to do
it. However I could not request more than 256 sectors
and could not write more than 1024 inspite of changing
MAX_SECTORS to higher numbers. 
Why is that? There is probably some other variable
that should be varied. Please let me know. 
I am working on the UNH iSCSI initiator driver , and
am on kernel 2.4.29 .  

Sai 




		
__________________________________ 
Do you Yahoo!? 
Make Yahoo! your home page 
http://www.yahoo.com/r/hs
