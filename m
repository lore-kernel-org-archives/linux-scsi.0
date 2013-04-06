From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: be2iscsi: Patchset for be2iscsi
Date: Fri,  5 Apr 2013 20:38:39 -0700
Message-ID: <1365219519-3457-19-git-send-email-jayamohan.kallickal@emulex.com>
References: <1365219519-3457-1-git-send-email-jayamohan.kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42281 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755742Ab3DFDoR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Apr 2013 23:44:17 -0400
Received: by mail-pa0-f46.google.com with SMTP id lb1so2329411pab.5
        for <linux-scsi@vger.kernel.org>; Fri, 05 Apr 2013 20:44:16 -0700 (PDT)
In-Reply-To: <1365219519-3457-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>


Hi James

These patches contains updates for the be2iscsi driver
cut against scsi.git, branch "misc"

This set of patches fixes the issue MikeC commented on.

This patchset consolidates  earlier patchset submitted on 11 Mar 
along with a reentrancy issue fix from Shlomo Pongratz

Also, there are three new patches - patch 15,16 and 17

The patcheset for 10.0.467.0 includes
	- Fix lack of uninitialize pattern to FW
	- Fix returning Failure when MBX has insufficient Buffer
	- Fix MBX Command issues
	- Fix MSIx support in SKH R to 32
	- Fix freeing CXN specific driver resources
	- Fix MACRO for checking the adapter type
	- Fix support for DEFQ extension
	- Fix displaying the FW Version from driver
	- ix displaying the Active Session Count from driver
	- Fix the Port Link Status issue
	- Fix the NOP In handling code path
	- Fix dynamic CID allocation Mechanism in driver
	- Fix checking Adapter state while establish a connection
	- Fix the copyright Information
	- Fix the session cleanup when reboot or shutdown happens
	- Fix possible reentrancy issue in be_iopoll
		Acking patch by Shlomo Pongratz
	- Fix issue in passing the exp_cmdsn and  max_cmdsn
	- Bump the driver version

Thanks
Jay

Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
