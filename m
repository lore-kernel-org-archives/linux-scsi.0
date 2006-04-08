From: Andrew Morton <akpm@osdl.org>
Subject: Fw: [BUG] 2.6.17-rc1: SCSI kobject_add problems
Date: Fri, 7 Apr 2006 17:14:33 -0700
Message-ID: <20060407171433.06e454bd.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:33752 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751372AbWDHAMc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Apr 2006 20:12:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-scsi@vger.kernel.org, rct@gherkin.frus.com



Begin forwarded message:

Date: Fri, 7 Apr 2006 13:31:05 -0500 (CDT)
From: rct@gherkin.frus.com (Bob Tracy)
To: linux-kernel@vger.kernel.org
Subject: [BUG] 2.6.17-rc1: SCSI kobject_add problems


System is a DEC Alpha 433au with two SCSI disks.  SCSI controller is a
QLA1040 supported by the qla1280 driver.  Runs 2.6.16 fine.  Tried
booting 2.6.17-rc1 and got

kobject_add failed for 0:0: with -EEXIST, don't try to register things with the same name in the same directory

and a fairly long trace output when the system attempted to add sdb.
Not surprisingly, sdb was inaccessible.

Normally (for 2.6.16 anyway), the following relationship exists:

sd 0:0:0:0	sda
sd 0:0:1:0	sdb

More information *might* be available if needed, but will have to be
transcribed by hand.  My /usr partition is on sdb, so I don't get very
far with 2.6.17-rc1 on Alpha :-).  The problem is probably specific to
the qla1280 or the Alpha, as I have a x86 Adaptec SCSI-based system
with multiple spindles that works fine with 2.6.17-rc1.

-- 
-----------------------------------------------------------------------
Bob Tracy                   WTO + WIPO = DMCA? http://www.anti-dmca.org
rct@frus.com
-----------------------------------------------------------------------
-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
