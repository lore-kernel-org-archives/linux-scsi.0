From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 0/3] scsi_dh: Add ability to set parameters for scsi device handler
Date: Wed, 01 Jul 2009 20:13:08 -0700
Message-ID: <20090702031308.28354.73353.sendpatchset@chandra-ubuntu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:38253 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbZGBDKf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jul 2009 23:10:35 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e38.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n6237RaE013826
	for <linux-scsi@vger.kernel.org>; Wed, 1 Jul 2009 21:07:27 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n623AccS261744
	for <linux-scsi@vger.kernel.org>; Wed, 1 Jul 2009 21:10:38 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n623AbbW027895
	for <linux-scsi@vger.kernel.org>; Wed, 1 Jul 2009 21:10:38 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dm-devel@redhat.com, michaelc@cs.wisc.edu, agk@redhat.com, James.Bottomley@HansenPartnership.com, Benoit_Arthur@emc.com, asson_ronald@emc.com, berthiaume_wayne@emc.com, Eddie.Williams@steeleye.com, Chandra Seetharaman <sekharan@us.ibm.com>

Hello,

Last week, Eddie Williams reported a regression w.r.t scsi_dh
(http://www.redhat.com/archives/dm-devel/2009-June/msg00285.html).
Parameter setting part of dm multipath handler has been removed
when we moved to scsi device handler.

This set of patches adds an new interface to scsi_dh and uses it.

This patch set applies on 2.6.31-rc1 and the following 2 patches:
	(1) http://patchwork.kernel.org/patch/32646/raw/
	(2) http://patchwork.kernel.org/patch/32647/raw/

This interface part of the patch has been tested.

Eddie,

If you can test it on an EMC storage and respond with your
findings it will be of great help.

Thanks,

chandra

