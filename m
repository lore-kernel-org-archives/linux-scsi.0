From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Megaraid: Use of outb_p
Date: Fri, 18 Jan 2008 12:36:14 +0000
Message-ID: <20080118123614.78f7400b@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:32794 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757584AbYARMhy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Jan 2008 07:37:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, megaraidlinux@lsi.com


I notice the MegaRAID driver uses outb_p. Can someone at LSI confirm that
the delays between each I/O are required, and if so how long they must be.

I'm trying to sort out the use of in/outb_p and where it is unneccessary
or used for non ISA devices.

(Please cc me on the reply)
Alan

