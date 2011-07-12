From: <jayamohan.kallickal@emulex.com>
Subject: be2iscsi: Patches for inclusion
Date: Tue, 12 Jul 2011 10:12:36 -0700
Message-ID: <ffb11be2-121b-4db8-9bc0-9acfcd2d7880@exht1.ad.emulex.com>
References: <1310490756-2210-1-git-send-email-jayamohan.kallickal@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:50430 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751009Ab1GLRNJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2011 13:13:09 -0400
In-Reply-To: <1310490756-2210-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

Hi

  	These set of patches have been made on 
latest scsi-misc tree pulled today.

0001     Adding a Shutdown routine         
0002     Fixing  the /proc/interrupts corruption

Changelog:
	- Added shutdown routine
	- Fix for the /proc/interrupts corruption issue

Thanks
Jayamohan Kallickal

Signed off by:  Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

---

