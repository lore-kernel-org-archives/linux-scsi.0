From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 0/10] remove scsi_request usage from sg and st
Date: Tue, 08 Nov 2005 04:06:29 -0600
Message-ID: <1131444389.23111.56.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:5023 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932494AbVKHKGf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2005 05:06:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de, linux-scsi@vger.kernel.org

The following patches, made against scsi-misc, remove the scsi_request
usage from st and sg, do some tiny cleanup on sg, and make sg and st
always perform scatterlist IO.

I have tested against libata and scsi_debug for disks. There are slight
changes, so someone with a tape device should test the patches, but Kai
since Kai did all the debugging last round I have not made many changes.
We will probably hit many problems with LLDs using low max_hw_sectors,
because they have not been converted to export their real values on the
host template so I think these patches should sit in scsi-misc for a
good deal of time.

