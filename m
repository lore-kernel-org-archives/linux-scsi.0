From: Jamie Lenehan <lenehan@twibble.org>
Subject: [PATCH] dc395x - description
Date: Sun, 3 Aug 2003 18:27:18 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030803082718.GA4594@twibble.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tuon.twibble.org ([203.217.29.157]:30899 "EHLO tuon.twibble.org")
	by vger.kernel.org with ESMTP id S270435AbTHCI1X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Aug 2003 04:27:23 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dc395x@twibble.org

A few updates for the dc395x driver.
Patches against 2.6.0-test2-bk2

01-remove-static-eeprom-struct.patch:

 Move the eeprom details from a static struct indexed by adapter
 number into the adapter information block of the adapter. This
 removes the fixed size static array and removes the need to count
 the number of adapters.

02-remove-static-adapter-list.patch:

 Remove the static list of adapters and the code related to keeping
 this up to date. The only remaining use for the static list was for
 the proc info function to find the scsi_host, but that's passed as a
 parameter anyway.

03-fix-failures.patch:

 Handle the case where scsi_add_host fails and update the removal
 function to correctly unregister everything.

-- 
 Jamie Lenehan              Work Phone: +61 3 9843 8817
 lenehan@twibble.org        Work Email: jamie.lenehan@activcard.com.au
