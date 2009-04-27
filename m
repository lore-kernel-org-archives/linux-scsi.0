From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 0/3] scsi_dh: Make scsi device handler modules automatically inserted
Date: Mon, 27 Apr 2009 11:06:09 -0700
Message-ID: <20090427180609.22758.93035.sendpatchset@chandra-ubuntu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:54310 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923AbZD0SFZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Apr 2009 14:05:25 -0400
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by e8.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id n3RHu6pH006397
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2009 13:56:06 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n3RI5LtP692456
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2009 14:05:21 -0400
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n3RI5HFc011048
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2009 12:05:17 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: pjones@redhat.com, michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com, hare@suse.de, Chandra Seetharaman <sekharan@us.ibm.com>

Hello,

Currently, SCSI targets doesn't have modalias support. It wasn't an issue
until SCSI device handler came along.

We want the SCSI device handler modules to be insmodded automatically
when the specific SCSI targets are probed and found.

This set of patches adds the modalias support for SCSI targets and
also makes the relevant changes to SCSI device handler modules to 
make use of it.

Applies cleanly on 2.6.30-rc3 and is tested on the same.

Please review and consider this for inclusion.

Originally sent on March 17 2009 (http://marc.info/?l=linux-scsi&m=123734001009654&w=2).

Resending after testing on 2.6.30-rc3 and with an ack from Hannes.

Thanks & Regards,

chandra

