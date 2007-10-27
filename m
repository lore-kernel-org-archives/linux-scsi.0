From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 0/9] lpfc 8.2.3 : lpfc 8.2.3 patches
Date: Sat, 27 Oct 2007 13:36:56 -0400
Message-ID: <1193506616.8770.13.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:46297 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633AbXJ0Rgw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Oct 2007 13:36:52 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id l9RHapQY021332
	for <linux-scsi@vger.kernel.org>; Sat, 27 Oct 2007 10:36:51 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This set of patches updates the lpfc driver to revision 8.2.3.

All are bug fixes targeted for 2.6.25

- Added support for ASICs that report temperature.
- NPIV bug fixes:
- Remove flawed MBX_STOP_IOCB logic
- Miscellaneous Small Fixes - part 1
- FC Discovery Fixes:
- Miscellaneous Small Fixes - part 2
- Internal loopback fixes:
- Temperature handling fix - return proper error code indicator for applications
- Change version number to 8.2.3

-- james s



