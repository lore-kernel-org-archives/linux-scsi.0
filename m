From: Douglas Gilbert <dougg@torque.net>
Subject: aic7xxx build quirk in 2.5.53
Date: Sat, 28 Dec 2002 10:54:27 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E0CE833.60604@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from torque.net (dm1-91.triode.net.au [202.147.125.91])
	by iggy.triode.net.au (8.11.6/8.11.6) with ESMTP id gBRNq2i08493
	for <linux-scsi@vger.kernel.org>; Sat, 28 Dec 2002 10:52:03 +1100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I noticed that parts of the aic7xxx driver build
each time "make modules" is run even though there has
been no change to aic7xxx code since the previous time
"make modules" was run.

Doug Gilbert

