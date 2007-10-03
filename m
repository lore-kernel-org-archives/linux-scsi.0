From: Jeff Garzik <jeff@garzik.org>
Subject: git-misc-all updated
Date: Wed, 03 Oct 2007 16:17:24 -0400
Message-ID: <4703F8D4.90500@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:50338 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754958AbXJCUR2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Oct 2007 16:17:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>


Just updated jgarzik/misc-2.6.git#ALL...

'ALL' meta-branch contains these branches, exported for review and testing:

dmi-const	DMI subsystem constification
		--> added your fix/warning patches

isdn-cleanups	ISDN subsystem cleanups for 2.6.24
		--> no word from Karsten after repeated pings
		--> added another couple code movement patches
		    (moved from branch isdn-pci to this one)

pciseg		x86/x86-64 PCI domain support

sas		new drivers broadsas, mvsas
		--> new branch; this is my devel tree for these drivers

Regards,

	Jeff



