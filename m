From: James Smart <James.Smart@Emulex.Com>
Subject: Missing Patches - please pull these in....
Date: Mon, 26 Jun 2006 17:07:25 -0400
Message-ID: <44A04C8D.3070008@emulex.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:21247 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S933034AbWFZVHi
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jun 2006 17:07:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>, Andrew Morton <akpm@osdl.org>

James,

I looked at your 2.6.17 drop as well as the latest scsi-misc-2.6 tree,
and the following patches have not yet been applied.  Can you please
do so as soon as possible (especially on the one posted in March).

-- james s

3/8/06: [PATCH Repost 0/2] Block I/O while SG reset operation in progress
http://marc.theaimsgroup.com/?l=linux-scsi&m=114184745819730&w=2
http://marc.theaimsgroup.com/?l=linux-scsi&m=114184745830216&w=2
http://marc.theaimsgroup.com/?l=linux-scsi&m=114184745819007&w=2

5/11/06: [PATCH] fc transport: resolve scan vs delete deadlocks  (CRITICAL)
http://marc.theaimsgroup.com/?l=linux-scsi&m=114736846214310&w=2

5/16/06: [REPOST #2][PATCH] update max sdev block limit
http://marc.theaimsgroup.com/?l=linux-scsi&m=114781033210150&w=2

6/15/06: [PATCH] scsi_scan.c: bug fix: starget use after free issue  (CRITICAL)
http://marc.theaimsgroup.com/?l=linux-scsi&m=115039057504409&w=2

And these new ones are critical as well:

6/26/06: [REPOST][PATCH] fc transport: bug fix: correct references  (CRITICAL)
http://marc.theaimsgroup.com/?l=linux-scsi&m=115134614426385&w=2

6/26/06: [PATCH] scsi midlayer: fix sdev reuse after free   (CRITICAL)
http://marc.theaimsgroup.com/?l=linux-scsi&m=115134812215106&w=2

