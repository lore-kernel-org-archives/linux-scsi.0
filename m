From: "Ravi Anand" <ravi.anand@qlogic.com>
Subject: RE: 2.6.0-test1 and qlogic 8.00.00b4 driver
Date: Mon, 28 Jul 2003 18:15:05 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3679966B84813344B908D418BA3F6A4A01F00157@AVEXCH01.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [198.70.193.2] ([198.70.193.2]:51934 "EHLO AVEXCH01.qlogic.org")
	by vger.kernel.org with ESMTP id S271211AbTG2BO5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Jul 2003 21:14:57 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Andrew Ryan <genanr@emsphone.com>, linux-scsi@vger.kernel.org

Make sure that Probe Multi lun support is enabled in the kernel(Under scsi device support) Or you can set the module param max_scsi_luns/max_scsi_reports_lun in the modules.conf file and build new ram disk image.

Ravi

-----Original Message-----
From: Andrew Ryan [mailto:genanr@emsphone.com]
Sent: Monday, July 28, 2003 3:09 PM
To: linux-scsi@vger.kernel.org
Subject: 2.6.0-test1 and qlogic 8.00.00b4 driver


Linux is not seeing any devices attached to a CMD CRA-7280 san connected
raid unit using kernel 2.6.0-test[12] and qlogic drive 8.00.00b4.  It works
in 2.5.69 with qlogic 8.00.00b3 drivers and the b4 drivers (kernel
2.6.0-test1) were able to see devices on a Hitachi eval unit we had.  I
can't tell if it is the kernel or drives since the b4 drivers are needed for
the 2.6 kernels and I cannot use the b4 drivers in the 2.5.69 kernel. 
2.5.75 gives me oops problems.   I haven't tried the others.  Any ideas.

Andy

genanr@allantgroup.com

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
