From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 00/19] hpsa driver updates May 8, 2014
Date: Thu, 08 May 2014 14:27:18 -0500
Message-ID: <20140508192239.13481.81880.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:53406 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513AbaEHT3r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 May 2014 15:29:47 -0400
Received: from g4t3425.houston.hp.com (g4t3425.houston.hp.com [15.201.208.53])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id F08EB627EF
	for <linux-scsi@vger.kernel.org>; Thu,  8 May 2014 19:29:10 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: justin.lindley@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, elliott@hp.com, scott.teel@hp.com

Not a lot of extensive changes in this set, some new PCI IDs,
some small bug fixes, quieting some noisy messages, allowing 
more reply queues, setting irq affinity hints, and some minor
locking improvments.

 drivers/scsi/hpsa.c     |  266 +++++++++++++++++++++++++++++------------------
 drivers/scsi/hpsa.h     |   42 ++++---
 drivers/scsi/hpsa_cmd.h |   47 +++-----
 3 files changed, 203 insertions(+), 152 deletions(-)

-- 
-- steve
