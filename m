From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 0/1] Another zfcp fix for 2.6.37-rc
Date: Wed, 08 Dec 2010 17:30:45 +0100
Message-ID: <20101208163045.686322948@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:42442 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab0LHQhs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Dec 2010 11:37:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com

James,

i know this is late, but if there will be another merge of scsi fixes
for the 2.6.37-rc cycle, i would like to have this patch included on
top of the previously sent fixes.

The REPORT LUNS scan from the SCSI midlayer works well after we
enabled it with the zfcp changes in 2.6.37-rc1. But we discovered that
we need a way to disable the LUN scan for the zfcpdump userspace tool.
The zfcpdump tool runs in a restricted environment and there is not
enough memory to attach SCSI devices for a large SAN fabric.

Introducing a new zfcp module parameter that is set for zfcpdump is
the best solution to have the REPORT LUNS scan by default and allow to
disable it from zfcpdump.

--
Christof
