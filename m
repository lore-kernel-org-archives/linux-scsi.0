From: Pat LaVarre <p.lavarre@ieee.org>
Subject: sg_dd bpt= count=
Date: 14 Oct 2003 17:40:44 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1066174844.3399.6.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:6331 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S261648AbTJNXk5
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Oct 2003 19:40:57 -0400
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

> I find some bugs "interesting".

sudo sg_dd of=/dev/sg0 if=/dev/zero bs=2k bpt= count=
may reliably take down kernels.

I say this because I saw 2.6.0-test7 go down twice, but I haven't yet
confirmed my sg utils are the latest available, and with regret I have
to admit just now I have to turn my attention elsewhere for a few days. 
Noise keeps me from being sure if ping survives.  ssh goes down, the cat
/proc/kmsg there showed nothing, the frozen gui of the main console
showed a couple of complaints about unrecognised multipliers.

Your mileage may vary.

Pat LaVarre


