From: "Justin T. Gibbs" <gibbs@btc.adaptec.com>
Subject: scsi_malloc fragmentation in 2.4.X
Date: Fri, 20 Dec 2002 13:31:58 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <70300000.1040416318@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6+Sun/8.11.6) with ESMTP id gBKKW2j25474
	for <linux-scsi@vger.kernel.org>; Fri, 20 Dec 2002 12:32:02 -0800 (PST)
Received: from btc.btc.adaptec.com (btc.btc.adaptec.com [10.100.0.52])
	by redfish.adaptec.com (8.8.8+Sun/8.8.8) with ESMTP id MAA26775
	for <linux-scsi@vger.kernel.org>; Fri, 20 Dec 2002 12:32:01 -0800 (PST)
Received: from [10.100.253.70] (aslan [10.100.253.70])
	by btc.btc.adaptec.com (8.8.8+Sun/8.8.8) with ESMTP id NAA29716
	for <linux-scsi@vger.kernel.org>; Fri, 20 Dec 2002 13:31:57 -0700 (MST)
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Are there any plans to correct the scsi_malloc fragmentation problems
in 2.4.X?  It looks like this problem has been addressed in 2.5.X by using
memory pools, but the current 2.4.X solution of just "backing off a bit"
if scsi_malloc returns NULL, is much less than ideal.  At least the user
isn't assaulted by lots of "Running really short on DMA buffers" messages,
but performance does suffer when the only reason you can't queue an I/O
is that the pre-allocated S/G list memory is so poorly managed that the
available memory can't be used.

--
Justin

