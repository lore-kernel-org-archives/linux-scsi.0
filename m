From: Gene Heskett <gene.heskett@verizon.net>
Subject: advansys problems
Date: Sun, 23 May 2004 11:32:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200405231132.59100.gene.heskett@verizon.net>
Reply-To: gene.heskett@verizon.net
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out014pub.verizon.net ([206.46.170.46]:46286 "EHLO
	out014.verizon.net") by vger.kernel.org with ESMTP id S263088AbUEWPdC
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 May 2004 11:33:02 -0400
Received: from coyote.coyote.den ([151.205.56.33]) by out014.verizon.net
          (InterMail vM.5.01.06.06 201-253-122-130-106-20030910) with ESMTP
          id <20040523153300.CYZK5247.out014.verizon.net@coyote.coyote.den>
          for <linux-scsi@vger.kernel.org>; Sun, 23 May 2004 10:33:00 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Greetings, I finally found this list.

Running FC1, updated from RH8, kernel 2.6.6-mm5 ATM on an older 1.4Ghz 
athlon.  Half a gig of ram.

Pursuant to the msg that the advansys driver wasn't planned for 
further updating, I figured I might as well play blind man and see if 
I could extract enough debugging info to be usefull.  First, I 
enabled scsi debugging in the kernel .config and rebuilt it before 
last night amanda run.  That apparently made no actual diff as there 
was nothing in the logs this morning after amanda shovled about 3.5 
Gb of data out to tape last night.

Unforch, the compile breaks when I uncomment the #define ADVANSYS_DBG 
line, which I tried this morning.  At first I also had put a 

#define asc_dbglvl 1

in there, but that caused a compile breakage (a different one) also.

So whats next?

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
99.23% setiathome rank, not too shabby for a WV hillbilly
Yahoo.com attorneys please note, additions to this message
by Gene Heskett are:
Copyright 2004 by Maurice Eugene Heskett, all rights reserved.
