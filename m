From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: [patch 0/3] AHCI Link Power Management
Date: Mon, 11 Jun 2007 11:46:00 -0700
Message-ID: <20070611114600.7fca1c24.kristen.c.accardi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:62647 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753086AbXFKSta (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Jun 2007 14:49:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jeff@garzik.org, james.bottomley@steeleye.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, htejun@gmail.com, arjan@linux.intel.com

Hi,
This series of patches enables Aggressive Link Power Management for AHCI 
devices, as documented in the AHCI spec.  On my laptop (a Lenovo X60), this
saves me a full watt of power.  On other systems, reported power savings
range from .5-1.5 Watts.  It has been tested by the kind folks at #powertop
with similar results.  Please give it a try and let me know what you think.

thanks,
Kristen

-- 
