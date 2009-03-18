From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 0/3] scsi_dh: Make scsi device handler modules automatically inserted
Date: Tue, 17 Mar 2009 18:36:15 -0700
Message-ID: <20090318013615.26548.36303.sendpatchset@chandra-ubuntu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:42961 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755018AbZCRBdT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Mar 2009 21:33:19 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n2I1VrNR006468
	for <linux-scsi@vger.kernel.org>; Tue, 17 Mar 2009 19:31:53 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n2I1XGEH209660
	for <linux-scsi@vger.kernel.org>; Tue, 17 Mar 2009 19:33:16 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n2I1XGfL026953
	for <linux-scsi@vger.kernel.org>; Tue, 17 Mar 2009 19:33:16 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, pjones@redhat.com, michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com

Hello,

Currently, SCSI targets doesn't have modalias support. It wasn't an issue
until SCSI device handler came along.

We want the SCSI device handler modules to be insmodded automatically
when the specific SCSI targets are probed and found.

This set of patches adds the modalias support for SCSI targets and
also makes the relevant changes to SCSI device handler modules to 
make use of it.

Applies cleanly on 2.6.29-rc8 and is tested on the same.

Please review and consider this for 2.6.30.

Thanks & Regards,

chandra

