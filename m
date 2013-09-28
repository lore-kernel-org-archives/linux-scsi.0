From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH V2 00/23] be2iscsi: Update to 10.0.659.0
Date: Sat, 28 Sep 2013 15:36:01 -0700
Message-ID: <1380407761-2949-24-git-send-email-jayamohan.kallickal@emulex.com>
References: <1380407761-2949-1-git-send-email-jayamohan.kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:54586 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414Ab3I1Wg6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Sep 2013 18:36:58 -0400
Received: by mail-pa0-f49.google.com with SMTP id ld10so4249297pab.22
        for <linux-scsi@vger.kernel.org>; Sat, 28 Sep 2013 15:36:58 -0700 (PDT)
In-Reply-To: <1380407761-2949-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

This patchset fixes the comments make by Mike Christie 
for Patch 4 and 6. Also, have added a new patch to fix a 
newly discovered issues(patch 22).

I am resubmitting all the patches here as V2 ,so, Pl ignore the 
earlier patchset

This patchset will update be2iscsi driver to  10.0.659.0
 and contains the following patches based of  scsi.git scsi-misc
`
 PATCH V2 0001 - Fix Template HDR IOCTL 
 PATCH V2 0002 - Fix the MCCQ count leakage 
 PATCH V2 0003 - Fix repeated issue of MAC ADDR in get IOCTL 
 PATCH V2 0004 - Fix negotiated parameters upload to FW 
 PATCH V2 0005 - Fix locking mechanism in Unsol Path 
 PATCH V2 0006 - Fix soft lock up issue during UE  
 PATCH V2 0007 - Config parameters update for Dual Chute Sup 
 PATCH V2 0008 - Fix changes in ASYNC Path for SKH-R adapter 
 PATCH V2 0009 - Fix Template HDR support for Dual Chute mode 
 PATCH V2 0010 - Fix SGL Initilization and posting Pages
 PATCH V2 0011 - Fix WRB_Q posting to support Dual Chute mod 
 PATCH V2 0012 - Fix CID allocation freeing to support Dual chute  
 PATCH V2 0013 - Fix connection offload to support Dual Chute 
 PATCH V2 0014 - Fix chute cleanup during drivers unload 
 PATCH V2 0015 - Dispaly CID available for connection offload 
 PATCH V2 0016 - Display Port Identifier for each iSCSI function 
 PATCH V2 0017 - Fix MSIx creation for SKH-R adapter 
 PATCH V2 0018 - Fix log level for protocol specific logs 
 PATCH V2 0019 - Fix Insufficient Buffer Error returned in MBX 
 PATCH V2 0020 - Invalidate WRB in Abort Reset Path 
 PATCH V2 0021 - Fix AER handling in driver 
 PATCH V2 0022 - Fix SGL posting for unaligned ICD values.patch
 PATCH V2 0023 - Bump the driver version 


Thanks
Jay

Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---

