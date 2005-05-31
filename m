From: Anil kumar <anils_r@yahoo.com>
Subject: suse 9.3pro x86_64 kernel source rpm fixdep script error
Date: Tue, 31 May 2005 11:47:04 -0700 (PDT)
Message-ID: <20050531184704.44932.qmail@web32411.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web32411.mail.mud.yahoo.com ([68.142.207.204]:5217 "HELO
	web32411.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S261177AbVEaSrF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 May 2005 14:47:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Hi,

I downloaded SuSE 9.3pro x86_64 kernel-source rpm
from:
http://mirror.tv2.dk/pub/linux/suse/people/mantel/kotd/9.3-x86_64/SL93_BRANCH/

After extracting the rpm, the scripts under:
/usr/src/linux-2.6.11.4-SL93_BRANCH_20050525084504-obj/x86_64/default/scripts/basic

The script "fixdep" reports error as:
bash: ./fixdep: cannot execute binary file

#ll fixdep
-rwxr-xr-x 2 root root 9120 May 31 09:25 fixdep

Looks like I have right execute permissions. Is it
something I am missing/overlooked? Or the script is
bad?

FYI, I did rpm2cpio to extract it.

Thanks for help in advance.

with regards,
  Anil




		
__________________________________ 
Yahoo! Mail 
Stay connected, organized, and protected. Take the tour: 
http://tour.mail.yahoo.com/mailtour.html 

