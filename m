From: Douglas Gilbert <dougg@torque.net>
Subject: SHT::slave_alloc() return ignored sometimes
Date: Fri, 29 Nov 2002 10:41:45 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DE6A9B9.1010709@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from torque.net (dm1-11.triode.net.au [202.147.125.11])
	by iggy.triode.net.au (8.11.6/8.11.6) with ESMTP id gASNrlU11807
	for <linux-scsi@vger.kernel.org>; Fri, 29 Nov 2002 10:53:47 +1100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

It is not clear what happens when a LLD returns non-zero
to slave_alloc(). The scanning code in scsi_scan.c removes
the device in one instance and ignores the returned value
in 2 other instances. [lk 2.5.50]

Do we have other changes to the mid level - lower level
interface planned (e.g. alternate method to queuecommand() )?

Doug Gilbert


