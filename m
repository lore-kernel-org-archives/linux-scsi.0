From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
Subject: [PATCH 3/3] be2iscsi: Add pci_disable device
Date: Wed, 24 Aug 2011 16:05:33 -0700
Message-ID: <1314227133-3678-4-git-send-email-jayamohan.kallickal@emulex.com>
References: <1314227133-3678-1-git-send-email-jayamohan.kallickal@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:5729 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752091Ab1HXXGS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Aug 2011 19:06:18 -0400
In-Reply-To: <1314227133-3678-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

James,

  	These set of patches have been made on 
today's updated scsi-misc tree. I have redone the patches based on comments
from Eike and Mike.

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

