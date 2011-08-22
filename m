From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
Subject: be2iscsi: Patches for inclusion
Date: Mon, 22 Aug 2011 10:08:30 -0700
Message-ID: <96709bd9-2cb7-49da-ab13-54442c855f48@exht1.ad.emulex.com>
References: <1314032910-2304-1-git-send-email-jayamohan.kallickal@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:17366 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752029Ab1HVRJH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Aug 2011 13:09:07 -0400
In-Reply-To: <1314032910-2304-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

Hi

  	These set of patches have been made on 
latest scsi-misc tree

Jayamohan Kallickal (3):
	be2iscsi: Fixing the /proc/interrupts problem to avoid
		  corruption in /proc/interrupts
	be2iscsi: Adding a shutdown routine as be2iscsi was not doing a
		  cleanup during kexec
	be2iscsi: Add call to pci_disable device during rmmod and shutdown

Thanks
Jayamohan Kallickal

Signed off by:  Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

---

