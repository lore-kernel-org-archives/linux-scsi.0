From: pranav r <pranavrr@yahoo.com>
Subject: segmentation fault...while you insmod qla2200.o
Date: Thu, 27 May 2004 00:58:10 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040527075810.71282.qmail@web12906.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web12906.mail.yahoo.com ([216.136.174.73]:47652 "HELO
	web12906.mail.yahoo.com") by vger.kernel.org with SMTP
	id S261711AbUE0H6L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 May 2004 03:58:11 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

hi,

I have downloaded the Qlogic Fbber Channel Driver (for HBAs QLA2200) from the qlogic site for
LINUX RED HAT. I use Linux Red Hat 7.3 (kernel-2.4.18-3). I did the following:

[root@localhost tmp]# tar -xvzf qla2x00-v6.06.10-dist.tgz

[root@localhost tmp]# cd qlogic/

[root@localhost qlogic]# ./drvrsetup

[root@localhost qlogic]# make all

[root@localhost qlogic]# insmod qla2200.o
Segmentation fault........




	
		
__________________________________
Do you Yahoo!?
Friends.  Fun.  Try the all-new Yahoo! Messenger.
http://messenger.yahoo.com/ 
