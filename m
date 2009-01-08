From: Tony Battersby <tonyb@cybernetics.com>
Subject: [PATCH 0/7] sym53c8xx fixes
Date: Thu, 08 Jan 2009 12:51:28 -0500
Message-ID: <49663D20.8000504@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host64.cybernetics.com ([98.174.209.230]:1908 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbZAHRvc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jan 2009 12:51:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

James, please consider these patches for inclusion in 2.6.29 or 2.6.30.

Patches 1 - 5 fix bugs found when auditing the error paths of sym53c8xx
during module load and unload.  These 5 patches must be applied in
the order given, since they touch the same areas of the same file.
Patches 6 and 7 fix other problems and annoyances, and can be applied
in any order.

In addition, here are some related patches by other people that I
would like applied:

The following patch fixes handling of errors that occur after
scsi_host_alloc() during modprobe sym53c8xx.  I actually came up
with the same fix myself when auditing sym53c8xx, but a search of
linux-scsi showed that someone else had already gotten there first.
[PATCH] SCSI: fix /proc memory leak in the SCSI core
http://marc.info/?t=122814541000002&r=1&w=4

The following patch was posted a year ago but forgotten.  I have been
using it for a long time, and it still applies cleanly.
sym53c8xx ISTAT1 feature never set
http://marc.info/?t=120076464500006&r=1&w=4

And of course there are the recent patches by Aaro Koskinen:

Tested with my approval (be sure to use the updated version):
[PATCH] sym53c8xx_2: slave_alloc/destroy safety (2.6.27.5)
http://marc.info/?t=122710678100001&r=1&w=4

Tested with my approval:
[PATCH] sym53c8xx_2: lun to_clear flag not re-initialized (2.6.27.5)
http://marc.info/?t=122710178300003&r=1&w=4

This one however still needs some work (as of this writing):
[PATCH] sym53c8xx_2: Keep transfer negotiations valid (2.6.27.5)
http://marc.info/?t=122710118300005&r=1&w=4

Thanks,
Tony Battersby
Cybernetics


