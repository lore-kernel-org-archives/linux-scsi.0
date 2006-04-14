From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: section mismatches (scsi e.g.)
Date: Fri, 14 Apr 2006 09:29:11 -0700
Message-ID: <20060414092911.71f25ac1.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:14829 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S1751258AbWDNQ0q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Apr 2006 12:26:46 -0400
Received: from midway.site ([71.111.157.99]) by xenotime.net for <linux-scsi@vger.kernel.org>; Fri, 14 Apr 2006 09:26:44 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sam@ravnborg.org
Cc: scsi <linux-scsi@vger.kernel.org>

Hi Sam,

I was looking at these warnings (on 2.6.17-rc1-git8):

WARNING: drivers/scsi/3w-9xxx.o - Section mismatch: reference to .init.data: from .data between 'twa_driver' (at offset 0x18) and 'twa_error_table'
WARNING: drivers/scsi/3w-xxxx.o - Section mismatch: reference to .init.data: from .data between 'tw_driver' (at offset 0x18) and 'tw_sense_table'
WARNING: drivers/scsi/gdth.o - Section mismatch: reference to .init.text:gdth_detect from .data between 'driver_template' (at offset 0x270) and 'async_cache_tab'

I either don't see a problem or I'm having trouble reading/decoding
the warning messages.  Could you look at these 3 sometime?

Must have CONFIG_HOTPLUG=n ...

---
~Randy
