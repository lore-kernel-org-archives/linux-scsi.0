From: Douglas Gilbert <dougg@torque.net>
Subject: 2.5.48 modules problem
Date: Tue, 19 Nov 2002 08:58:14 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DD96276.5050005@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from torque.net (dm1-77.triode.net.au [202.147.125.77])
	by iggy.triode.net.au (8.11.6/8.11.6) with ESMTP id gAILwX118709
	for <linux-scsi@vger.kernel.org>; Tue, 19 Nov 2002 08:58:35 +1100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Can't see other reports on this in the lists **.
When I upgraded to lk 2.5.48, my kernel can't load
modules. modprobe and friends all fail with:
   QM_MODULES: Function not implemented

RH8.0 base system. Suggestions?


** Tried Adam J. Richter patch from lkml entitled:
"Patch(2.5.48): Restore module device ID tables" but it
didn't help.

