From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH 00/22] be2iscsi: Update to 10.0.635.0
Date: Thu, 12 Sep 2013 22:10:13 -0700
Message-ID: <1379049014-32716-23-git-send-email-jayamohan.kallickal@emulex.com>
References: <1379049014-32716-1-git-send-email-jayamohan.kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:40130 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575Ab3IMFg7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Sep 2013 01:36:59 -0400
Received: by mail-pb0-f45.google.com with SMTP id mc17so776069pbc.4
        for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2013 22:36:58 -0700 (PDT)
In-Reply-To: <1379049014-32716-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

This patchset will update be2iscsi driver to  10.0.635.0
 and contains the following patches based of  scsi.git scsi-misc
`
 PATCH 0001 - Fix Template HDR IOCTL 
 PATCH 0002 - Fix the MCCQ count leakage 
 PATCH 0003 - Fix repeated issue of MAC ADDR in get IOCTL 
 PATCH 0004 - Fix negotiated parameters upload to FW 
 PATCH 0005 - Fix locking mechanism in Unsol Path 
 PATCH 0006 - Fix soft lock up issue during UE  
 PATCH 0007 - Config parameters update for Dual Chute Sup 
 PATCH 0008 - Fix changes in ASYNC Path for SKH-R adapter 
 PATCH 0009 - Fix Template HDR support for Dual Chute mode 
 PATCH 0010 - Fix SGL Initilization and posting Pages
 PATCH 0011 - Fix WRB_Q posting to support Dual Chute mod 
 PATCH 0012 - Fix CID allocation freeing to support Dual chute  
 PATCH 0013 - Fix connection offload to support Dual Chute 
 PATCH 0014 - Fix chute cleanup during drivers unload 
 PATCH 0015 - Dispaly CID available for connection offload 
 PATCH 0016 - Display Port Identifier for each iSCSI function 
 PATCH 0017 - Fix MSIx creation for SKH-R adapter 
 PATCH 0018 - Fix log level for protocol specific logs 
 PATCH 0019 - Fix Insufficient Buffer Error returned in MBX 
 PATCH 0020 - Invalidate WRB in Abort Reset Path 
 PATCH 0021 - Fix AER handling in driver 
 PATCH 0022 - Bump the driver version 


Thanks
Jay

Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---

