From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 00/27] zfcp updates for 2.6.32
Date: Tue, 18 Aug 2009 15:43:05 +0200
Message-ID: <20090818134305.841868000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:57144 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543AbZHRNu2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Aug 2009 09:50:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com

James,

here is the series of zfcp updates for the 2.6.32 merge window. Most
patches are concerned with code simplifications and minor
improvements. With these patches, zfcp no longer uses the old
kernel_thread API and no longer semaphores.

The last patch "zfcp: optimize zfcp_qdio_account" uses a new s390
function that is introduced with the s390 patch "introduce
get_clock_monotonic", see http://marc.info/?l=linux-s390&m=125024973232085&w=2
The zfcp patch applies cleanly, but compilation on s390 fails without the
s390 patch. This should be no problem for the linux-next tree, since
linux-next also includes the s390 git tree.

--
Christof Schmitt
