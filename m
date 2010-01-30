From: ranand <ravi.anand@qlogic.com>
Subject: [PATCH 0/11] qla4xxx: Driver Fixes [v5.01.00-k10]
Date: Fri, 29 Jan 2010 22:27:47 -0800
Message-ID: <20100130062747.GA10274@linux-qf4p>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:8948 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab0A3GZ6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 30 Jan 2010 01:25:58 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@suse.de>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>

James,

Please apply following patches which I have generated against
your latest scsi-misc tree pulled today :


Ravi Anand (1):
      qla4xxx: Update version number to 5.01.00-k10

Vikas Chaudhary (10):
      qla4xxx: Wait for device to come online.
      qla4xxx: added IPv6 support.
      qla4xxx: Link Down -> Mark all devices missing
      qla4xxx: Code Clean up - remove "marker_needed"
      qla4xxx: Updated firmware ready timeout algorithm to prevent long delays
      qla4xxx: added srb referance counter
      qla4xxx: Avoid relogin on device marked missing
      qla4xxx: fixed NULL pointer dereference in eh_device_reset
      qla4xxx: do not retry login to CHAP auth failed targets
      qla4xxx: added support for abort task management command

Thanks
Ravi Anand
