From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: next-2008-0306 scsi/libsas build failure
Date: Thu, 6 Mar 2008 09:09:04 -0800
Message-ID: <20080306090904.258f92eb.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:52309 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761498AbYCFRJv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Mar 2008 12:09:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-next@vger.kernel.org, scsi <linux-scsi@vger.kernel.org>
Cc: jejb <James.Bottomley@HansenPartnership.com>

drivers/built-in.o: In function `sas_request_addr':
(.text+0x598fb): undefined reference to `request_firmware'
drivers/built-in.o: In function `sas_request_addr':
(.text+0x5998e): undefined reference to `release_firmware'
make[1]: *** [.tmp_vmlinux1] Error 1
make: *** [sub-make] Error 2

drivers/scsi/libsas/sas_scsi_host.c calls request_firmware() and
release_firmware() without checking to see if CONFIG_FW_LOADER=y.

---
~Randy
