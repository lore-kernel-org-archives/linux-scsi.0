From: Andrew Ryan <genanr@emsphone.com>
Subject: 2.6.0-test1 and qlogic 8.00.00b4 driver
Date: Mon, 28 Jul 2003 17:08:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030728220836.GA10845@thumper2.emsphone.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from thumper2.emsphone.com ([199.67.51.102]:52690 "EHLO
	thumper2.emsphone.com") by vger.kernel.org with ESMTP
	id S271146AbTG1WIp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Jul 2003 18:08:45 -0400
Received: from thumper2.emsphone.com (genanr@localhost [127.0.0.1])
	by thumper2.emsphone.com (8.12.9/8.12.9/Debian-3) with ESMTP id h6SM8biR010859
	for <linux-scsi@vger.kernel.org>; Mon, 28 Jul 2003 17:08:37 -0500
Received: (from genanr@localhost)
	by thumper2.emsphone.com (8.12.9/8.12.9/Debian-3) id h6SM8bAK010857
	for linux-scsi@vger.kernel.org; Mon, 28 Jul 2003 17:08:37 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Linux is not seeing any devices attached to a CMD CRA-7280 san connected
raid unit using kernel 2.6.0-test[12] and qlogic drive 8.00.00b4.  It works
in 2.5.69 with qlogic 8.00.00b3 drivers and the b4 drivers (kernel
2.6.0-test1) were able to see devices on a Hitachi eval unit we had.  I
can't tell if it is the kernel or drives since the b4 drivers are needed for
the 2.6 kernels and I cannot use the b4 drivers in the 2.5.69 kernel. 
2.5.75 gives me oops problems.   I haven't tried the others.  Any ideas.

Andy

genanr@allantgroup.com

