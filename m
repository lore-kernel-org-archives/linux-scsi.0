From: James Smart <james.smart@emulex.com>
Subject: [PATCH 0/6] lpfc 8.3.9: Update lpfc to revision 8.3.9
Date: Fri, 12 Feb 2010 14:39:42 -0500
Message-ID: <1266003602.2939.13.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:49924 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757052Ab0BLTk0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2010 14:40:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


This patch set updates the lpfc driver to revision 8.3.9

The patches for 8.3.9 contain:
- PCI Changes to lpfc driver
- Discovery changes to the lpfc driver.
- SLI enhancments to support new hardware.
- Changes to sysfs interface for the lpfc driver.
- Fix locking and memory issues 
- Update Driver version to 8.3.9

The bugfixes were cut against scsi-misc-2.6


-- james s


  Signed-off-by: James Smart <james.smart@emulex.com>




