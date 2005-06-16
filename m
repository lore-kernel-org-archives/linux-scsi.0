From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH 0/5] scsi host / scsi target state model update
Date: Thu, 16 Jun 2005 11:10:58 -0700
Message-ID: <20050616181058.GA20923@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:15510 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S261766AbVFPSKf
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jun 2005 14:10:35 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j5GIAV3o404116
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2005 14:10:31 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j5GIAUe9153640
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2005 12:10:30 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id j5GIAUIe025137
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2005 12:10:30 -0600
Received: from hmsbounty.us.ibm.com (sig-9-48-50-108.mts.ibm.com [9.48.50.108])
	by d03av02.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id j5GIAUOO025097
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2005 12:10:30 -0600
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch sequence converts the SCSI host state model to a model like
SCSI device is using and adds a state model for SCSI targets. These new
state models are then used to help in the removal of targets and devices
during removal of a SCSI host.

I have done some simple add and delete testing. The target state model
should have more of the targets states covered. The
list_for_each_entry_safe in __scsi_remove_target needs to be cleaned up.

For background context please refer to previous mail.

http://marc.theaimsgroup.com/?t=111878458800003&r=1&w=2

http://marc.theaimsgroup.com/?t=111833447800002&r=1&w=2


-andmike
--
Michael Anderson
andmike@us.ibm.com

