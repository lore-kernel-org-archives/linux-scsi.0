From: Brian Nelson <bnelson@cis.ysu.edu>
Subject: Question on aic7xxx driver v6.3.x
Date: Wed, 18 Feb 2004 15:10:47 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <E1AtY1v-00044W-00@frodo.cis.ysu.edu>
Reply-To: Brian Nelson <bnelson@cis.ysu.edu>
Mime-Version: 1.0
Content-Type: TEXT/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from FRODO.CIS.YSU.EDU ([150.134.20.2]:26342 "EHLO
	ysuwebshield01.ysu.edu") by vger.kernel.org with ESMTP
	id S268003AbUBRULA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Feb 2004 15:11:00 -0500
Received: from kirk.cis.ysu.edu ([150.134.20.22])
	by frodo.cis.ysu.edu with smtp (Exim 3.34 #1)
	id 1AtY1v-00044W-00
	for linux-scsi@vger.kernel.org; Wed, 18 Feb 2004 15:10:47 -0500
Content-MD5: SRQaWjSwFPLCrH54enm4sw==
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I hope this is directed to the proper list :)

I am wondering what is/are the differences between the aic7xxx driver 6.2.x and 
6.3.x. I notice that only 6.2 is integrated into the kernel, but 6.3 is 
available on Justin Gibbs' website. Is there anything I should know about NOT 
running v6.3?

I was having problems with SCSI ABORTs on my tape library (overland neo 4100 w/ 
2x hp lto2). Anyways, I installed v6.3, and it seems to have cured it. I just 
wanted to make sure I wasn't doing something stupid, or running alpha drivers or 
something.

Please email any response.

Thanks!

-Brian

