From: Andreas Behnert <abehn@gmx.net>
Subject: 2.4.21-pre7, disk size, display wrong or serious bug?
Date: Sun, 06 Apr 2003 02:52:00 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E8F7A30.9050608@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.65.60]:27107 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S262741AbTDFAkk (for <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 5 Apr 2003 19:40:40 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Yesterday I installed an external RAID system, machine
was running kernel 2.2.20 and everything worked ok:
~snip~
  SCSI device sdb: hdwr sector= 512 bytes. Sectors=1278558208
  [624296 MB] [624.3 GB]
~snip~

Then I compiled 2.4.21-pre7 using the old sym53c8xx driver:
~snip~
  SCSI device sdb: 1278558208 512-byte hdwr sectors (-444889 MB)
~snip~

and then again using the new sym53c8xx-2 driver:
~snip~
  SCSI device sdb: 1278558208 512-byte hdwr sectors (-444889 MB)
~snip~


The system *seems* to work ok but I don't know if it really
*does* - I didn't want to experiment very much because the
RAID array contains sensitive data and pulling the files
back from tape takes forever. Unfortunately kernel 2.4.x
will become a must in the near future for this system ...
Is it just the display of the value that is wrong or is this
something I should really worry about?

I don't want to flood this list so I put complete dmesg output
for all three kernel variants on a website in case somebody
want's to have a look at it:
http://www.schachtziege.de/sym53c8xx.html


Thank you,
Regards,
Andreas

